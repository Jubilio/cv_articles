---
title: "Do XLSForm ao resultado: construção de um fluxo reproduzível para dados HESPER e Washington Group em R"
description: "Estudo de caso técnico sobre adaptação de um instrumento Community Member/HESPER, limpeza de dados, indicadores Washington Group, DAP, análise descritiva e apresentação de resultados no padrão IMPACT."
---

# Do XLSForm ao resultado: construção de um fluxo reproduzível para dados HESPER e Washington Group em R

**Autor:** Jubílio Filiano Maússe  
**Actualizado:** 13 de Agosto de 2026

**Área:** Análise Humanitária, R, KoboToolbox, XLSForm, HESPER e Washington Group

> Este artigo apresenta a construção de um fluxo completo para transformar entrevistas comunitárias recolhidas com KoboToolbox num conjunto de dados limpo, documentado e pronto para análise. O caso combina perguntas HESPER, o Washington Group Short Set, ligação a alertas RRM, controlo de qualidade em R, um Data Analysis Plan actualizado e apresentação de resultados com os pacotes `analysistools` e `presentresults` da IMPACT Initiatives.

## Resumo

Instrumentos de avaliação rápida são frequentemente adaptados à medida que o desenho metodológico evolui. O problema é que alterações no XLSForm não terminam no formulário: nomes de variáveis, tipos de perguntas, opções de resposta, indicadores compostos, regras de limpeza, planos de análise e formatos de apresentação precisam de permanecer alinhados. Uma pequena inconsistência pode interromper o processamento ou, mais grave, produzir um indicador com significado diferente daquele que foi recolhido.

Este artigo sistematiza o desenvolvimento de um fluxo reproduzível para um instrumento **Community Member/HESPER** associado a alertas de resposta rápida. O processo incluiu inspecção do XLSForm e da exportação Kobo, adaptação dos scripts de verificação e edição, validação das prioridades HESPER, cálculo de um indicador de deficiência ao nível do respondente com o Washington Group Short Set, criação de variáveis derivadas, actualização automática do DAP e geração de outputs no estilo IMPACT. O trabalho revelou quatro princípios centrais: o XLSForm deve ser a fonte de verdade; indicadores precisam de respeitar a unidade de análise; resultados descritivos não devem ser apresentados como estimativas populacionais; e funções de apresentação exigem que a estrutura dos dados seja exactamente compatível com os seus argumentos.

**Palavras-chave:** HESPER; Washington Group Short Set; KoboToolbox; XLSForm; R; análise humanitária; limpeza de dados; DAP; IMPACT Initiatives; reprodutibilidade.

---

## 1. O problema: uma alteração no formulário modifica toda a cadeia analítica

O instrumento analisado recolhe informação de membros da comunidade ligados a um alerta RRM. Além de perfil, deslocamento e intenções, contém:

- campos recuperados de um ficheiro externo de alertas;
- seis perguntas do Washington Group Short Set;
- problemas HESPER ao nível individual e comunitário;
- classificação da primeira, segunda e terceira prioridades;
- áreas prioritárias para apoio de organizações humanitárias.

O fluxo anterior tinha sido concebido para um inquérito domiciliar mais extenso. Incluía variáveis como composição do agregado, rCSI, condições médicas do agregado, educação, água, saneamento, assistência e outros módulos que já não existiam no novo instrumento. Reutilizar o DAP e os scripts sem revisão teria duas consequências imediatas:

1. erros por variáveis ausentes;
2. resultados conceptualmente incorrectos, mesmo quando o código executasse.

Foi necessário tratar a mudança como uma actualização de sistema, não como a simples substituição de um ficheiro Excel.

## 2. Arquitectura adoptada

O fluxo final foi organizado em quatro etapas:

```text
XLSForm + exportação Kobo
          ↓
01 — Verificação e follow-ups
          ↓
02 — Aplicação das correcções e dataset limpo
          ↓
03 — Indicadores, labels e dataset de análise
          ↓
04 — DAP, análise e apresentação IMPACT
```

