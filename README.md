# Jubílio Filiano Maússe — GIS, Remote Sensing, MEAL & Data Analysis

Repositório do meu portefólio académico e profissional, com artigos, mapas, tutoriais e projectos sobre **Sistemas de Informação Geográfica (SIG)**, **sensoriamento remoto**, **análise humanitária**, **MEAL**, **KoboToolbox/XLSForm** e **recursos hídricos**.

O site é construído com [MyST Markdown](https://mystmd.org/) e publicado automaticamente através do GitHub Pages.

**Site:** [jubilio.github.io/cv_articles](https://jubilio.github.io/cv_articles)

## Conteúdo em destaque

- [Do alerta à entrevista comunitária: lições aprendidas na construção de um sistema RRM com KoboToolbox e XLSForm](pages/artigos/kobo_xlsform_rrm_licoes_aprendidas.md)
- [Mapeamento de zonas potenciais de águas subterrâneas em Mueda](pages/artigos/groundwater_mueda.md)
- [Da documentação estática a um livro técnico online com Quarto e GitHub Pages](pages/artigos/quarto_qgis_plugin_manual.md)
- [Uso do Google Earth Engine para análise de uso e cobertura da terra no Parque Nacional de Banhine](blog/gee-banhine-lulc.md)
- [Mapas e análises GIS](pages/mapas/index.md)
- [Tutoriais técnicos](pages/tutoriais/index.md)

## Áreas temáticas

- avaliações humanitárias e Rapid Response Mechanism (RRM);
- gestão de informação, KoboToolbox, ODK e XLSForm;
- SIG, cartografia e análise espacial;
- sensoriamento remoto e Google Earth Engine;
- WASH, pontos de água e modelação de águas subterrâneas;
- análise de dados com Python, R, SQL e Power BI;
- documentação técnica e fluxos reproduzíveis.

## Estrutura do repositório

```text
cv_articles/
├── blog/                 # Publicações e estudos aplicados
├── img/                  # Imagens, mapas e recursos visuais
├── pages/
│   ├── artigos/          # Artigos e manuscritos técnicos
│   ├── mapas/            # Mapas e análises geoespaciais
│   ├── projectos/        # Portefólio de projectos
│   └── tutoriais/        # Guias de ArcGIS, QGIS, R e Kobo
├── public/               # Ficheiros públicos e PDFs
├── resources/            # Manuais e materiais técnicos
├── index.md              # Página inicial
├── myst.yml              # Configuração e navegação do site
├── generate_cv.py        # Geração do currículo em Typst
├── build_pdf.py          # Preparação de PDFs publicados
└── generate_rss.py       # Geração dos feeds RSS e Atom
```

## Executar localmente

### Requisitos

- Python 3.12 ou versão compatível;
- Node.js 18 ou superior;
- MyST Markdown.

### Instalação

```bash
git clone https://github.com/Jubilio/cv_articles.git
cd cv_articles

python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

npm install -g mystmd
```

No Windows PowerShell, active o ambiente virtual com:

```powershell
.venv\Scripts\Activate.ps1
```

### Construir o site

```bash
myst build --html
```

Os ficheiros compilados serão criados em `_build/html`.

Para abrir uma pré-visualização local durante a edição:

```bash
myst start
```

## Publicação

O workflow em `.github/workflows/` executa a construção do site e publica o resultado no GitHub Pages quando existem alterações na branch `main`. Pull requests também executam uma verificação do build MyST antes da integração.

## Contribuições e contacto

Sugestões, correcções e propostas de colaboração podem ser submetidas através de issues ou pull requests.

- **Autor:** Jubílio Filiano Maússe
- **GitHub:** [@Jubilio](https://github.com/Jubilio)
- **LinkedIn:** [jubilio-mausse](https://www.linkedin.com/in/jubilio-mausse)
- **Email:** [jubiliomausse5@gmail.com](mailto:jubiliomausse5@gmail.com)

## Licença

O conteúdo académico e técnico deste portefólio é disponibilizado sob a licença [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/), salvo indicação em contrário nos respectivos materiais.

