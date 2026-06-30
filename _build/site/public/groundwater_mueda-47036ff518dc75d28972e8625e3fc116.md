* col1col2col3

---
title: "Mapeamento de Zonas Potenciais de Águas Subterrâneas em Mueda"
exports:
  - format: pdf
    template: lapreprint-typst
    output: groundwater_mueda.pdf
---
# Mapeamento de Zonas Potenciais de Águas Subterrâneas no Distrito de Mueda, Norte de Moçambique: Integração de Sensoriamento Remoto, AHP em SIG e Validação com Fontes de Água

**Autor:** Jubílio Filiano Maússe*Investigador Independente | Oficial Sénior de Dados e GIS, REACH Initiative, Moçambique*

> **Nota de independência institucional:** Este estudo foi desenvolvido de forma independente pelo autor. As opiniões, análises e conclusões apresentadas são da exclusiva responsabilidade do autor e não representam oficialmente a REACH Initiative, a Universidade Eduardo Mondlane ou qualquer outra instituição.

## Resumo

As águas subterrâneas constituem uma fonte estratégica para o abastecimento de água em regiões com limitada disponibilidade de recursos hídricos superficiais. No distrito de Mueda, em Cabo Delgado, a escassez de informação hidrogeológica detalhada ao nível local limita a identificação de áreas prioritárias para perfuração, reabilitação de furos e gestão sustentável da água. Este artigo propõe uma metodologia integrada baseada em Sensoriamento Remoto, Sistemas de Informação Geográfica e Análise Multicritério para mapear zonas de potencial de águas subterrâneas no distrito de Mueda. Foram considerados sete factores condicionantes: precipitação, geologia, índice topográfico de humidade, densidade de drenagem, densidade de lineamentos, uso e cobertura da terra e tipo de solo. Estes factores foram normalizados, ponderados por meio do Processo Analítico Hierárquico e integrados por sobreposição ponderada em ambiente SIG. A matriz AHP apresentou uma razão de consistência de 0,100, indicando consistência aceitável dos julgamentos utilizados na ponderação dos critérios. O mapa final indicou o predomínio das classes de baixo e moderado potencial, correspondendo a 53,70% e 42,30% da área analisada, respectivamente. A classe de alto potencial representou 3,99%, enquanto a classe de muito baixo potencial foi residual, com 0,002%. A classe de potencial muito alto não foi observada no distrito. A validação espacial foi realizada com 17 pontos de água obtidos a partir do Sistema Nacional de Informação de Água e Saneamento. O estudo pretende contribuir para o planeamento hidrogeológico local e apoiar decisões técnicas sobre captação e gestão de águas subterrâneas em Mueda.

**Palavras-chave:** águas subterrâneas; potencial hidrogeológico; sensoriamento remoto; SIG; AHP; Mueda; Cabo Delgado; Moçambique; fontes de água.

---

## Abstract

Groundwater is a strategic water supply source in regions with limited surface water availability. In Mueda District, Cabo Delgado Province, Mozambique, the lack of detailed local hydrogeological information constrains the identification of priority areas for borehole drilling, rehabilitation, and sustainable groundwater management. This paper proposes an integrated methodology based on Remote Sensing, Geographic Information Systems, and Multi-Criteria Decision Analysis to map groundwater potential zones in Mueda District. The seven conditioning factors considered were rainfall, geology, topographic wetness index, drainage density, lineament density, land use and land cover, and soil type. These factors were standardized, weighted using the Analytical Hierarchy Process, and integrated through GIS-based weighted overlay analysis. The AHP matrix produced a consistency ratio of 0.100, indicating acceptable consistency of the pairwise comparisons. The final map indicated a predominance of low and moderate groundwater potential classes, representing 53.70% and 42.30% of the analysed area, respectively. The high potential class accounted for 3.99%, while the very low potential class was residual, representing 0.002%. No very high potential class was observed within Mueda District. Spatial validation was conducted using 17 water points obtained from the National Water and Sanitation Information System. The study aims to support local hydrogeological planning and evidence-based decision-making for groundwater development in Mueda.

**Keywords:** groundwater potential; hydrogeological potential; remote sensing; GIS; AHP; Mueda; Cabo Delgado; Mozambique; water points.

---

## 1. Introdução

As águas subterrâneas desempenham um papel fundamental no abastecimento doméstico, agrícola e institucional, particularmente em regiões onde os recursos hídricos superficiais são sazonais, escassos ou vulneráveis a variações climáticas. Em ambientes tropicais e semiáridos, a ocorrência de águas subterrâneas é controlada por uma combinação de factores geológicos, geomorfológicos, climáticos, hidrológicos e antrópicos [@allafta2021; @elsherbini2025].