O princípio orientador foi simples: cada etapa deve produzir um objecto verificável e deixar explícito o que mudou.

| Etapa | Produto principal | Função |
|---|---|---|
| Verificação | Follow-up log | Identificar inconsistências sem alterar silenciosamente os dados |
| Edição | Dataset limpo e cleaning log | Aplicar decisões documentadas |
| Preparação | Dataset XML e dataset com labels | Criar indicadores e variáveis de desagregação |
| Análise | Resultados longos e tabelas IMPACT | Calcular e apresentar resultados |

## 3. O XLSForm como fonte de verdade

A primeira decisão foi inspeccionar directamente as folhas `survey`, `choices` e `settings`, comparando-as com os 127 campos da exportação. Isto permitiu identificar os nomes reais usados pelo instrumento:

```r
wgss_columns <- c(
  "wgss_seeing",
  "wgss_hearing",
  "wgss_walking",
  "wgss_remembering",
  "wgss_selfcare",
  "wgss_communicating"
)
```

Também confirmou que as variáveis administrativas eram:

```text
arrival_province
arrival_district
arrival_admin_post
arrival_site
```

e não `admin1`, `admin2`, `admin3` e `community`, como no fluxo anterior.

Esta comparação evitou adaptar o código com base em memória, labels ou nomes usados noutros instrumentos. Em fluxos Kobo/XLSForm, o campo `name` é o contrato técnico entre recolha, limpeza e análise.

## 4. Ligação entre alertas e entrevistas

O formulário usa `select_one_from_file alerts.csv` para seleccionar um alerta e recuperar campos com `pulldata()`. Na exportação, os campos calculados incluem:

```text
alert_community_site
alert_origin_location
alert_shock_event_en
alert_shock_event_pt
alert_shock_date_en
alert_shock_date_pt
```

Estes campos são do tipo `calculate`, mas não são metadados descartáveis. São variáveis analíticas que permitem:

- confirmar a ligação entre a entrevista e o alerta;
- comparar local declarado e local recuperado;
- resumir entrevistas por evento;
- preservar rastreabilidade entre formulários.

Por isso, o script de edição foi alterado para não remover automaticamente todas as variáveis `calculate`. Apenas notas, geopoints não necessários e metadados sensíveis são removidos. Os cálculos do alerta permanecem no dataset final.

## 5. Controlo de qualidade HESPER

O instrumento contém 23 problemas ao nível individual ou do agregado e cinco problemas comunitários. Cada domínio usa respostas como:

```text
no_serious_problem
serious_problem
dk
not_applicable
pnta
```

O script valida se cada resposta pertence ao conjunto permitido e calcula:

```r
hesper_household_serious_count
hesper_community_serious_count
hesper_serious_problem_count
hesper_any_serious_problem
```

### Respostas abertas não devem ser contadas mecanicamente

`hesper_other` e `hesper_other_l` são campos de texto. Uma resposta preenchida não representa necessariamente um problema adicional. Na exportação existiam expressões como “N/A” ou “não tem comentário”. Contá-las como problema grave inflacionaria o total e afectaria a expectativa sobre o número de prioridades.

Foi criada uma função para distinguir conteúdo substantivo de placeholders:

```r
is_substantive_other <- function(x) {
  normalised <- normalise_free_text(x)
  !is.na(x) &
    normalised != "" &
    !normalised %in% normalise_free_text(non_substantive_other)
}
```

### Validação do ranking de prioridades

As três prioridades HESPER foram verificadas com três regras:

1. o número de prioridades respondidas deve corresponder ao número esperado, até ao máximo de três;
2. a mesma prioridade não pode ser escolhida duas vezes;
3. uma prioridade seleccionada deve ter sido classificada como `serious_problem` no respectivo domínio.

O número esperado é calculado por:

```r
hesper_priority_expected_count <- pmin(
  hesper_serious_problem_count,
  3L
)
```

Isto cria uma ligação auditável entre as respostas HESPER e o ranking final.

## 6. Washington Group: unidade de análise antes do código

