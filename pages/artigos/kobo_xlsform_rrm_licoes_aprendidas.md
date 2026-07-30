---
title: "Do alerta à entrevista comunitária: lições aprendidas na construção de um sistema RRM com KoboToolbox e XLSForm"
description: "Estudo de caso técnico sobre identificadores únicos, pontuação multidimensional, ligação entre formulários, ficheiros CSV externos, perguntas dinâmicas e validação incremental."
---

# Do alerta à entrevista comunitária: lições aprendidas na construção de um sistema RRM com KoboToolbox e XLSForm

**Autor:** Jubílio Filiano Maússe  
**Data:** 30 de Julho de 2026  
**Área:** Gestão de Informação Humanitária, KoboToolbox, XLSForm e Resposta Rápida

> Este artigo sistematiza as lições aprendidas durante o desenho de um fluxo digital para registar alertas humanitários, classificar a sua gravidade e ligar cada alerta a entrevistas posteriores com membros da comunidade. O foco está menos no formulário final e mais nas decisões de arquitectura, nos erros encontrados e nas soluções que tornaram o sistema mais estável, rastreável e utilizável.

## Resumo

Sistemas de alerta para mecanismos de resposta rápida precisam de transformar informação inicial, frequentemente incompleta, numa base suficientemente estruturada para apoiar verificação, priorização e recolha complementar. Este artigo apresenta um estudo de caso aplicado sobre a construção de um sistema integrado com **KoboToolbox** e **XLSForm**, composto por um formulário de alerta e um formulário de entrevistas comunitárias ligados por um identificador comum. A solução incluiu geração automática de códigos únicos, pontuação de sete dimensões de gravidade, separação entre classificação descritiva e via operacional, selecção de alertas a partir de um ficheiro CSV, recuperação automática de dados com `pulldata()` e geração de perguntas dinâmicas. O processo revelou desafios recorrentes: uso incorrecto de funções XLSForm, cálculos vazios, referências circulares, inconsistências entre nomes de colunas, duplicação de identificadores e diferenças entre códigos internos e labels apresentados. As lições demonstram que a robustez de um sistema deste tipo depende sobretudo de uma arquitectura lógica unidireccional, identificadores estáveis, regras de pontuação transparentes, validação incremental e uma estratégia clara para actualizar dados externos.

**Palavras-chave:** KoboToolbox; XLSForm; RRM; alertas humanitários; gestão de informação; pontuação de gravidade; `pulldata()`; dados externos.

---

## 1. Contexto e problema operacional

Um alerta humanitário é normalmente recebido antes de existir informação completa sobre o evento, o número de pessoas afectadas, as necessidades prioritárias, a cobertura da resposta ou as condições de acesso. Ainda assim, a equipa precisa de decidir rapidamente se deve:

- apenas monitorar a situação;
- solicitar verificação adicional;
- abrir formalmente um alerta;
- realizar uma avaliação rápida;
- escalar o caso para coordenação e apoio externo.

O desafio não era apenas digitalizar perguntas. Era criar um fluxo que ligasse três momentos distintos:

1. **Registo inicial do alerta**;
2. **Classificação e revisão interna**;
3. **Recolha de evidência junto da população associada ao alerta**.

A arquitectura adoptada separou estes momentos em dois formulários:

```text
Formulário de Alerta RRM
        │
        │ alert_id
        ▼
Formulário Community Member
```

A relação é do tipo **um-para-muitos**: um alerta pode estar associado a várias entrevistas comunitárias. Esta separação evita um formulário excessivamente longo, permite que diferentes equipas recolham dados em momentos distintos e mantém uma chave comum para análise posterior.

## 2. Arquitectura funcional adoptada

O formulário de alerta foi organizado em módulos:

1. identificação e ligação do alerta;
2. localização de chegada ou intervenção;
3. choque e local de origem;
4. movimento e dimensão do caseload;
5. necessidades prioritárias;
6. pressão sobre a comunidade de acolhimento;
7. cobertura de avaliação e resposta;
8. acesso e viabilidade;
9. confiança nas fontes e lacunas de informação;
10. resultados calculados.

O formulário comunitário utiliza o `alert_id` para recuperar o contexto do alerta seleccionado, incluindo:

