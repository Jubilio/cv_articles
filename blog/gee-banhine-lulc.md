---
title: "Classificação de Uso e Cobertura do Solo com Machine Learning no Google Earth Engine: Parque Nacional do Banhine"
date: 2026-07-01
authors:
  - name: Jubílio Filiano Maússe
tags: [GEE, Remote Sensing, Machine Learning, Moçambique, Land Cover]
thumbnail: ../img/banhine/lulc_banhine.png
---

# Classificação de Uso e Cobertura do Solo com Machine Learning no Google Earth Engine

*Estudo de caso: Parque Nacional do Banhine, Gaza, Moçambique*

---

O **Google Earth Engine (GEE)** é uma das plataformas mais poderosas para análise de dados de detecção remota à escala global. Neste tutorial, percorremos um *pipeline* completo de classificação supervisionada de uso e cobertura do solo (LULC) utilizando imagens **Landsat 9** e um classificador de **árvore de decisão (CART)** — tudo directamente na cloud, sem instalação local.

O estudo de caso foca-se no **Parque Nacional do Banhine**, na província de Gaza, um ecossistema de savana e zonas húmidas de importância ecológica excepcional.

## 1. Importação e Filtragem das Imagens

O primeiro passo é importar a colecção de imagens Landsat 9 (`L9`) e filtrá-la pela área de estudo (`banhine`) e pelo ano de análise.

```javascript
var L8_Collection = L9
      .filterBounds(banhine)
      .filterDate('2024-01-01', '2024-12-31');
```

> **Nota:** A variável `banhine` deve ser importada como uma `FeatureCollection` ou `Geometry` do GEE — por exemplo, desenhando um polígono no mapa ou importando um shapefile dos limites do parque.

---

## 2. Remoção de Nuvens

Nuvens contaminam os píxeis e introduzem erros na classificação. Usamos o algoritmo `simpleCloudScore` do GEE com um limiar de 3%:

```javascript
var cloud_thresh = 0.03;

var cloudfunction = function(image) {
  var cloudScore = ee.Algorithms.Landsat.simpleCloudScore(image);
  var quality = cloudScore.select('cloud');
  var cloud1 = quality.gt(cloud_thresh);
  var cloudmask = image.mask().and(cloud1.not());
  return image.mask(cloudmask);
};

var L8_B_2019N = L8_Collection.map(cloudfunction);
var median_L8 = L8_B_2019N.median();
```

A função `.median()` cria uma imagem composta usando o valor mediano de cada píxel ao longo de todos os meses — uma técnica eficaz para suprimir ruído residual de nuvens.

---

## 3. Cálculo de Índices Espectrais

Os índices espectrais amplificam diferenças entre tipos de cobertura e melhoram significativamente a precisão da classificação.

### NDVI — Índice de Vegetação por Diferença Normalizada

$$
NDVI = \frac{NIR - RED}{NIR + RED}
$$

```javascript
var NDVI = median_L8.expression(
    '(NIR - RED) / (NIR + RED)', {
      'NIR': median_L8.select('B5'),
      'RED': median_L8.select('B4'),
    }).rename('NDVI');
```

### EVI2 — Índice de Vegetação Melhorado

$$
EVI2 = 2.5 \times \frac{NIR - RED}{NIR + 2.4 \times RED + 1}
$$

```javascript
var EVI2 = median_L8.expression(
  '2.5 * ((NIR - RED) / (NIR + (2.4 * RED) + 1))', {
    'NIR': median_L8.select('B5'),
    'RED': median_L8.select('B4'),
  }).rename('EVI2');
```

### SAVI — Índice de Vegetação Ajustado ao Solo

$$
SAVI = \frac{(NIR - RED)}{(NIR + RED + L)} \times (1 + L), \quad L = 0.5
$$

```javascript
var SAVI = median_L8.expression(
  '((NIR - RED) / (NIR + RED + L)) * (1 + L)', {
    'NIR': median_L8.select('B5'),
    'RED': median_L8.select('B4'),
    'L': 0.5
}).rename('SAVI');
```

