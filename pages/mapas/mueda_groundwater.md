---
title: "Mapa de Águas Subterrâneas em Mueda"
description: "Produto cartográfico do modelo de potencial de águas subterrâneas baseado em sensoriamento remoto, AHP e validação com pontos de água."
---

# Mapa de Potencial de Águas Subterrâneas em Mueda

Este mapa é o produto final da modelação espacial documentada no meu [artigo técnico](../artigos/groundwater_mueda.md).

## O mapa

```{image} ../../img/Mueda_GW.png
:alt: Mapa de zonas potenciais de águas subterrâneas em Mueda
:width: 100%
:align: center
```

## O problema

O distrito de Mueda encontra-se numa região de planalto onde a disponibilidade de água subterrânea é espacialmente variável. O estudo procura apoiar a identificação preliminar de áreas mais favoráveis à prospecção, sem substituir levantamentos hidrogeológicos e geofísicos de campo.

## Métodos e dados

- **Ferramentas:** Google Earth Engine, ArcGIS Pro, QGIS e R.
- **Variáveis:** precipitação, geologia, índice topográfico de humidade, densidade de drenagem, densidade de lineamentos, uso e cobertura do solo e declive.
- **Método:** Analytic Hierarchy Process (AHP) e sobreposição ponderada.
- **Validação:** comparação com pontos de água disponíveis.
- **Sistema de coordenadas:** WGS 84 / UTM zone 37S (EPSG:32737).

## Interpretação responsável

O resultado final está organizado em **quatro classes de potencial**. O modelo não produziu uma classe “Muito Alto”. As zonas de maior favorabilidade relativa devem ser entendidas como áreas prioritárias para investigação adicional, e não como garantia de água ou de produtividade de um futuro furo.

A validação também é limitada pela distribuição dos pontos observados, concentrados em algumas áreas do distrito. Qualquer decisão de perfuração deve incorporar estudos hidrogeológicos, geofísica, qualidade da água, acessibilidade e condições locais.

## O que o projecto demonstra

- integração de dados raster e vectoriais de múltiplas fontes;
- construção e documentação de pesos AHP;
- análise espacial reproduzível;
- validação independente com dados observados;
- comunicação explícita das incertezas e limitações.

---

[Ler o artigo completo →](../artigos/groundwater_mueda.md) · [Explorar outros projectos →](../projectos/portfolio.md)