- comunidade ou local de chegada;
- local de origem ou do choque;
- tipo de choque;
- data aproximada do evento.

Esses valores são inseridos numa pergunta de confirmação, reduzindo a probabilidade de entrevistar pessoas que não pertencem ao movimento populacional em análise.

## 3. Lição 1 — O identificador deve ser único, estável e legível

O identificador do alerta é a peça central da integração. Ele precisa de ser:

- único em toda a base;
- estável depois de criado;
- legível para equipas operacionais;
- livre de dados pessoais;
- utilizável em KoboToolbox, Excel, R, Python e Power BI.

Uma primeira tentativa produziu identificadores repetidos durante o recálculo:

```text
RRM_SCI_MUEDA_20260728_RRM_SCI_MUEDA_20260728_...
```

Isto acontece quando o cálculo volta a concatenar o valor existente do próprio campo ou quando a expressão não é protegida contra recálculo. A solução foi envolver a criação do identificador em `once()` e nunca referenciar `${alert_id}` dentro do seu próprio cálculo.

```text
if(
  ${alert_source_org} != '' and ${arrival_districts} != '',
  once(
    concat(
      'RRM_',
      translate(
        ${alert_source_org},
        'abcdefghijklmnopqrstuvwxyz',
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      ),
      '_',
      translate(
        jr:choice-name(
          ${arrival_districts},
          '${arrival_districts}'
        ),
        ' ',
        '_'
      ),
      '_',
      format-date(${today}, '%Y%m%d'),
      '_',
      translate(
        uuid(6),
        'abcdefghijklmnopqrstuvwxyz',
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      )
    )
  ),
  ''
)
```

Um resultado possível é:

```text
RRM_SCI_MUEDA_20260729_RBA3LB
```

A estrutura combina o mecanismo, a organização, o distrito, a data e um sufixo aleatório. O sufixo continua necessário porque duas organizações podem criar mais de um alerta no mesmo distrito e no mesmo dia.

### Código interno versus label

Uma pergunta administrativa pode guardar internamente um código como:

```text
mz0103
```

mas apresentar ao utilizador:

```text
Mueda
```

A referência directa `${arrival_districts}` devolve o valor guardado, não o texto visível. Para usar o label no identificador, foi necessário recorrer a `jr:choice-name()`.

A lição é simples: **códigos internos devem ser usados para integração e análise; labels devem ser usados quando a legibilidade humana é prioritária**.

## 4. Lição 2 — A via operacional não é a mesma coisa que a gravidade

Uma decisão importante foi separar dois resultados:

### Via operacional

Baseia-se principalmente no número estimado de agregados familiares recém-deslocados actualmente presentes no local de chegada ou intervenção.

| Caseload | Via operacional |
|---:|---|
| Desconhecido | Requer verificação |
| Até 30 agregados familiares | Monitoria, sem resposta RRM automática |
| 31–99 | Alerta possível ou escalamento excepcional |
| 100–899 | Revisão formal, registo e pontuação |
| 900 ou mais | Escalamento crítico e apoio externo |

### Categoria de gravidade

É uma classificação descritiva baseada em sete dimensões:

| Dimensão | Pontuação máxima |
|---|---:|
| Dimensão do caseload | 20 |
| Intensidade do choque e tipo de movimento | 15 |
| Gravidade das necessidades no local de chegada | 20 |
| Pressão sobre a comunidade de acolhimento | 15 |
| Lacuna de avaliação e resposta | 15 |
| Acesso, segurança e viabilidade | 10 |
| Confiança nas fontes e lacunas de informação | 5 |
| **Total** | **100** |

As categorias finais adoptadas foram:

| Pontuação | Categoria |
|---:|---|
| 0–24 | Baixa |
| 25–49 | Moderada |
| 50–69 | Alta |
| 70–84 | Muito alta |
| 85–100 | Crítica |
| 900 ou mais agregados familiares | Crítica por limiar de caseload |
| Dados mínimos incompletos | Parcial ou requer verificação |

A pontuação ajuda a organizar a evidência e a tornar a análise comparável. Contudo, não substitui decisões de segurança, acesso, capacidade dos parceiros, risco de duplicação ou validação no terreno.

