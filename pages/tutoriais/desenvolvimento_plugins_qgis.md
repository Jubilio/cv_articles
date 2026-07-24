---
title: "Desenvolvimento de Plugins QGIS com Python"
description: "Manual do básico ao avançado, com estudos de caso do GPX Batch Converter e GeoClick Capture."
---

# Desenvolvimento de Plugins QGIS com Python

**Autor:** Jubílio Filiano Maússe  
**Edição:** 24 de Julho de 2026

Este manual apresenta o ciclo completo de criação de plugins QGIS com Python e PyQGIS, desde a estrutura mínima até tópicos avançados de compatibilidade, segurança, testes, automatização de releases e publicação no repositório oficial do QGIS.

Os estudos de caso são baseados em dois plugins desenvolvidos a partir de necessidades reais:

- [GPX Batch Converter](https://github.com/Jubilio/gpx-batch-converter), orientado à conversão em lote, `QgsTask`, cancelamento, GDAL e relatórios;
- [GeoClick Capture](https://github.com/Jubilio/qgis-latlon), orientado a ferramentas de mapa, snapping, CRS, sessões, geocodificação e painéis laterais.

## Conteúdo principal

- arquitectura e ciclo de vida de plugins;
- `metadata.txt`, `classFactory()`, `initGui()` e `unload()`;
- menus, barras de ferramentas, `QDialog` e `QDockWidget`;
- camadas, geometrias, CRS e formatos GIS;
- tarefas em segundo plano, progresso, cancelamento e logs;
- snapping a vértices e segmentos;
- pedidos de rede com `QgsNetworkAccessManager`;
- compatibilidade QGIS 3/4 e Qt 5/6;
- segurança, testes, empacotamento, CI/CD e publicação;
- projecto prático Quick Point Logger.

## Downloads

- [Descarregar o manual em PDF](https://jubilio.github.io/cv_articles/downloads/qgis-plugin-development-manual/Desenvolvimento_de_Plugins_QGIS_com_Python.pdf)
- [Descarregar a versão editável em Word](https://jubilio.github.io/cv_articles/downloads/qgis-plugin-development-manual/Desenvolvimento_de_Plugins_QGIS_com_Python.docx)
- [Descarregar o pacote-fonte](https://jubilio.github.io/cv_articles/downloads/qgis-plugin-development-manual/qgis-plugin-development-manual-source.zip)
- [Verificar hashes SHA-256](https://jubilio.github.io/cv_articles/downloads/qgis-plugin-development-manual/SHA256SUMS.txt)

## Fonte no GitHub

A fonte provisória está disponível em [`resources/qgis-plugin-development-manual`](https://github.com/Jubilio/cv_articles/tree/main/resources/qgis-plugin-development-manual). Posteriormente, o conteúdo será transferido para um repositório dedicado.

> Os downloads serão gerados automaticamente pelo GitHub Actions após a integração desta actualização na branch `main`.