Um bloco anterior chamava o resultado de `hh_disability_flag`, interpretando-o como indicador do agregado. Contudo, no novo instrumento as perguntas são dirigidas ao próprio respondente. O indicador correcto é, portanto, de nível individual:

```text
wgss_disability_flag
```

O limiar recomendado identifica deficiência quando existe pelo menos um domínio com:

```text
a_lot_of_difficulty
cannot_do_at_all
```

O cálculo implementado foi:

```r
wgss_severe_domain_count = rowSums(
  across(
    all_of(wgss_columns),
    ~ .x %in% c(
      "a_lot_of_difficulty",
      "cannot_do_at_all"
    )
  ),
  na.rm = TRUE
)

wgss_valid_domain_count = rowSums(
  across(
    all_of(wgss_columns),
    ~ !is.na(.x) & !.x %in% c("dk", "pnta")
  )
)

wgss_disability_flag = case_when(
  wgss_severe_domain_count >= 1 ~ 1L,
  wgss_valid_domain_count == 0 ~ NA_integer_,
  TRUE ~ 0L
)
```

Se um indicador já tiver sido calculado durante a limpeza, o script preserva-o temporariamente, compara os valores e emite um aviso em caso de divergência. O dataset de análise utiliza depois a versão recalculada.

Esta etapa demonstra uma regra importante: o nome do indicador deve comunicar claramente **quem foi medido**. Um cálculo tecnicamente correcto pode ser metodologicamente errado quando a unidade de análise é mal definida.

## 7. Localização administrativa sem `rowwise()` frágil

O fluxo anterior adicionava labels administrativos com uma expressão dentro de `rowwise()`. Quando um código não tinha correspondência, o vector devolvido tinha tamanho zero e `mutate()` falhava.

A solução foi construir um dicionário e usar `match()`:

```r
labels <- mapping$label[
  match(as.character(data[[code_column]]), mapping$code)
]

data[[label_column_name]] <- coalesce(
  labels,
  as.character(data[[code_column]])
)
```

Assim, uma correspondência ausente preserva o código original e não interrompe todo o processamento. As variáveis finais são:

```text
arrival_province_label
arrival_district_label
arrival_admin_post_label
```

## 8. Dataset XML e dataset com labels

O script produz dois ficheiros:

- um dataset com nomes XML, adequado para análise reproduzível;
- um dataset com labels em inglês, útil para revisão humana e partilha controlada.

A função de rotulagem foi reescrita para evitar uma definição recursiva acidental. Para perguntas `select_one`, os valores são recodificados com a lista correcta da folha `choices`. Quando um label não existe, o código original é preservado.

Labels repetidos são possíveis, especialmente em módulos padronizados. Como Excel exige nomes únicos, o script usa `make.unique()` para impedir a perda silenciosa de colunas.

## 9. Um novo DAP construído a partir do instrumento actual

O Data Analysis Plan anterior continha mais de cem variáveis que não pertenciam ao novo formulário. Em vez de corrigir linha por linha, o DAP foi reconstruído a partir dos tipos do XLSForm.

As regras adoptadas foram:

| Tipo XLSForm | Tipo de análise |
|---|---|
| `select_one` | `prop_select_one` |
| `select_multiple` | `prop_select_multiple` |
| `integer` ou `decimal` | `mean` |
| `calculate`, `date` ou texto analítico | `frequency` |
| identificador, texto sensível ou tradução duplicada | `skip` |

Foram adicionados ao DAP os indicadores derivados criados no script de preparação. A principal desagregação é `arrival_district_label`, enquanto campos do alerta e localização usam `overall`.

O DAP contém ainda uma folha `README` que documenta pesos, unidade de análise, interpretação do WGSS, variáveis derivadas e limitações.

## 10. Porque a análise é descritiva

O dataset recebe `weight = 1`, mas isso não transforma as entrevistas numa amostra probabilística. O peso unitário serve para manter contagens e proporções observadas compatíveis com as funções de análise.

O desenho foi definido como:

