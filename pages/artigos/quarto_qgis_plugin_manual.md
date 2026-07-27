---
title: "Da documentação estática a um livro técnico online com Quarto e GitHub Pages"
description: "Relato técnico da transformação de um manual de desenvolvimento de plugins QGIS num Quarto Book pesquisável, versionado e publicado automaticamente."
---

# Da documentação estática a um livro técnico online com Quarto e GitHub Pages

**Autor:** Jubílio Filiano Maússe  
**Data:** 27 de Julho de 2026  
**Área:** Documentação técnica, QGIS, Python, Quarto e GitHub Actions

> Este artigo descreve a transformação do manual **Desenvolvimento de Plugins QGIS com Python** num livro técnico online, mantendo simultaneamente versões em PDF, Word e pacote-fonte. O projecto utiliza exemplos reais dos plugins **GPX Batch Converter** e **GeoClick Capture**.

## Resumo

Documentação técnica de software tende a tornar-se rapidamente difícil de manter quando o mesmo conteúdo é copiado para páginas web, ficheiros Word, PDF e diferentes repositórios. Este artigo apresenta uma abordagem reproduzível para converter um manual extenso sobre desenvolvimento de plugins QGIS num **Quarto Book** com capítulos navegáveis, pesquisa integral, tema claro e escuro, referências internas e publicação automática no GitHub Pages. A solução preserva uma única fonte principal em Markdown, gera os capítulos do livro por meio de um script Python e utiliza GitHub Actions para validar, renderizar e publicar o resultado. O processo também revelou problemas práticos importantes, incluindo divergências no nome do autor, caminhos locais fixos, artefactos binários desactualizados, limitações do `GITHUB_TOKEN` e a necessidade de activar explicitamente o GitHub Pages. O resultado final é uma plataforma de aprendizagem pública, versionada e sustentável.

**Palavras-chave:** Quarto; QGIS; PyQGIS; documentação técnica; GitHub Pages; GitHub Actions; publicação reproduzível; plugins QGIS.

---

## 1. Contexto do projecto

O ponto de partida foi a criação de um manual do básico ao avançado sobre desenvolvimento de plugins QGIS com Python. O documento precisava de ensinar não apenas a estrutura mínima de um plugin, mas também aspectos mais avançados, incluindo:

- `classFactory()`, `initGui()`, `run()` e `unload()`;
- menus, barras de ferramentas, `QDialog` e `QDockWidget`;
- camadas vectoriais, geometrias e transformação de sistemas de referência;
- tarefas em segundo plano com `QgsTask`;
- processamento em lote e integração segura com GDAL;
- ferramentas de mapa e snapping;
- pedidos de rede com `QgsNetworkAccessManager`;
- compatibilidade QGIS 3/4 e Qt 5/6;
- testes, empacotamento, CI/CD e publicação.

Para tornar o conteúdo concreto, foram utilizados dois estudos de caso reais:

1. **GPX Batch Converter**, orientado à conversão em lote, execução em segundo plano, cancelamento, formatos GIS e relatórios;
2. **GeoClick Capture**, orientado à captura de pontos, snapping, transformação de coordenadas, sessões, geocodificação e painéis laterais.

A primeira versão do manual foi produzida em Markdown, convertida para DOCX e PDF e publicada como asset de uma GitHub Release. Esta solução funcionava, mas ainda apresentava uma limitação importante: o conteúdo não era facilmente navegável na Web.

## 2. Por que adoptar Quarto?

