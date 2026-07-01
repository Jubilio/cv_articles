// Created with jtex v.1.0.21
#import "@preview/marge:0.1.0"
#import "style.typ": template
#import "aside_style.typ": aside
#show: template.with(

// title
  title: "Mapeamento de Zonas Potenciais de Águas Subterrâneas em Mueda",

// subtitle

// authors
  authors: "Jubílio Filiano Maússe",


// logo for top page

// specify the with of the logo


// cover picture





//specify depth of table of contents





//Page settings













)



#import "myst-imports.typ": *

/* Written by MyST v1.10.1 */

= Mapeamento de Zonas Potenciais de Águas Subterrâneas no Distrito de Mueda, Norte de Moçambique: Integração de Sensoriamento Remoto, AHP em SIG e Validação com Fontes de Água <mapeamento-de-zonas-potenciais-de-guas-subterr-neas-no-distrito-de-mueda-norte-de-mo-ambique-integra-o-de-sensoriamento-remoto-ahp-em-sig-e-valida-o-com-fontes-de-gua>

*Autor:* Jubílio Filiano Maússe | _Investigador Independente | Oficial Sénior de Dados e GIS, REACH Initiative, Moçambique_

#link("https://jubilio.github.io/cv\_articles/public/articles/Mausse\_2026\_Groundwater\_Potential\_Mueda.pdf")[📥 *Descarregar Artigo Completo em PDF*]

#quote(block: true)[*Nota de independência institucional:* Este estudo foi desenvolvido de forma independente pelo autor. As opiniões, análises e conclusões apresentadas são da exclusiva responsabilidade do autor e não representam oficialmente a REACH Initiative, a Universidade Eduardo Mondlane ou qualquer outra instituição.]= Resumo <resumo>

As águas subterrâneas constituem uma fonte estratégica para o abastecimento de água em regiões com limitada disponibilidade de recursos hídricos superficiais. No distrito de Mueda, em Cabo Delgado, a escassez de informação hidrogeológica detalhada ao nível local limita a identificação de áreas prioritárias para perfuração, reabilitação de furos e gestão sustentável da água. Este artigo propõe uma metodologia integrada baseada em Sensoriamento Remoto, Sistemas de Informação Geográfica e Análise Multicritério para mapear zonas de potencial de águas subterrâneas no distrito de Mueda. Foram considerados sete factores condicionantes: precipitação, geologia, índice topográfico de humidade, densidade de drenagem, densidade de lineamentos, uso e cobertura da terra e tipo de solo. Estes factores foram normalizados, ponderados por meio do Processo Analítico Hierárquico e integrados por sobreposição ponderada em ambiente SIG. A matriz AHP apresentou uma razão de consistência de 0,100, indicando consistência aceitável dos julgamentos utilizados na ponderação dos critérios. O mapa final indicou o predomínio das classes de baixo e moderado potencial, correspondendo a 53,70% e 42,30% da área analisada, respectivamente. A classe de alto potencial representou 3,99%, enquanto a classe de muito baixo potencial foi residual, com 0,002%. A classe de potencial muito alto não foi observada no distrito. A validação espacial foi realizada com 17 pontos de água obtidos a partir do Sistema Nacional de Informação de Água e Saneamento. O estudo pretende contribuir para o planeamento hidrogeológico local e apoiar decisões técnicas sobre captação e gestão de águas subterrâneas em Mueda.

*Palavras-chave:* águas subterrâneas\; potencial hidrogeológico\; sensoriamento remoto\; SIG\; AHP\; Mueda\; Cabo Delgado\; Moçambique\; fontes de água.

#line(length: 100%, stroke: gray)

= Abstract <abstract>

Groundwater is a strategic water supply source in regions with limited surface water availability. In Mueda District, Cabo Delgado Province, Mozambique, the lack of detailed local hydrogeological information constrains the identification of priority areas for borehole drilling, rehabilitation, and sustainable groundwater management. This paper proposes an integrated methodology based on Remote Sensing, Geographic Information Systems, and Multi-Criteria Decision Analysis to map groundwater potential zones in Mueda District. The seven conditioning factors considered were rainfall, geology, topographic wetness index, drainage density, lineament density, land use and land cover, and soil type. These factors were standardized, weighted using the Analytical Hierarchy Process, and integrated through GIS-based weighted overlay analysis. The AHP matrix produced a consistency ratio of 0.100, indicating acceptable consistency of the pairwise comparisons. The final map indicated a predominance of low and moderate groundwater potential classes, representing 53.70% and 42.30% of the analysed area, respectively. The high potential class accounted for 3.99%, while the very low potential class was residual, representing 0.002%. No very high potential class was observed within Mueda District. Spatial validation was conducted using 17 water points obtained from the National Water and Sanitation Information System. The study aims to support local hydrogeological planning and evidence-based decision-making for groundwater development in Mueda.