### NDWI — Índice de Água por Diferença Normalizada

$$
NDWI = \frac{GREEN - NIR}{GREEN + NIR}
$$

```javascript
var NDWI = median_L8.expression(
  '(G - NIR) / (G + NIR)', {
    'G': median_L8.select('B3'),
    'NIR': median_L8.select('B5')
  }).rename('NDWI');
```

---

## 4. Composição Final e Adição de Variáveis Topográficas

Para além dos índices espectrais, o modelo incorpora **elevação** e **declive** derivados do ALOS DEM (30 m), o que melhora a separação entre classes como floresta de encosta e solo exposto:

```javascript
var alos = ee.Image("JAXA/ALOS/AW3D30/V2_2");

var addIndices = function(image) {
  var EVI2 = image.expression(
    '2.5 * ((NIR - RED) / (NIR + (2.4 * RED) + 1))',
    {'NIR': image.select('B5'), 'RED': image.select('B4')}
  ).rename('EVI2');
  var NDVI = image.expression(
    '(NIR - RED) / (NIR + RED)',
    {'NIR': image.select('B5'), 'RED': image.select('B4')}
  ).rename('NDVI');
  return image.addBands(EVI2).addBands(NDVI);
};

var composite = addIndices(median_L8.clip(banhine));
var elev  = alos.select('AVE_DSM').divide(2000).rename('elev');
var slope = ee.Terrain.slope(alos.select('AVE_DSM')).divide(30).rename('slope');
var composite = composite.addBands(elev).addBands(slope);
```

> **Porquê normalizar?** Dividir a elevação por 2000 e o declive por 30 coloca ambas as variáveis numa escala comparável às bandas espectrais (0–1), evitando que dominem o classificador.

---

## 5. Amostras de Treino e Validação

As amostras de campo (`gcp`) foram recolhidas para quatro classes: **floresta**, **plano de água**, **solo exposto** e **pastagem/savana**. A divisão aleatória garante uma avaliação independente:

```javascript
var gcp = greenForest.merge(waterBody).merge(soil).merge(grass);
var gcp = gcp.randomColumn();

// 40% para treino, 30% para validação
var trainingGCP   = gcp.filter(ee.Filter.lt('random', 0.4));
var validationGCP = gcp.filter(ee.Filter.gte('random', 0.7));

var training = composite.sampleRegions({
  collection: trainingGCP,
  properties: ['properties'],
  scale: 10,
  tileScale: 16
});
```

---

## 6. Treino do Classificador CART

O algoritmo **CART (Classification and Regression Trees)** constrói uma árvore de decisão binária que divide os dados com base nos índices espectrais e topográficos:

```javascript
var classifier = ee.Classifier.smileCart(10)
    .train({
      features: training,
      classProperty: 'properties',
      inputProperties: composite.bandNames()
    });

var classified = composite.classify(classifier);
```

---

## 7. Avaliação da Precisão

A **matriz de confusão** é a forma padrão de avaliar a qualidade de uma classificação supervisionada:

```javascript
var test = classified.sampleRegions({
  collection: validationGCP,
  properties: ['properties'],
  scale: 10,
  tileScale: 16
});

var testConfusionMatrix = test.errorMatrix('properties', 'classification');
print('Confusion Matrix', testConfusionMatrix);
print('Test Accuracy', testConfusionMatrix.accuracy());
```

---

## 8. Ajuste de Hiperparâmetros (*Hyperparameter Tuning*)

Para encontrar o número óptimo de árvores de decisão, testamos valores entre 10 e 120 e representamos graficamente a precisão de validação:

```javascript
var numTreesList = ee.List.sequence(10, 120, 10);

var accuracies = numTreesList.map(function(numTrees){
  var classifier = ee.Classifier.smileCart(numTrees)
    .train({
      features: training,
      classProperty: 'properties',
      inputProperties: composite.bandNames()
    });
  return test
    .classify(classifier)
    .errorMatrix('properties', 'classification')
    .accuracy();
});

var chart = ui.Chart.array.values({
  array: ee.Array(accuracies),
  axis: 0,
  xLabels: numTreesList
}).setOptions({
  title: 'Hyperparameter Tuning — numberOfTrees',
  vAxis: {title: 'Validation Accuracy'},
  hAxis: {title: 'Number of Trees', gridlines: {count: 15}}
});

print(chart);
```