Um manual técnico extenso beneficia de uma estrutura de livro, e não apenas de uma página longa. O [Quarto](https://quarto.org/docs/books/) permite combinar vários capítulos num único projecto e produzir HTML, PDF, Word, EPUB e outros formatos a partir de fontes textuais. A versão HTML de um Quarto Book inclui funcionalidades particularmente úteis para documentação técnica:

- índice lateral persistente;
- pesquisa em todo o livro;
- navegação anterior/seguinte;
- links directos para secções;
- numeração de capítulos;
- referências cruzadas;
- realce e cópia de código;
- tema claro e escuro;
- desenho responsivo para computador e telemóvel.

A decisão mais importante não foi apenas adoptar Quarto, mas fazê-lo **sem criar uma segunda fonte de verdade**. O conteúdo principal permaneceu em:

```text
manual/manual.md
```

Os ficheiros `.qmd` usados pelo Quarto passaram a ser gerados automaticamente.

## 3. Arquitectura adoptada

A arquitectura final separa conteúdo, transformação, apresentação e publicação:

```text
qgis-plugin-development-manual/
├── manual/
│   └── manual.md                 # Fonte canónica
├── scripts/
│   └── prepare_quarto.py         # Gera os capítulos
├── chapters/                     # Ficheiros .qmd gerados
├── index.qmd                     # Página inicial do livro
├── _quarto.yml                   # Estrutura e opções do livro
├── styles.css                    # Personalização visual
├── examples/                     # Plugins pedagógicos
├── snippets/                     # Padrões reutilizáveis
├── checklists/                   # Listas de controlo
└── .github/workflows/
    ├── plugin-checks.yml
    ├── build-release.yml
    └── publish-quarto.yml
```

Esta separação permite que cada componente tenha uma responsabilidade clara:

- `manual/manual.md` contém o texto principal;
- `prepare_quarto.py` divide o documento em partes;
- `_quarto.yml` define a estrutura do livro;
- GitHub Actions valida e publica.

## 4. Configuração do Quarto Book

O ficheiro `_quarto.yml` define o projecto como livro e organiza as partes e capítulos:

```yaml
project:
  type: book
  output-dir: _book
  pre-render:
    - python scripts/prepare_quarto.py

lang: pt-PT

book:
  title: "Desenvolvimento de Plugins QGIS com Python"
  subtitle: "Do básico ao avançado, com GPX Batch Converter e GeoClick Capture"
  author:
    - name: "Jubílio Filiano Maússe"
  site-url: "https://jubilio.github.io/qgis-plugin-development-manual/"
  repo-url: "https://github.com/Jubilio/qgis-plugin-development-manual"
  search: true
  chapters:
    - index.qmd
    - chapters/00-prefacio.qmd
    - part: "Parte I — Fundamentos"
      chapters:
        - chapters/01-fundamentos.qmd
    - part: "Parte II — O primeiro plugin"
      chapters:
        - chapters/02-primeiro-plugin.qmd
```

A configuração inclui ainda tema claro e escuro, índice de conteúdo, cópia de código e abertura de links externos numa nova janela.

## 5. Geração automática dos capítulos

O manual original já estava dividido internamente em seis partes. O script `prepare_quarto.py` utiliza esses títulos para gerar os capítulos Quarto.

A lógica central é:

1. ler `manual/manual.md`;
2. remover o front matter e marcadores exclusivos de impressão;
3. identificar títulos como `# Parte I - Fundamentos`;
4. separar prefácio, seis partes e apêndices;
5. ajustar os níveis dos títulos;
6. gravar os ficheiros `.qmd` dentro de `chapters/`.

Exemplo simplificado:

```python
PART_FILES = {
    "I": "01-fundamentos.qmd",
    "II": "02-primeiro-plugin.qmd",
    "III": "03-desenvolvimento-intermedio.qmd",
    "IV": "04-desenvolvimento-avancado.qmd",
    "V": "05-estudos-de-caso.qmd",
    "VI": "06-projecto-pratico.qmd",
}

part_match = re.match(r"^# Parte ([IVX]+)\s*-\s*(.+)$", line)
```

Esta abordagem evita editar manualmente vários capítulos sempre que o conteúdo muda. O repositório mantém apenas uma fonte editorial, enquanto o Quarto recebe uma estrutura optimizada para leitura online.

## 6. Validação antes da publicação

O pipeline não se limita a executar `quarto render`. Foram adicionadas verificações automáticas para detectar problemas antes da publicação:

```bash
test -s _book/index.html
test -s _book/search.json
grep -q 'Jubílio Filiano Maússe' _book/index.html
```

Também é verificado que a grafia incorrecta do apelido não aparece no livro:

```bash
if grep -R 'Jubílio Filiano Mausse' _book --include='*.html'; then
  echo "The rendered book contains the unaccented family name"
  exit 1
fi
```

Outras validações do repositório incluem:

- compilação dos exemplos Python;
- existência dos ficheiros obrigatórios;
- formato semântico da versão;
- ausência de `__pycache__` e `.pyc` versionados;
- construção de PDF e DOCX;
- extracção do texto do PDF para confirmar os acentos;
- hashes SHA-256 dos assets da release.

## 7. Publicação com GitHub Actions

A publicação do livro utiliza o fluxo oficial do GitHub Pages. A documentação do GitHub recomenda três acções principais para workflows personalizados:

1. `actions/configure-pages`;
2. `actions/upload-pages-artifact`;
3. `actions/deploy-pages`.

O workflow precisa ainda das permissões:

```yaml
permissions:
  contents: read
  pages: write
  id-token: write
```

A fase de construção gera o livro e envia `_book/` como artefacto:

```yaml
- name: Configure GitHub Pages
  uses: actions/configure-pages@v5

- name: Upload GitHub Pages artifact
  uses: actions/upload-pages-artifact@v4
  with:
    path: _book/
```

A fase de deployment utiliza o ambiente `github-pages`:

```yaml
deploy:
  needs: build
  permissions:
    pages: write
    id-token: write
  environment:
    name: github-pages
    url: ${{ steps.deployment.outputs.page_url }}
  steps:
    - name: Deploy to GitHub Pages
      id: deployment
      uses: actions/deploy-pages@v4
```

Este padrão é mais transparente que simplesmente enviar ficheiros para uma branch: o workflow apresenta o estado do deployment e devolve o URL publicado.

## 8. O problema do erro 404

Durante a primeira publicação, a branch `gh-pages` foi criada e continha um `index.html` válido. Mesmo assim, o endereço público devolvia:

```text
404
There isn't a GitHub Pages site here.
```

A investigação mostrou que **ter uma branch com HTML não significa necessariamente que o serviço GitHub Pages esteja activado**. Além disso, commits efectuados pelo `GITHUB_TOKEN` podem não desencadear outro workflow ou deployment baseado em branch.

A resolução teve duas partes:

1. substituir o envio directo à branch `gh-pages` pelo workflow oficial de Pages;
2. activar uma única vez, nas definições do repositório:

```text
Settings → Pages → Build and deployment → Source → GitHub Actions
```

Após esta configuração, o workflow passou a publicar correctamente o livro.

## 9. Outros problemas corrigidos durante o processo

### 9.1 Nome do autor sem acento

Alguns ficheiros utilizavam `Mausse` em vez de `Maússe`. A divergência aparecia em fontes Markdown, metadados e documentos gerados. Foi criado um script de normalização e adicionadas verificações no CI.

### 9.2 Caminho local fixo

O primeiro gerador de DOCX gravava o resultado num caminho semelhante a:

```python
Path("/mnt/data/qgis-plugin-development-manual")
```

Este caminho funcionava apenas no ambiente onde o documento foi originalmente produzido. A solução foi calcular todos os caminhos relativamente ao próprio repositório:

```python
ROOT = Path(__file__).resolve().parent
```

### 9.3 Documentos binários desactualizados

Manter PDF e DOCX dentro da árvore principal criava risco de divergência entre fonte e documento publicado. A solução foi:

- ignorar os ficheiros gerados no Git;
- produzi-los no workflow;
- publicá-los como assets de uma release versionada.

### 9.4 Validação incorrecta de caches Python

`compileall` cria `__pycache__` durante o workflow. Uma verificação que procura qualquer cache no directório de trabalho pode, portanto, falhar mesmo quando o repositório está limpo. A validação foi alterada para examinar apenas ficheiros rastreados pelo Git.

## 10. Resultado final

O projecto passou a disponibilizar três formas complementares de acesso:

### Livro online

[https://jubilio.github.io/qgis-plugin-development-manual/](https://jubilio.github.io/qgis-plugin-development-manual/)

### Código-fonte e exemplos

[https://github.com/Jubilio/qgis-plugin-development-manual](https://github.com/Jubilio/qgis-plugin-development-manual)

### Releases

As releases incluem:

- PDF;
- versão editável em Word;
- pacote-fonte;
- hashes SHA-256.

O manual online oferece pesquisa e navegação; o PDF é adequado a leitura offline e impressão; o Word permite revisão e adaptação; o repositório permite estudar e executar os exemplos.

## 11. Lições principais

A experiência permite sintetizar várias recomendações para outros projectos de documentação técnica:

1. **Mantenha uma única fonte canónica.** A duplicação de conteúdo conduz rapidamente a versões inconsistentes.
2. **Gere formatos derivados automaticamente.** PDF, Word, HTML e capítulos devem resultar do mesmo processo.
3. **Valide o documento publicado, não apenas a fonte.** Extrair texto do PDF e verificar o HTML detecta problemas que não aparecem no Markdown.
4. **Use o workflow oficial do GitHub Pages.** O deployment baseado em artefactos fornece melhor diagnóstico e rastreabilidade.
5. **Trate documentação como software.** Utilize branches, Pull Requests, testes, versões, changelog e releases.
6. **Teste nomes, links e caminhos.** Pequenas inconsistências tornam-se visíveis em todos os formatos.
7. **Separe fonte e artefactos.** O repositório deve conter o necessário para reconstruir; as releases devem conter o resultado final.
8. **Documente os erros encontrados.** O diagnóstico do 404 tornou-se parte útil do próprio artigo e do workflow.

## 12. Conclusão

A migração para Quarto transformou um manual estático num produto de aprendizagem sustentável. O livro pode crescer com novos capítulos, exemplos e versões dos plugins sem exigir actualizações manuais em vários formatos. Cada alteração integrada na branch principal é validada, renderizada e publicada automaticamente.

Mais do que uma escolha de ferramenta, o projecto demonstra uma mudança de abordagem: documentação técnica deve ser tratada como um sistema versionado, testável e reproduzível. Esta prática melhora a qualidade editorial, reduz erros e facilita a partilha de conhecimento com a comunidade QGIS.

## Referências e recursos

- [Quarto — Creating a Book](https://quarto.org/docs/books/)
- [Quarto — Book Structure](https://quarto.org/docs/books/book-structure.html)
- [GitHub Docs — Using custom workflows with GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages)
- [Repositório do manual](https://github.com/Jubilio/qgis-plugin-development-manual)
- [Livro online](https://jubilio.github.io/qgis-plugin-development-manual/)
- [GPX Batch Converter](https://github.com/Jubilio/gpx-batch-converter)
- [GeoClick Capture](https://github.com/Jubilio/qgis-latlon)