*Keywords:* groundwater potential\; hydrogeological potential\; remote sensing\; GIS\; AHP\; Mueda\; Cabo Delgado\; Mozambique\; water points.

#line(length: 100%, stroke: gray)

= 1. Introdução <id-1-introdu-o>

As águas subterrâneas desempenham um papel fundamental no abastecimento doméstico, agrícola e institucional, particularmente em regiões onde os recursos hídricos superficiais são sazonais, escassos ou vulneráveis a variações climáticas. Em ambientes tropicais e semiáridos, a ocorrência de águas subterrâneas é controlada por uma combinação de factores geológicos, geomorfológicos, climáticos, hidrológicos e antrópicos #cite(<allafta2021>) #cite(<elsherbini2025>).

O uso integrado de Sensoriamento Remoto e Sistemas de Informação Geográfica tem sido amplamente aplicado à identificação de zonas potenciais de águas subterrâneas, sobretudo em contextos em que os dados de campo são limitados #cite(<arabameri2019>) #cite(<nainggolan2024>). Esta abordagem permite combinar variáveis espaciais, como litologia, lineamentos, declividade, densidade de drenagem, precipitação, solos, uso e cobertura da terra, e índices derivados de imagens de satélite.

No caso de Cabo Delgado, existem produtos cartográficos regionais que indicam zonas gerais de potencial de águas subterrâneas. Contudo, tais produtos apresentam limitações para decisões distritais, pois a sua escala pode não capturar variações locais relevantes para perfuração, reabilitação de pontos de água e planeamento hídrico. Assim, torna-se necessário desenvolver uma análise mais detalhada para o distrito de Mueda.

== 1.1 Problema e Questão de Pesquisa <id-1-1-problema-e-quest-o-de-pesquisa>

Apesar da importância das águas subterrâneas para o abastecimento de água em Mueda, ainda há limitada disponibilidade de mapas hidrogeológicos detalhados ao nível distrital. Esta limitação dificulta a identificação de áreas favoráveis à perfuração de furos e à gestão sustentável dos recursos hídricos subterrâneos. A principal questão que orienta o estudo é: _Até que ponto a integração de Sensoriamento Remoto, SIG e Análise Multicritério permite identificar zonas favoráveis à ocorrência de águas subterrâneas no distrito de Mueda?_

== 1.2 Hipóteses <id-1-2-hip-teses>

- *H1:* As zonas de maior potencial de águas subterrâneas em Mueda estão associadas a maior disponibilidade de precipitação, litologias favoráveis, maior índice topográfico de humidade, densidade de drenagem adequada e presença de lineamentos estruturais que favorecem a infiltração e circulação subterrânea.
- *H2:* A integração de Sensoriamento Remoto, SIG e AHP permite produzir um mapa mais detalhado e operacional do que mapas provinciais generalizados.
- *H3:* O mapa gerado apresenta correspondência espacial significativa com a localização de fontes de água existentes.

= 2. Área de estudo <id-2-rea-de-estudo>

O presente estudo foi realizado no distrito de Mueda, localizado na província de Cabo Delgado, no norte de Moçambique. O distrito ocupa uma área de aproximadamente 14.150 km², correspondente a cerca de 17,1% da área total da província de Cabo Delgado, estimada em 82.625 km². A densidade populacional indicada para o distrito é de 14 habitantes por km², valor inferior à média provincial de 31 habitantes por km² #cite(<ine2024mueda>).

Do ponto de vista administrativo e geográfico, Mueda limita-se a norte com a República Unida da Tanzânia, a sul com os distritos de Montepuez, Muidumbe e Meluco, a este com o distrito de Mocímboa da Praia e a oeste com o distrito de Mecula, na província do Niassa. O distrito é constituído por vários postos administrativos, incluindo Mueda-Sede, Chapa, Negomano, N'gapa e Imbuho, o que permite uma abordagem espacialmente detalhada para o mapeamento do potencial de águas subterrâneas #cite(<ine2024mueda>).