**A principal lição metodológica foi evitar transformar um score descritivo numa autorização automática de resposta.**

## 5. Lição 3 — A incerteza deve ser medida sem diminuir a gravidade

A sétima dimensão avalia confiança e lacunas de informação. Uma pontuação elevada nesta dimensão significa:

- fonte única ou indirecta;
- confiança baixa ou desconhecida;
- informação essencial em falta;
- necessidade de verificação prioritária;
- alerta ainda não pronto para classificação final.

Isto não significa que as necessidades sejam menos graves. Pelo contrário, um alerta com informação limitada pode descrever uma situação extremamente severa.

O sistema passou a apresentar separadamente:

```text
severity_category
scoring_status
priority_verification_need
```

Esta separação evita um erro frequente em análise humanitária: interpretar “não sabemos o suficiente” como “não existe problema”.

## 6. Lição 4 — A lógica deve ser unidireccional

Um dos erros mais importantes foi detectado pelo ODK Validate:

```text
Cycle detected in form's relevant and calculation logic
```

Os campos envolvidos eram:

```text
main_information_gaps
priority_verification_need
score_source_confidence
```

A pontuação controlava a visibilidade de uma pergunta que, por sua vez, alimentava a própria pontuação. O resultado era uma dependência circular.

A sequência foi redesenhada:

```text
source_types
      ↓
overall_confidence
      ↓
main_information_gaps
      ↓
priority_verification_need
      ↓
ready_for_scoring
      ↓
score_source_confidence
```

O campo calculado passou a depender apenas de respostas anteriores. Nenhuma dessas perguntas voltou a depender do score.

### Regra prática

Antes de adicionar uma expressão em `relevant`, `required`, `constraint`, `choice_filter` ou `calculation`, é útil desenhar as dependências como setas. Se uma variável puder regressar ao ponto de partida, existe risco de ciclo.

## 7. Lição 5 — `select_one` e `select_multiple` exigem sintaxes diferentes

Para uma pergunta `select_one`, uma condição pode ser escrita assim:

```text
${future_plan} = 'plan_return_place_of_origin'
```

Para uma pergunta `select_multiple`, é necessário verificar se uma opção está entre as respostas seleccionadas:

```text
selected(${displacement_reason}, 'armed_conflict')
```

O erro abaixo ocorreu porque `selected()` foi usado com apenas um argumento:

```text
selected(${arrival_district})
```

A função exige a pergunta e a opção procurada. Além disso, quando o objectivo é apenas recuperar o valor de uma pergunta `select_one`, `selected()` nem sequer é necessário.

### Respostas exclusivas

Opções como `Don't know`, `Prefer not to answer`, `None` e `Unknown` devem ser seleccionadas sozinhas. Uma restrição reutilizável é:

```text
(count-selected(.) = 1)
or
(
  not(selected(., 'dont_know'))
  and not(selected(., 'prefer_not_to_answer'))
)
```

Isto impede respostas contraditórias, como seleccionar simultaneamente `Armed conflict` e `Don't know`.

## 8. Lição 6 — O dropdown externo depende de consistência absoluta

Para permitir que o enumerador seleccionasse um alerta em vez de digitar o código, foi usado:

```text
select_one_from_file alerts.csv
```

A estrutura mais simples do ficheiro é:

```csv
name,label,community_site,origin_location,shock_event_en,shock_event_pt,shock_date_en,shock_date_pt
RRM_SCI_MUEDA_20260729_RBA3LB,RRM_SCI_MUEDA_20260729_RBA3LB | MUEDA | Nandimba,Nandimba,Mocímboa da Praia,armed attack,ataque armado,29 July 2026,29 de Julho de 2026
```

Neste modelo:

- `name` é o valor guardado;
- `label` é o texto apresentado;
- as restantes colunas contêm valores que podem ser recuperados.

O erro abaixo ocorreu quando o formulário procurava uma coluna `alert_id`, mas o CSV utilizava `name`:

```text
<value> node for itemset doesn't exist:
instance(alerts)/root/item/alert_id
```

Existem duas abordagens válidas, mas não podem ser misturadas:

### Colunas padrão

```csv
name,label
```

Neste caso, a coluna `parameters` do XLSForm fica vazia.