```r
my_design <- srvyr::as_survey_design(
  data_main,
  weights = weight
)
```

Não foi usada `arrival_district_label` como estrato. Estratificação estatística só é justificável quando faz parte de um desenho amostral válido. Neste caso, os resultados devem ser apresentados como:

- proporção dos respondentes entrevistados;
- número de entrevistas;
- distribuição observada por local;
- evidência indicativa para triangulação.

Não devem ser descritos como prevalência na população do distrito ou da comunidade.

## 11. Tratamento de `frequency`

O pacote `analysistools` implementa médias, medianas, proporções e rácios, mas não o tipo `frequency`. Enviar este tipo directamente à função `create_analysis()` produz erro.

A solução foi separar o DAP:

```r
frequency_loa <- my_loa_all %>%
  filter(analysis_type == "frequency")

my_loa <- my_loa_all %>%
  filter(analysis_type != "frequency")
```

As frequências são calculadas com `count()` e reunidas num output próprio. Isto permite que campos como comunidade, origem, evento e data do alerta apareçam no resultado final sem fingir que são perguntas categóricas convencionais do XLSForm.

## 12. Labels Kobo e o erro de `list_name` duplicado

As funções de `presentresults` interpretam a coluna `type` do XLSForm e criam internamente `q_type` e `list_name`. Se o objecto enviado já contém essas colunas derivadas, `separate_wider_delim()` tenta criar nomes repetidos.

Antes de construir o dicionário de labels, o script remove essas colunas:

```r
survey_for_labels <- tool_survey %>%
  select(
    -any_of(c("q_type", "list_name", "list_name_old"))
  )
```

O objecto original continua disponível para conversão de tipos; uma cópia mínima é usada apenas na etapa de labels.

## 13. Apresentação IMPACT sem intervalos de confiança

Como a análise é descritiva e não representa uma amostra probabilística, decidiu-se retirar `stat_low` e `stat_upp` dos outputs. Foram mantidos:

```text
stat
n
n_total
n_w
n_w_total
```

O estilo institucional continua a ser aplicado pelas funções:

```r
presentresults::create_table_variable_x_group()
presentresults::create_xlsx_variable_x_group()
```

### Uma incompatibilidade pouco evidente

Ao criar a tabela larga, todas as cinco colunas precisam de ser incluídas:

```r
requested_values <- c(
  "stat", "n", "n_total", "n_w", "n_w_total"
)
```

Mas a função que escreve o Excel distingue valores estatísticos de totais. A chamada correcta é:

```r
create_xlsx_variable_x_group(
  wide_table,
  value_columns = "stat",
  total_columns = c("n", "n_total", "n_w", "n_w_total"),
  file_path = file_path,
  overwrite = TRUE
)
```

Quando os totais eram passados simultaneamente em `value_columns` e `total_columns`, a função apresentava:

```text
Length of value_columns does not match with the table.
```

O erro não estava nos resultados. Estava na forma como a função calculava o tamanho esperado de cada conjunto de colunas.

## 14. Respostas “Other” e dicionários legados

Outro erro surgiu na exportação das respostas abertas:

```text
missing value where TRUE/FALSE needed
```

A função `save_other_responses()` percorria um `other_db` que ainda continha variáveis de formulários anteriores. Para essas variáveis, `q_type` estava vazio ou não existia no XLSForm actual.

A correcção foi restringir o dicionário às perguntas realmente presentes no dataframe de respostas abertas:

```r
other_db <- other_db %>%
  filter(
    !is.na(name),
    str_trim(name) != "",
    name %in% unique(df$question_name)
  )
```

Depois, tipos ausentes são recuperados do `kobo_survey`. O princípio é aplicável a muitos sistemas: recursos acumulados entre rondas precisam de ser filtrados pelo instrumento activo antes de serem usados.

## 15. Outputs produzidos

O fluxo gera outputs com papéis diferentes:

| Output | Utilização |
|---|---|
| Dataset XML | Análise e reprodução |
| Dataset labelled | Revisão humana |
| Resultado longo XML | Auditoria técnica |
| Resultado longo labelled | Auditoria e validação de labels |
| Tabela IMPACT XML | Integração técnica |
| Tabela IMPACT labelled | Apresentação e revisão |
| Frequências | Campos calculados, datas e texto categorizado |
| Data merge | Produtos de comunicação e automatização |

Os outputs longos não substituem a apresentação IMPACT; funcionam como evidência auditável quando é necessário rastrear uma linha até ao resultado original.

## 16. Lições principais

### 1. A cadeia inteira deve ser versionada

Uma versão do XLSForm precisa de corresponder a uma versão dos scripts de limpeza, do DAP e do gerador de análise.

### 2. Nomes de indicadores devem reflectir a unidade de análise

`wgss_disability_flag` é um indicador do respondente. Chamá-lo de indicador do agregado alteraria o seu significado.

### 3. Campos `calculate` podem ser dados analíticos

Remover todas as variáveis calculadas é inadequado quando elas preservam a ligação a outro formulário.

### 4. Texto preenchido não é automaticamente evidência substantiva

Placeholders em “Other” precisam de normalização e regras explícitas.

### 5. Pesos unitários não criam representatividade

Os resultados continuam descritivos e devem ser triangulados com outras fontes.

### 6. Outputs institucionais dependem de contratos de estrutura

Quando uma função espera blocos de colunas, `value_columns` e `total_columns` precisam de corresponder exactamente à tabela.

### 7. Falhar cedo é melhor do que produzir silenciosamente

O script interrompe a execução quando faltam variáveis, labels essenciais, indicadores ou colunas necessárias à apresentação.

## 17. Recomendações para futuras rondas

1. guardar no repositório o XLSForm exacto usado em cada ronda;
2. incluir testes automáticos que comparem nomes do DAP com o dataset preparado;
3. validar códigos e labels em todas as línguas antes da recolha;
4. documentar a unidade de análise de cada indicador derivado;
5. manter campos de alerta protegidos de rotinas genéricas de remoção;
6. rever respostas abertas antes de as incorporar em contagens;
7. apresentar `n` junto das percentagens, sobretudo quando o número de entrevistas é baixo;
8. usar resultados HESPER como evidência indicativa e de triangulação, não como estimativa populacional sem desenho amostral adequado;
9. manter outputs longos para auditoria e tabelas IMPACT para comunicação;
10. testar o fluxo completo com uma pequena exportação antes de processar a ronda final.

## 18. Conclusão

Adaptar um instrumento humanitário não é apenas trocar perguntas. Cada mudança altera uma cadeia de dependências entre recolha, controlo de qualidade, indicadores, desagregações, análise e apresentação. Neste caso, a reconstrução do fluxo permitiu alinhar um novo instrumento Community Member/HESPER com scripts em R, indicadores Washington Group, um DAP actualizado e outputs no padrão IMPACT.

Os erros encontrados foram úteis porque revelaram contratos implícitos: `q_type` dependia do formulário activo; `frequency` não pertencia ao conjunto de análises implementadas; `calculate` nem sempre era descartável; `value_columns` e `total_columns` tinham funções distintas; e um indicador de deficiência precisava de respeitar quem respondeu às perguntas.

A principal conclusão é que **um fluxo reproduzível não é aquele que apenas executa sem erros, mas aquele que torna explícita a relação entre pergunta, regra de limpeza, indicador, denominador, unidade de análise e output final**. Essa transparência é essencial para produzir evidência rápida sem sacrificar rastreabilidade ou rigor metodológico.

## Recursos técnicos

- [analysistools — IMPACT Initiatives](https://github.com/impact-initiatives/analysistools)
- [presentresults — IMPACT Initiatives](https://github.com/impact-initiatives/presentresults)
- [Washington Group Short Set](https://www.washingtongroup-disability.com/question-sets/wg-short-set-on-functioning-wg-ss/)
- [KoboToolbox documentation](https://support.kobotoolbox.org/)
- [XLSForm documentation](https://xlsform.org/)