#show figure: set block(breakable: breakableDefault)
#figure([
],
  caption: [
Mapa da área de estudo no distrito de Mueda, Cabo Delgado, Moçambique.
],
  kind: "figure",
  supplement: [Figure],
) <fig-area-estudo>

= 3. Materiais e métodos <id-3-materiais-e-m-todos>

A metodologia adoptada baseia-se na integração de dados de Sensoriamento Remoto, Sistemas de Informação Geográfica, mapas convencionais e dados de validação de fontes de água para a identificação de zonas de potencial de águas subterrâneas.

== 3.1 Dados e Software <id-3-1-dados-e-software>

O processamento foi realizado com as seguintes ferramentas:

- *Google Earth Engine (GEE):* Plataforma de computação em nuvem utilizada para aquisição e pré-processamento de imagens de satélite (Sentinel-2, Landsat), cálculo do índice LULC e extracção de dados de precipitação (CHIRPS). O GEE permitiu processar grandes volumes de dados de detecção remota sem necessidade de armazenamento local.
- *ArcGIS Pro:* Software SIG utilizado para a análise espacial principal, incluindo a geração e reclassificação das camadas condicionantes (DEM/SRTM, densidade de drenagem, densidade de lineamentos, geologia, tipo de solo), aplicação da álgebra de mapas, sobreposição ponderada AHP e produção da cartografia final.
- *Microsoft Excel:* Utilizado para o cálculo da matriz AHP, determinação dos pesos dos critérios e verificação da razão de consistência (CR = 0,100).

Os dados utilizados incluem:

#tablex(columns: 3, header-rows: 1, repeat-header: true, ..tableStyle, ..columnStyle,
cellx(align: left, )[
Dado
],
cellx(align: left, )[
Fonte
],
cellx(align: left, )[
Resolução / Escala
],
cellx(align: left, )[
SRTM DEM
],
cellx(align: left, )[
NASA / USGS
],
cellx(align: left, )[
30 m
],
cellx(align: left, )[
Imagens Sentinel-2 / Landsat
],
cellx(align: left, )[
Google Earth Engine
],
cellx(align: left, )[
10–30 m
],
cellx(align: left, )[
Precipitação (CHIRPS)
],
cellx(align: left, )[
UCSB Climate Hazards Group
],
cellx(align: left, )[
$tilde$5 km
],
cellx(align: left, )[
Geologia
],
cellx(align: left, )[
Carta Geológica 1:1.000.000
],
cellx(align: left, )[
1:1.000.000
],
cellx(align: left, )[
Tipo de solo
],
cellx(align: left, )[
SoilGrids / FAO
],
cellx(align: left, )[
250 m
],
cellx(align: left, )[
Pontos de água (SINAS)
],
cellx(align: left, )[
DNA — Moçambique
],
cellx(align: left, )[
Pontual
],
)
== 3.2 Atribuição de pesos pelo Processo Analítico Hierárquico <id-3-2-atribui-o-de-pesos-pelo-processo-anal-tico-hier-rquico>

A consistência da matriz foi avaliada por meio do índice de consistência (CI) e da razão de consistência (CR), calculados pelas seguintes fórmulas:

$ C I = frac(lambda_(m a x) -n, n -1) $
$ C R = frac(C I, R I) $
Onde $lambda_(m a x)$ é o maior autovalor da matriz de comparação, $n$ é o número de critérios e $R I$ é o índice aleatório. Neste estudo, a matriz AHP foi composta por sete critérios e a razão de consistência obtida foi de *0,100*.

#tablex(columns: 2, header-rows: 1, repeat-header: true, ..tableStyle, ..columnStyle,
cellx(align: left, )[
Factor condicionante
],
cellx(align: left, )[
Peso AHP (%)
],
cellx(align: left, )[
Precipitação
],
cellx(align: left, )[
34,3
],
cellx(align: left, )[
Geologia
],
cellx(align: left, )[
21,7
],
cellx(align: left, )[
Índice Topográfico de Humidade
],
cellx(align: left, )[
15,0
],
cellx(align: left, )[
Densidade de drenagem
],
cellx(align: left, )[
8,9
],
cellx(align: left, )[
Densidade de lineamentos
],
cellx(align: left, )[
8,1
],
cellx(align: left, )[
Uso e cobertura da terra
],
cellx(align: left, )[
6,8
],
cellx(align: left, )[
Tipo de solo
],
cellx(align: left, )[
5,2
],
)
== 3.3 Integração das camadas e geração do índice GWPZ <id-3-3-integra-o-das-camadas-e-gera-o-do-ndice-gwpz>