### Colunas personalizadas

```csv
alert_id,alert_label
```

Neste caso, a linha do formulário precisa de:

```text
value=alert_id label=alert_label
```

A mesma consistência é necessária em `pulldata()`. Nomes de ficheiros, extensões e cabeçalhos devem coincidir exactamente, incluindo maiúsculas e minúsculas.

## 9. Lição 7 — `pulldata()` reduz repetição e melhora a verificação

Depois de seleccionar o alerta, o formulário comunitário recupera automaticamente o contexto:

```text
pulldata(
  'alerts',
  'community_site',
  'name',
  ${alert_id_ref}
)
```

O primeiro argumento usa o nome do ficheiro sem `.csv`. O terceiro argumento identifica a coluna-chave e o quarto fornece o valor procurado.

Foram criados campos calculados para:

```text
alert_community_site
alert_origin_location
alert_shock_event_en
alert_shock_event_pt
alert_shock_date_en
alert_shock_date_pt
```

Esses valores alimentam uma pergunta dinâmica:

```text
Did you or your household arrive in ${alert_community_site}
from ${alert_origin_location}
following ${alert_shock_event_en}
on or around ${alert_shock_date_en}?
```

Em português:

```text
Você ou o seu agregado familiar chegou a ${alert_community_site},
vindo de ${alert_origin_location},
na sequência de ${alert_shock_event_pt},
por volta de ${alert_shock_date_pt}?
```

Esta pergunta funciona como uma verificação de elegibilidade e reduz a necessidade de o enumerador repetir informação já conhecida.

## 10. Lição 8 — O desenho multilingue inclui os dados externos

Traduzir apenas os labels da folha `survey` não é suficiente quando partes da pergunta vêm de um CSV.

Por exemplo, guardar apenas:

```text
armed_attack
```

não produz uma frase natural em inglês nem em português. Por isso, foram criadas colunas separadas:

```text
shock_event_en
shock_event_pt
shock_date_en
shock_date_pt
```

O ficheiro externo mantém um único `label` para o dropdown, enquanto os textos dinâmicos são recuperados em colunas linguísticas próprias.

A lição é que **a arquitectura multilingue deve abranger tanto o XLSForm como os dados externos que entram nos labels dinâmicos**.

## 11. Lição 9 — A aparência visual pode induzir o utilizador em erro

A aparência `autocomplete` mostra uma caixa onde o utilizador escreve parte do código ou label. Visualmente, pode parecer um campo de texto. Contudo, a resposta só é válida depois de seleccionar uma opção apresentada nos resultados.

Para listas curtas, `minimal` oferece um menu compacto. Para listas longas, `autocomplete` é mais eficiente, mas exige orientação clara aos enumeradores.

Esta diferença reforça a necessidade de testar o formulário no ambiente real de recolha. Uma configuração que parece intuitiva no Excel pode comportar-se de forma diferente no Enketo ou no KoboCollect.

## 12. Lição 10 — A validação deve ser incremental

Durante o desenvolvimento foram encontrados erros de várias categorias:

| Erro | Causa principal | Correcção |
|---|---|---|
| `selected requires 2 arguments` | Função usada para recuperar directamente uma resposta | Usar `${campo}` ou fornecer a opção procurada |
| `Missing calculation` | Linha `calculate` sem expressão ou fórmula na coluna errada | Preencher a coluna `calculation` |
| Ciclo de lógica | Um score controlava uma pergunta usada no próprio score | Reorganizar as dependências numa única direcção |
| ID repetido | O campo era concatenado novamente a cada recálculo | Usar `once()` e remover qualquer referência a `${alert_id}` |
| `Can't find alerts.csv` | Ficheiro não carregado ou nome diferente | Carregar em Media e confirmar o nome exacto |
| Coluna externa inexistente | XLSForm e CSV usavam cabeçalhos diferentes | Alinhar `name`, `label`, `parameters` e `pulldata()` |
| Dropdown apresentado como texto | Uso de `autocomplete` sem selecção do resultado | Seleccionar a opção ou adoptar `minimal` |
| Código administrativo no ID | Referência ao valor interno em vez do label | Usar `jr:choice-name()` |

A estratégia mais segura é adicionar complexidade por etapas:

1. validar metadados e perguntas básicas;
2. testar cada grupo separadamente;
3. adicionar os cálculos de dimensão um a um;
4. validar o total e a categoria;
5. testar relevâncias e restrições;
6. adicionar o CSV externo;
7. testar `pulldata()`;
8. testar no Enketo;
9. testar no KoboCollect online e offline;
10. realizar um piloto com utilizadores reais.

## 13. Recomendações para implementação em produção

### 13.1 Manter uma fonte controlada de alertas activos

O `alerts.csv` deve ser gerado a partir de uma tabela central, contendo apenas alertas válidos para selecção. Alertas fechados ou duplicados podem ser arquivados para reduzir erros.

### 13.2 Definir responsabilidade pela actualização

É necessário estabelecer:

- quem actualiza o ficheiro;
- com que frequência;
- quem valida duplicados;
- quando o formulário é reimplementado;
- como as equipas actualizam formulários no KoboCollect.

### 13.3 Evitar informação sensível no label

O dropdown pode mostrar distrito, local, data e organização, mas não deve incluir nomes de informantes, números de telefone ou detalhes de protecção.

### 13.4 Versionar o formulário e o dicionário de dados

Cada alteração importante deve actualizar a versão do formulário. Um dicionário deve documentar:

- nome da variável;
- tipo;
- definição;
- opções;
- cálculo;
- dependências;
- proprietário da regra;
- histórico de alterações.

### 13.5 Manter revisão humana

Pontuações e categorias devem ser revistas quando:

- existem fontes contraditórias;
- o alerta pode duplicar um movimento anterior;
- o caseload é incerto;
- há riscos de protecção;
- a cobertura de resposta não está confirmada;
- a informação muda depois de uma avaliação rápida.

## 14. Limitações da abordagem

O uso de CSV externo oferece controlo e previsibilidade, mas introduz uma etapa de manutenção. Um novo alerta só aparece no formulário comunitário depois de o ficheiro ser actualizado, carregado e sincronizado.

Outras limitações incluem:

- risco de versões diferentes do CSV entre dispositivos;
- necessidade de conectividade para actualizar formulários;
- dificuldade de representar traduções completas num único label externo;
- dependência de regras de pontuação que precisam de revisão periódica;
- possibilidade de o contexto mudar entre o alerta e a entrevista.

Quando a integração directa entre projectos for operacionalmente adequada, os **dynamic data attachments** podem reduzir a necessidade de manter um CSV separado. Ainda assim, ficheiros externos continuam úteis quando se pretende controlar a lista de registos activos, simplificar a selecção ou pré-processar labels antes da recolha.

## 15. Conclusão

A experiência demonstrou que KoboToolbox e XLSForm podem sustentar um fluxo relativamente sofisticado de gestão de alertas humanitários. O sistema desenvolvido liga registo inicial, classificação multidimensional e entrevistas comunitárias através de uma chave comum, ao mesmo tempo que reduz repetição de dados e melhora a rastreabilidade.

As maiores dificuldades não estiveram na quantidade de perguntas, mas nas relações entre variáveis. Identificadores instáveis, referências circulares, diferenças entre valores internos e labels, e inconsistências entre o XLSForm e os ficheiros externos foram mais críticos do que a construção visual do formulário.

A principal lição é que **a automação deve tornar a análise mais consistente e rápida, sem esconder as regras nem substituir a verificação humana**. Um bom sistema de alerta não é apenas um formulário que valida: é uma arquitectura de dados compreensível, auditável e alinhada com o processo operacional que pretende apoiar.

## Referências técnicas

- [KoboToolbox — Selecting options from an external file in XLSForm](https://support.kobotoolbox.org/select_from_file_xls.html)
- [KoboToolbox — Pulling data from an external CSV](https://support.kobotoolbox.org/pull_data_kobotoolbox.html)
- [KoboToolbox — Dynamic data attachments in XLSForm](https://support.kobotoolbox.org/dynamic_data_attachment.html)
- [ODK — Form operators and functions](https://docs.getodk.org/form-operators-functions/)
- [ODK — Form logic](https://docs.getodk.org/form-logic/)
- [XLSForm documentation](https://xlsform.org/en/)
