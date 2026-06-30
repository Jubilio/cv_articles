---
title: "Mapa de Águas Subterrâneas em Mueda"
---

# Mapa: Potencial de Águas Subterrâneas em Mueda

Este mapa é o produto final da modelação espacial documentada no meu [artigo técnico](../artigos/groundwater_mueda.md).

## O Mapa

```{image} ../../img/Mueda_GW.png
:alt: Mapa de Zonas Potenciais de Águas Subterrâneas - Mueda
:width: 100%
:align: center
```

## Detalhes Técnicos

- **Ferramentas utilizadas:** QGIS, Google Earth Engine, R (para análise estatística prévia).
- **Dados Base:**
  - SRTM DEM (Declive, TWI, Densidade de Drenagem).
  - Imagens Sentinel-2 / Landsat (Uso e Ocupação do Solo).
  - Dados Geológicos e Estruturais (Lineamentos).
- **Metodologia:** Analytic Hierarchy Process (AHP).
- **Sistema de Coordenadas:** WGS 84 / UTM zone 37S (EPSG:32737).

## Interpretação

As áreas a azul escuro (*Muito Alto Potencial*) representam as zonas onde a combinação de fatores geológicos, topográficos e hidrológicos cria as condições ideais para a acumulação e extração de águas subterrâneas. Estas são as áreas prioritárias recomendadas para prospeção.