O uso integrado de Sensoriamento Remoto e Sistemas de Informação Geográfica tem sido amplamente aplicado à identificação de zonas potenciais de águas subterrâneas, sobretudo em contextos em que os dados de campo são limitados [@arabameri2019; @nainggolan2024]. Esta abordagem permite combinar variáveis espaciais, como litologia, lineamentos, declividade, densidade de drenagem, precipitação, solos, uso e cobertura da terra, e índices derivados de imagens de satélite.

No caso de Cabo Delgado, existem produtos cartográficos regionais que indicam zonas gerais de potencial de águas subterrâneas. Contudo, tais produtos apresentam limitações para decisões distritais, pois a sua escala pode não capturar variações locais relevantes para perfuração, reabilitação de pontos de água e planeamento hídrico. Assim, torna-se necessário desenvolver uma análise mais detalhada para o distrito de Mueda.

### 1.1 Problema e Questão de Pesquisa

Apesar da importância das águas subterrâneas para o abastecimento de água em Mueda, ainda há limitada disponibilidade de mapas hidrogeológicos detalhados ao nível distrital. Esta limitação dificulta a identificação de áreas favoráveis à perfuração de furos e à gestão sustentável dos recursos hídricos subterrâneos.
A principal questão que orienta o estudo é: *Até que ponto a integração de Sensoriamento Remoto, SIG e Análise Multicritério permite identificar zonas favoráveis à ocorrência de águas subterrâneas no distrito de Mueda?*

### 1.2 Hipóteses

- **H1:** As zonas de maior potencial de águas subterrâneas em Mueda estão associadas a maior disponibilidade de precipitação, litologias favoráveis, maior índice topográfico de humidade, densidade de drenagem adequada e presença de lineamentos estruturais que favorecem a infiltração e circulação subterrânea.
- **H2:** A integração de Sensoriamento Remoto, SIG e AHP permite produzir um mapa mais detalhado e operacional do que mapas provinciais generalizados.
- **H3:** O mapa gerado apresenta correspondência espacial significativa com a localização de fontes de água existentes.

## 2. Área de estudo

O presente estudo foi realizado no distrito de Mueda, localizado na província de Cabo Delgado, no norte de Moçambique. O distrito ocupa uma área de aproximadamente 14.150 km², correspondente a cerca de 17,1% da área total da província de Cabo Delgado, estimada em 82.625 km². A densidade populacional indicada para o distrito é de 14 habitantes por km², valor inferior à média provincial de 31 habitantes por km² [@ine2024mueda].

Do ponto de vista administrativo e geográfico, Mueda limita-se a norte com a República Unida da Tanzânia, a sul com os distritos de Montepuez, Muidumbe e Meluco, a este com o distrito de Mocímboa da Praia e a oeste com o distrito de Mecula, na província do Niassa. O distrito é constituído por vários postos administrativos, incluindo Mueda-Sede, Chapa, Negomano, N'gapa e Imbuho, o que permite uma abordagem espacialmente detalhada para o mapeamento do potencial de águas subterrâneas [@ine2024mueda].

```{figure} ../../img/mapa_area_estudo.png
:name: fig-area-estudo
:align: center
:width: 85%

Mapa da área de estudo no distrito de Mueda, Cabo Delgado, Moçambique.
```

## 3. Materiais e métodos

A metodologia adoptada baseia-se na integração de dados de Sensoriamento Remoto, Sistemas de Informação Geográfica, mapas convencionais e dados de validação de fontes de água para a identificação de zonas de potencial de águas subterrâneas.

### 3.1 Atribuição de pesos pelo Processo Analítico Hierárquico

A consistência da matriz foi avaliada por meio do índice de consistência (CI) e da razão de consistência (CR), calculados pelas seguintes fórmulas:

$$
CI = \frac{\lambda_{max} - n}{n - 1}
$$

$$
CR = \frac{CI}{RI}
$$

Onde $\lambda_{max}$ é o maior autovalor da matriz de comparação, $n$ é o número de critérios e $RI$ é o índice aleatório. Neste estudo, a matriz AHP foi composta por sete critérios e a razão de consistência obtida foi de **0,100**.