O índice de zonas de potencial de águas subterrâneas (GWPZ) foi calculado pela equação:

$ G W P Z = (0. 343 times P) + (0. 217 times G) + (0. 150 times T W I) + (0. 089 times D D) + (0. 081 times L D) + (0. 068 times L U L C) + (0. 052 times S) $
Onde $P$ representa precipitação, $G$ geologia, $T W I$ índice topográfico de humidade, $D D$ densidade de drenagem, $L D$ densidade de lineamentos, $L U L C$ uso e cobertura da terra e $S$ tipo de solo.

= 4. Resultados <id-4-resultados>

== 4.1 Mapas intermediários dos factores condicionantes <id-4-1-mapas-intermedi-rios-dos-factores-condicionantes>

Para apoiar a interpretação do mapa final, foram produzidos mapas intermediários dos factores condicionantes utilizados no modelo.

== 4.2 Mapa final de zonas potenciais de águas subterrâneas <id-4-2-mapa-final-de-zonas-potenciais-de-guas-subterr-neas>

#show figure: set block(breakable: breakableDefault)
#figure([
],
  caption: [
Mapa final de zonas potenciais de águas subterrâneas no distrito de Mueda, Cabo Delgado, com sobreposição dos 17 pontos de água utilizados para validação espacial.
],
  kind: "figure",
  supplement: [Figure],
) <fig-mapa-final-gwpz>

== 4.3 Distribuição Espacial <id-4-3-distribui-o-espacial>

O mapa final de zonas potenciais de águas subterrâneas resultou em quatro classes observadas no distrito. A distribuição espacial mostra que Mueda é dominado pelas classes de baixo e moderado potencial.

#tablex(columns: 3, header-rows: 1, repeat-header: true, ..tableStyle, ..columnStyle,
cellx(align: left, )[
Classe de potencial
],
cellx(align: left, )[
Área (ha)
],
cellx(align: left, )[
Percentagem (%)
],
cellx(align: left, )[
Muito baixo
],
cellx(align: left, )[
22,72
],
cellx(align: left, )[
0,002
],
cellx(align: left, )[
Baixo
],
cellx(align: left, )[
601.833,01
],
cellx(align: left, )[
53,70
],
cellx(align: left, )[
Moderado
],
cellx(align: left, )[
474.064,49
],
cellx(align: left, )[
42,30
],
cellx(align: left, )[
Alto
],
cellx(align: left, )[
44.723,01
],
cellx(align: left, )[
3,99
],
)
= 5. Discussão <id-5-discuss-o>

Os resultados indicam que Mueda é predominantemente caracterizado por potencial baixo e moderado de águas subterrâneas. A classe baixa representou 53,70% da área, enquanto a classe alta correspondeu a apenas 3,99%. Esta distribuição sugere que o potencial hidrogeológico de Mueda é fortemente condicionado por limitações fisiográficas, incluindo relevo elevado e características de planalto.

A sobreposição dos 17 pontos de água com o mapa final mostrou que estas infraestruturas se encontram predominantemente em áreas classificadas como de potencial moderado e baixo. Este padrão indica que, em Mueda, a implantação das fontes de água não está necessariamente concentrada nas zonas de maior favorabilidade natural, mas sim em áreas onde a conjugação de acessibilidade, necessidades locais e infraestruturas preexistentes ditaram a captação.

= 6. Conclusão <id-6-conclus-o>

O presente estudo demonstrou a utilidade da integração de Sensoriamento Remoto, SIG e AHP para o mapeamento hidrogeológico. Os resultados reforçam que a disponibilidade climática de recarga (precipitação), as características litológicas (geologia) e a topografia (TWI) são os grandes condicionadores em Mueda.

O mapa produzido constitui uma ferramenta útil para apoio à decisão, orientando a identificação preliminar de áreas para investigação geofísica e planeamento de recursos hídricos. No entanto, o modelo deve ser utilizado como um instrumento de triagem espacial e não substitui levantamentos hidrogeológicos de detalhe em campo.

#{
  show bibliography: set text(8pt)
  bibliography("main.bib", title: text(10pt, "References"), style: "apa")
}