O gráfico gerado pelo GEE permite identificar visualmente o ponto de *diminishing returns* — o número de árvores a partir do qual a precisão se estabiliza.

```{figure} ../img/banhine/grafico_tuning.png
:name: fig-tuning
:width: 80%
:align: center

Gráfico de optimização do número de árvores (numberOfTrees) no modelo CART, mostrando a evolução da precisão com o aumento de estimadores.
```

---

## 9. Exportação e Visualização

O mapa classificado e os índices são exportados para o Google Drive em formato **GeoTIFF Cloud Optimized**:

```javascript
Export.image.toDrive({
  image: EVI2,
  description: 'EVI_2024_Banhine',
  folder: 'Banhine',
  scale: 30,
  crs: 'EPSG:4326',
  region: banhine,
  fileFormat: 'GeoTIFF',
  formatOptions: { cloudOptimized: true }
});
```

As camadas são adicionadas ao mapa interactivo do GEE:

```javascript
Map.addLayer(classified,
  {min:0, max:5,
   palette: ['green', 'blue', 'red', 'lightgreen', '#FF0000', '#5F9EA0']},
  'Land Cover 2024');

Map.addLayer(NDWI.clip(banhine), siVis, 'NDWI');
Map.addLayer(EVI2.clip(banhine), siVis, 'EVI2');
Map.addLayer(NDVI.clip(banhine), siVis, 'NDVI');
Map.addLayer(SAVI.clip(banhine), siVis, 'SAVI');
Map.centerObject(banhine, 8);
```

| Classe            | Cor        | Código |
| :---------------- | :--------- | -----: |
| Floresta densa    | Verde      | 0      |
| Plano de água     | Azul       | 1      |
| Solo exposto      | Vermelho   | 2      |
| Savana/Pastagem   | Verde claro| 3      |
| Área queimada     | Vermelho   | 4      |
| Zona húmida       | Azul-verde | 5      |

### Resultados Visuais

Abaixo podemos observar o resultado da classificação final e os principais índices de vegetação calculados para a área do Parque Nacional do Banhine:

:::{card}
```{figure} ../img/banhine/lulc_banhine.png
:name: fig-banhine-lulc
:width: 100%

Mapa final de Uso e Cobertura do Solo (LULC) em 2024 classificado via CART no Google Earth Engine.
```
:::

::::{grid} 1 2 2 3

:::{card}
```{figure} ../img/banhine/ndvi.png
:name: fig-banhine-ndvi
:width: 100%

NDVI (Índice de Vegetação por Diferença Normalizada).
```
:::

:::{card}
```{figure} ../img/banhine/evi2.png
:name: fig-banhine-evi2
:width: 100%

EVI2 (Índice de Vegetação Melhorado).
```
:::

:::{card}
```{figure} ../img/banhine/savi.png
:name: fig-banhine-savi
:width: 100%

SAVI (Índice de Vegetação Ajustado ao Solo).
```
:::

::::

---

## Conclusão

Este *pipeline* demonstra como o Google Earth Engine permite, em poucas linhas de código JavaScript:

1. **Adquirir e pré-processar** imagens de satélite sem transferência de dados para o computador local
2. **Calcular índices espectrais** (NDVI, EVI2, SAVI, NDWI) que caracterizam diferentes tipos de cobertura
3. **Treinar e avaliar** um classificador supervisionado com validação cruzada
4. **Optimizar hiperparâmetros** de forma iterativa com visualização imediata

O código está disponível para reutilização. Para adaptar ao seu estudo de caso, basta substituir a variável `banhine` pela sua área de interesse e as amostras de campo pelas suas classes de cobertura.

---

*Código desenvolvido para análise de detecção remota no âmbito de estudos de cobertura do solo em Moçambique.*
