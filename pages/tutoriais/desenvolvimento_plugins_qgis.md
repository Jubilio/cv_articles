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

- [Abrir a release mais recente](https://github.com/Jubilio/qgis-plugin-development-manual/releases/latest)
- [Descarregar o manual em PDF](https://github.com/Jubilio/qgis-plugin-development-manual/releases/download/v1.0.0/Desenvolvimento_de_Plugins_QGIS_com_Python.pdf)
- [Descarregar a versão editável em Word](https://github.com/Jubilio/qgis-plugin-development-manual/releases/download/v1.0.0/Desenvolvimento_de_Plugins_QGIS_com_Python.docx)
- [Descarregar o pacote-fonte](https://github.com/Jubilio/qgis-plugin-development-manual/releases/download/v1.0.0/qgis-plugin-development-manual-1.0.0-source.zip)
- [Verificar hashes SHA-256](https://github.com/Jubilio/qgis-plugin-development-manual/releases/download/v1.0.0/SHA256SUMS.txt)

## Fonte no GitHub

O código-fonte, os exemplos, snippets, checklists e workflows estão disponíveis no repositório dedicado [`Jubilio/qgis-plugin-development-manual`](https://github.com/Jubilio/qgis-plugin-development-manual).

Os documentos são reconstruídos e publicados automaticamente através do GitHub Actions.