| Factor condicionante             | Peso AHP (%) |
| :------------------------------- | :----------- |
| Precipitação                   | 34,3         |
| Geologia                         | 21,7         |
| Índice Topográfico de Humidade | 15,0         |
| Densidade de drenagem            | 8,9          |
| Densidade de lineamentos         | 8,1          |
| Uso e cobertura da terra         | 6,8          |
| Tipo de solo                     | 5,2          |

### 3.2 Integração das camadas e geração do índice GWPZ

O índice de zonas de potencial de águas subterrâneas (GWPZ) foi calculado pela equação:

$$
GWPZ = (0.343 \times P) + (0.217 \times G) + (0.150 \times TWI) + (0.089 \times DD) + (0.081 \times LD) + (0.068 \times LULC) + (0.052 \times S)
$$

Onde $P$ representa precipitação, $G$ geologia, $TWI$ índice topográfico de humidade, $DD$ densidade de drenagem, $LD$ densidade de lineamentos, $LULC$ uso e cobertura da terra e $S$ tipo de solo.

## 4. Resultados

### 4.1 Mapas intermediários dos factores condicionantes

Para apoiar a interpretação do mapa final, foram produzidos mapas intermediários dos factores condicionantes utilizados no modelo.

::::{grid} 1 2 2 2

:::{card}

```{figure}
:name: fig-precipitacao
:width: 100%

Precipitação.
```

:::

:::{card}

```{figure}
:name: fig-dem
:width: 100%

Modelo Digital de Elevação.
```

:::

:::{card}

```{figure}
:name: fig-twi
:width: 100%

Índice Topográfico de Humidade.
```

:::

:::{card}

```{figure}
:name: fig-drenagem
:width: 100%

Densidade de drenagem.
```

:::

::::

::::{grid} 1 2 2 2

:::{card}

```{figure}
:name: fig-geologia
:width: 100%

Geologia.
```

:::

:::{card}

```{figure}
:name: fig-solo
:width: 100%

Tipo de solo.
```

:::

:::{card}

```{figure}
:name: fig-lineamentos
:width: 100%

Densidade de lineamentos.
```

:::

:::{card}

```{figure}
:name: fig-lulc
:width: 100%

Uso e cobertura da terra.
```

:::

::::

### 4.2 Mapa final de zonas potenciais de águas subterrâneas

```{figure}
:name: fig-mapa-final-gwpz
:align: center
:width: 95%

Mapa final de zonas potenciais de águas subterrâneas no distrito de Mueda, Cabo Delgado, com sobreposição dos 17 pontos de água utilizados para validação espacial.
```

### 4.3 Distribuição Espacial

O mapa final de zonas potenciais de águas subterrâneas resultou em quatro classes observadas no distrito. A distribuição espacial mostra que Mueda é dominado pelas classes de baixo e moderado potencial.

| Classe de potencial | Área (ha) | Percentagem (%) |
| :------------------ | :--------- | :-------------- |
| Muito baixo         | 22,72      | 0,002           |
| Baixo               | 601.833,01 | 53,70           |
| Moderado            | 474.064,49 | 42,30           |
| Alto                | 44.723,01  | 3,99            |

## 5. Discussão

Os resultados indicam que Mueda é predominantemente caracterizado por potencial baixo e moderado de águas subterrâneas. A classe baixa representou 53,70% da área, enquanto a classe alta correspondeu a apenas 3,99%. Esta distribuição sugere que o potencial hidrogeológico de Mueda é fortemente condicionado por limitações fisiográficas, incluindo relevo elevado e características de planalto.

A sobreposição dos 17 pontos de água com o mapa final mostrou que estas infraestruturas se encontram predominantemente em áreas classificadas como de potencial moderado e baixo. Este padrão indica que, em Mueda, a implantação das fontes de água não está necessariamente concentrada nas zonas de maior favorabilidade natural, mas sim em áreas onde a conjugação de acessibilidade, necessidades locais e infraestruturas preexistentes ditaram a captação.

## 6. Conclusão

O presente estudo demonstrou a utilidade da integração de Sensoriamento Remoto, SIG e AHP para o mapeamento hidrogeológico. Os resultados reforçam que a disponibilidade climática de recarga (precipitação), as características litológicas (geologia) e a topografia (TWI) são os grandes condicionadores em Mueda.

O mapa produzido constitui uma ferramenta útil para apoio à decisão, orientando a identificação preliminar de áreas para investigação geofísica e planeamento de recursos hídricos. No entanto, o modelo deve ser utilizado como um instrumento de triagem espacial e não substitui levantamentos hidrogeológicos de detalhe em campo.