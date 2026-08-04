---
title: "Do alerta à entrevista comunitária: lições aprendidas na construção de um sistema RRM com KoboToolbox e XLSForm"
description: "Estudo de caso técnico sobre identificadores únicos, pontuação multidimensional, ligação entre formulários, grelhas de observação, ficheiros CSV externos, repeats, restrições e validação incremental."
---

# Do alerta à entrevista comunitária: lições aprendidas na construção de um sistema RRM com KoboToolbox e XLSForm

**Autor:** Jubílio Filiano Maússe  
**Actualizado:** 4 de Agosto de 2026

**Área:** Gestão de Informação Humanitária, KoboToolbox, XLSForm e Resposta Rápida

> Este artigo sistematiza as lições aprendidas durante o desenho e teste de um fluxo digital para registar alertas humanitários, classificar a sua gravidade e ligar cada alerta a entrevistas comunitárias e grelhas de observação. O foco está nas decisões de arquitectura, nos erros encontrados durante a validação e nas soluções que tornaram o sistema mais estável, rastreável e utilizável.

## Resumo

Sistemas de alerta para mecanismos de resposta rápida precisam de transformar informação inicial, frequentemente incompleta, numa base suficientemente estruturada para apoiar verificação, priorização e recolha complementar. Este artigo apresenta um estudo de caso aplicado sobre a construção de um sistema integrado com **KoboToolbox** e **XLSForm**, composto por um formulário de alerta, um formulário de entrevistas comunitárias e uma grelha de observação ligados por um identificador comum. A solução incluiu geração automática de códigos únicos, pontuação de sete dimensões de gravidade, separação entre classificação descritiva e via operacional, selecção de alertas por ficheiro CSV, recuperação automática de dados com `pulldata()`, perguntas dinâmicas, módulos de repetição para pontos de água, validações de múltipla escolha e optimização de imagens.

O desenvolvimento revelou desafios recorrentes: uso incorrecto de funções XLSForm, cálculos vazios, referências circulares, diferenças entre nomes internos e labels, inconsistências entre o XLSForm e ficheiros externos, erros de contexto dentro de repeats, filtros aplicados à lista errada e perguntas obrigatórias apresentadas fora do seu contexto. Os testes dos módulos HESPER e da grelha de observação mostraram ainda que um formulário pode passar na validação sintáctica e continuar a conter erros semânticos. As lições demonstram que a robustez de um sistema deste tipo depende sobretudo de uma arquitectura lógica unidireccional, identificadores estáveis, regras transparentes, validação incremental e testes no ambiente real de recolha.

**Palavras-chave:** KoboToolbox; XLSForm; RRM; alertas humanitários; gestão de informação; pontuação de gravidade; `pulldata()`; repeat groups; dados externos; controlo de qualidade.

---

## 1. Contexto e problema operacional

Um alerta humanitário é normalmente recebido antes de existir informação completa sobre o evento, o número de pessoas afectadas, as necessidades prioritárias, a cobertura da resposta ou as condições de acesso. Ainda assim, a equipa precisa de decidir rapidamente se deve monitorar, verificar, abrir formalmente um alerta, realizar uma avaliação rápida ou escalar o caso.

O desafio não era apenas digitalizar perguntas. Era criar um fluxo que ligasse quatro momentos:

1. registo inicial do alerta;
2. classificação e revisão interna;
3. entrevistas com pessoas associadas ao movimento;
4. observação directa das condições do local.

A arquitectura adoptada foi:

```text
Formulário de Alerta RRM
          │
          │ alert_id
          ├──────────────► Community Member
          │
          └──────────────► Observation Grid
```

A relação é **um-para-muitos**: um alerta pode estar associado a várias entrevistas e a uma ou mais observações. O `alert_id` funciona como chave comum para análise em Excel, R, Python, Power BI ou bases relacionais.

## 2. Arquitectura funcional

O formulário de alerta foi organizado em módulos de identificação, localização, choque, movimento, necessidades, pressão comunitária, cobertura, acesso, confiança e resultados calculados.

O formulário comunitário e a grelha de observação recuperam do alerta seleccionado:

- comunidade ou local de chegada;
- local de origem ou do choque;
- tipo de choque;
- data aproximada;
- outros campos úteis para verificação.

Esta arquitectura reduz repetição, melhora a rastreabilidade e permite comparar a informação inicial com a evidência recolhida posteriormente.

## 3. Lição 1 — O identificador deve ser único, estável e legível

Uma primeira fórmula produziu identificadores repetidos durante o recálculo:

```text
RRM_SCI_MUEDA_20260728_RRM_SCI_MUEDA_20260728_...
```

A solução foi criar o identificador uma única vez com `once()` e nunca referenciar `${alert_id}` dentro do seu próprio cálculo:

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

Exemplo:

```text
RRM_SCI_MUEDA_20260729_RBA3LB
```

### Código interno versus label

Uma selecção administrativa pode guardar `mz0112`, mas mostrar `Mueda`. A referência `${arrival_districts}` devolve o código interno; `jr:choice-name()` devolve o label.

A regra adoptada foi:

- usar códigos internos para integração e análise;
- usar labels quando a legibilidade humana é necessária;
- evitar dados pessoais no identificador;
- manter sempre um sufixo aleatório para prevenir duplicados.

## 4. Lição 2 — A via operacional não é a mesma coisa que a gravidade

A via operacional foi calculada principalmente pelo caseload:

| Caseload | Via operacional |
|---:|---|
| Desconhecido | Requer verificação |
| Até 30 agregados familiares | Monitoria, sem resposta RRM automática |
| 31–99 | Alerta possível ou escalamento excepcional |
| 100–899 | Revisão formal, registo e pontuação |
| 900 ou mais | Escalamento crítico e apoio externo |

A gravidade foi tratada como classificação descritiva de sete dimensões:

| Dimensão | Máximo |
|---|---:|
| Caseload | 20 |
| Choque e movimento | 15 |
| Necessidades | 20 |
| Pressão comunitária | 15 |
| Lacuna de cobertura | 15 |
| Acesso e viabilidade | 10 |
| Confiança e lacunas | 5 |
| **Total** | **100** |

Categorias:

| Pontuação | Categoria |
|---:|---|
| 0–24 | Baixa |
| 25–49 | Moderada |
| 50–69 | Alta |
| 70–84 | Muito alta |
| 85–100 | Crítica |
| Caseload ≥900 | Crítica por limiar |
| Dados mínimos incompletos | Parcial ou requer verificação |

A pontuação organiza a evidência, mas não substitui revisão humana, segurança, acesso, capacidade dos parceiros ou análise de duplicação.

## 5. Lição 3 — Incerteza não significa baixa gravidade

A dimensão de confiança mede a qualidade e completude da informação. Um valor elevado pode indicar fonte única, baixa confiança, lacunas importantes ou necessidade de verificação. Não significa que a situação seja menos grave.

O sistema separou:

```text
severity_category
scoring_status
priority_verification_need
```

Assim, “não sabemos o suficiente” não é interpretado como “não existe problema”.

## 6. Lição 4 — A lógica deve ser unidireccional

O ODK Validate detectou um ciclo entre:

```text
main_information_gaps
priority_verification_need
score_source_confidence
```

A pontuação controlava a relevância de uma pergunta que alimentava a própria pontuação. A sequência foi reorganizada:

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

Antes de escrever `relevant`, `required`, `constraint`, `choice_filter` ou `calculation`, é útil desenhar as dependências. Uma variável calculada não deve controlar uma pergunta que participa directa ou indirectamente no próprio cálculo.

## 7. Lição 5 — `select_one` e `select_multiple` exigem lógicas diferentes

Para `select_one`:

```text
${future_plan} = 'plan_return_place_of_origin'
```

Para `select_multiple`:

```text
selected(${displacement_reason}, 'armed_conflict')
```

O erro seguinte ocorreu porque `selected()` recebeu apenas um argumento:

```text
selected(${arrival_district})
```

Quando se pretende apenas recuperar o valor de um `select_one`, usa-se `${arrival_district}` directamente.

## 8. Lição 6 — As restrições fazem parte do desenho analítico

As opções especiais, como `unknown`, `none_observed`, `dk` e `pnta`, devem ser exclusivas. Além disso, algumas perguntas precisam de limitar o número de escolhas.

### Até três opções e respostas exclusivas

```text
(count-selected(.) <= 3)
and
(
  count-selected(.) = 1
  or
  (
    not(selected(., 'none_observed'))
    and not(selected(., 'unknown'))
  )
)
```

Esta regra permite até três obstáculos reais, mas obriga `none_observed` e `unknown` a serem seleccionados sozinhos.

Uma forma mais directa, aplicável quando as opções exclusivas são `none`, `dk` e `pnta`, é:

```text
count-selected(.) <= 3
and not(
  (
    selected(., 'none')
    or selected(., 'dk')
    or selected(., 'pnta')
  )
  and count-selected(.) > 1
)
```

O operador lógico é importante. Uma expressão com `or`, como `count-selected(.) >= 1 or ...`, pode aceitar combinações contraditórias porque basta que uma das condições seja verdadeira. A validação deve ser testada com combinações válidas e inválidas, não apenas visualmente revista.

### Pelo menos uma opção

```text
(count-selected(.) >= 1)
and
(
  count-selected(.) = 1
  or
  (
    not(selected(., 'no_major_constraint'))
    and not(selected(., 'unknown'))
  )
)
```

O mesmo padrão foi aplicado a tipos de abrigo, necessidades visíveis, instalações sanitárias, locais de lavagem das mãos, artigos essenciais, restrições de abastecimento e tipos de unidades de saúde.

A lição é que `required=TRUE` e `constraint` cumprem papéis diferentes: `required` impede resposta vazia; `constraint` impede combinações contraditórias ou excessivas.

## 9. Lição 7 — O dropdown externo exige consistência absoluta

O formulário usa:

```text
select_one_from_file alerts.csv
```

Estrutura recomendada:

```csv
name,label,community_site,origin_location,shock_event_en,shock_event_pt,shock_date_en,shock_date_pt
RRM_SCI_MUEDA_20260729_RBA3LB,RRM_SCI_MUEDA_20260729_RBA3LB | MUEDA | Nandimba,Nandimba,Mocímboa da Praia,armed attack,ataque armado,29 July 2026,29 de Julho de 2026
```

Com `name` e `label`, a coluna `parameters` pode ficar vazia. Caso sejam usadas colunas personalizadas, como `alert_id` e `alert_label`, deve-se indicar:

```text
value=alert_id label=alert_label
```

Não se pode misturar uma estrutura com a outra. O mesmo cuidado aplica-se ao nome exacto de `alerts.csv`, às colunas usadas no `pulldata()` e à versão carregada nos ficheiros media.

## 10. Lição 8 — `pulldata()` reduz repetição e melhora a verificação

Exemplo:

```text
pulldata(
  'alerts',
  'community_site',
  'name',
  ${alert_id_ref}
)
```

O primeiro argumento é o nome do ficheiro sem `.csv`. Os dados recuperados podem formar uma pergunta dinâmica:

```text
Did you or your household arrive in ${alert_community_site}
from ${alert_origin_location}
following ${alert_shock_event_en}
on or around ${alert_shock_date_en}?
```

O desenho bilingue exige colunas próprias para textos dinâmicos, como `shock_event_en`, `shock_event_pt`, `shock_date_en` e `shock_date_pt`.

## 11. Lição 9 — A interface pode parecer incompleta antes da selecção do alerta

Durante o teste, várias perguntas apareceram sem opções visíveis. Inicialmente, isto pareceu indicar um problema na folha `choices`. Contudo, as opções surgiram depois de seleccionar o código do alerta.

O problema real era de experiência do utilizador: módulos posteriores dependiam do `alert_id_ref`, mas ainda eram apresentados antes de a dependência estar satisfeita.

A solução recomendada é colocar nos `begin_group` seguintes:

```text
${alert_id_ref} != ''
```

Também é útil adicionar um hint:

```text
Seleccione o alerta antes de continuar. As restantes opções serão carregadas após a selecção.
```

A lição é que uma lógica tecnicamente correcta pode parecer defeituosa quando o formulário não comunica claramente a sequência esperada.

## 12. Lição 10 — Repeats exigem atenção ao contexto XPath

A grelha de observação incluiu um repeat para pontos de água. O número de repetições é definido pela quantidade de pontos efectivamente observados:

```text
type: begin_repeat
name: water_point_loop
relevant:
${water_points_observed} = 'yes'
and ${water_points_assessed_count} > 0

repeat_count:
${water_points_assessed_count}
```

Dentro do repeat, o identificador sequencial pode ser criado com:

```text
concat(
  'WP',
  if(
    position(..) < 10,
    concat('0', position(..)),
    position(..)
  )
)
```

Resultados:

```text
WP01
WP02
WP03
```

Um erro do Enketo mostrou que uma referência como `../water_point_id` podia falhar quando o nó esperado não existia no contexto em que o label ou note era avaliado:

```text
FormLogicError: Could not evaluate: ../water_point_id
```

A abordagem segura foi testar primeiro o repeat sem notes dinâmicos, confirmar `repeat_count`, `calculation` e a posição de `end_repeat`, e só depois adicionar elementos de apresentação.

Regras práticas:

- usar a coluna `repeat_count`, não `calculation`;
- manter `end_repeat` antes do `end_group` externo;
- evitar referências ambíguas entre níveis;
- testar o repeat isoladamente;
- não tornar GPS obrigatório quando a instrução diz “se seguro e viável”.

## 13. Lição 11 — A folha `choices` pode estar correcta e ainda assim parecer vazia

As listas internas devem existir numa folha chamada exactamente `choices`, com `list_name`, `name` e labels. Os valores em `type` precisam de coincidir exactamente com `list_name`.

No entanto, quando perguntas ou grupos dependem do alerta, a ausência temporária das opções pode ser causada pela lógica de relevância e não pela folha `choices`.

Por isso, o diagnóstico deve seguir esta ordem:

1. confirmar o `list_name`;
2. confirmar que a folha se chama `choices`;
3. confirmar que o formulário implementado contém a versão mais recente;
4. verificar `choice_filter` e `relevant`;
5. seleccionar os campos dos quais a lista depende;
6. testar novamente no Enketo e KoboCollect.

## 14. Lição 12 — Avisos de imagem também são requisitos operacionais

O XLSForm recomendou definir `max-pixels` nas perguntas de imagem. Isto não era um erro de validação, mas afectava desempenho, armazenamento e tempo de envio.

Parâmetro adoptado:

```text
max-pixels=1280
```

O parâmetro fica em `parameters`, não em `appearance`.

Esta optimização é particularmente importante quando uma grelha contém fotografias de estradas, abrigos, pontos de água, mercados, unidades sanitárias e escolas. Uma decisão aparentemente técnica influencia directamente o trabalho offline, o consumo de dados móveis e a velocidade de sincronização.

## 15. Lição 13 — A validação deve ser incremental

Os principais erros encontrados foram:

| Mensagem ou sintoma | Causa | Correcção |
|---|---|---|
| `selected requires 2 arguments` | Uso incorrecto de `selected()` | Fornecer dois argumentos ou usar `${campo}` |
| `Missing calculation` | Linha `calculate` vazia ou desalinhada | Preencher `calculation` |
| Ciclo de lógica | Campo calculado regressava a uma pergunta de origem | Reorganizar dependências |
| ID repetido | Concatenação em cada recálculo | Usar `once()` |
| `Can't find alerts.csv` | Ficheiro ausente ou nome diferente | Carregar em Media |
| Coluna externa inexistente | CSV e XLSForm desalinhados | Harmonizar cabeçalhos |
| Opções aparentemente ausentes | Alerta ainda não seleccionado | Tornar a sequência explícita |
| Erro `../water_point_id` | Contexto inválido dentro do repeat | Simplificar e testar o repeat |
| Aviso `max-pixels` | Imagem sem limite | Adicionar parâmetro |
| Combinações contraditórias | Respostas especiais não exclusivas | Criar `constraint` |

Sequência de teste recomendada:

1. validar metadados e perguntas simples;
2. testar listas internas;
3. testar grupos e relevâncias;
4. adicionar cálculos um a um;
5. testar o score total;
6. adicionar o CSV;
7. testar `pulldata()`;
8. testar repeats separadamente;
9. testar restrições;
10. testar imagens;
11. validar no Enketo;
12. validar no KoboCollect, online e offline;
13. realizar piloto com enumeradores.

## 16. Lição 14 — Passar no ODK Validate não garante coerência operacional

As revisões finais das entrevistas comunitárias e da grelha de observação mostraram uma diferença essencial entre **validade sintáctica** e **validade semântica**. O ODK Validate detecta expressões mal formadas, referências inexistentes e alguns ciclos, mas não consegue determinar se uma pergunta aparece no momento certo ou se a regra corresponde ao significado operacional pretendido.

### O tipo da pergunta determina a expressão

Uma variável `text` não deve ser tratada como uma escolha. No módulo HESPER, `hesper_other` guardava texto livre, mas aparecia numa fórmula como:

```text
selected(${hesper_other}, 'serious_problem')
```

A verificação correcta é:

```text
string-length(normalize-space(${hesper_other})) > 0
```

Da mesma forma, uma pergunta `select_one` não precisa de `count-selected()` para garantir exclusividade. `required=TRUE` assegura uma resposta quando a pergunta está visível, enquanto a comparação deve usar directamente o valor:

```text
${ds_plans_timeline} = 'within_one_month'
```

### As prioridades devem depender do número de problemas elegíveis

As três prioridades HESPER eram inicialmente apresentadas quando existia apenas um problema sério. A solução foi calcular primeiro o número de problemas elegíveis e aplicar limiares diferentes:

| Pergunta | Condição de relevância |
|---|---|
| Primeira prioridade | `${hesper_serious_count} >= 1` |
| Segunda prioridade | `${hesper_serious_count} >= 2` |
| Terceira prioridade | `${hesper_serious_count} >= 3` |

Além de melhorar a experiência do enumerador, esta regra impede prioridades vazias ou duplicadas. As opções da segunda e terceira prioridades devem também excluir as escolhas já realizadas.

### `choice_filter` é específico da lista utilizada

Um filtro construído para a lista `serious_problem` foi aplicado por engano a uma pergunta que utilizava `priority_support`. Embora a expressão fosse tecnicamente válida, as opções eram ocultadas de forma incorrecta. A regra adoptada foi verificar sempre, em conjunto:

1. o `list_name` declarado em `type`;
2. as colunas existentes nessa lista na folha `choices`;
3. os nomes usados no `choice_filter`;
4. pelo menos um cenário em que cada opção deve aparecer.

Quando a lista de apoio já contém todas as opções válidas, o filtro deve ficar vazio.

### Perguntas de detalhe precisam de uma porta de entrada

Na grelha de observação, perguntas sobre mercados, unidades sanitárias e espaços educativos eram obrigatórias mesmo quando nenhum serviço tinha sido observado. A correcção foi condicionar os blocos de detalhe:

```text
${market_observed} = 'yes'
${health_facility_observed} = 'yes'
${education_facility_observed} = 'yes'
```

É preferível aplicar a condição a um subgrupo que contenha todos os detalhes. Isto reduz repetição e evita que uma nova pergunta seja adicionada sem a relevância necessária.

### Contagens devem admitir “não observado” e “não foi possível avaliar”

No módulo de pontos de água, as contagens eram obrigatórias mesmo quando o observador indicava que não conseguia avaliar os pontos. O fluxo revisto tornou a pergunta de triagem obrigatória e apresentou as contagens apenas após uma resposta afirmativa:

```text
water_points_observed: required=TRUE

water_points_present_count relevant:
${water_points_observed} = 'yes'

water_points_assessed_count relevant:
${water_points_observed} = 'yes'
and ${water_points_present_count} >= 1
```

A restrição garante coerência entre as duas contagens:

```text
. >= 1 and . <= ${water_points_present_count}
```

Assim, `no`, `unknown` e `not_able_to_assess` seguem um caminho válido sem exigir um número inventado.

### Nomes internos, labels e traduções fazem parte da validação

Uma lista continha a opção `one_observed`, enquanto a restrição procurava `none_observed`. Noutra lista, existia um campo “Other, specify”, mas não existia a opção `other`. Estes casos confirmam que a revisão deve comparar sistematicamente:

- nomes usados em `selected()` com os `name` da folha `choices`;
- opções `other` com os respectivos campos de especificação;
- labels em inglês e português;
- texto da pergunta com o sector correcto;
- `required`, `relevant` e `constraint` como uma única regra lógica.

Uma tradução vazia não quebra necessariamente o XForm, mas quebra a experiência bilingue. Por isso, a completude linguística deve fazer parte do controlo de qualidade antes da implementação.

### Resultados pós-agregação não pertencem ao cálculo da entrevista

Outputs como a proporção comunitária de indicadores em gravidade 4/4+, scores sectoriais, drivers e mensagens-chave dependem da agregação de vários informadores-chave. Não devem ser calculados dentro de uma submissão individual do Kobo. O formulário recolhe os indicadores e preserva a chave de ligação; o script de análise agrega por alerta e comunidade, exclui `dk/pnta`, calcula numeradores e denominadores e documenta a confiança do resultado.

Esta separação evita apresentar um resultado individual como se fosse uma conclusão comunitária.

## 17. Recomendações para produção

### Manter uma fonte controlada de alertas activos

O `alerts.csv` deve conter apenas alertas válidos para selecção. Alertas fechados ou duplicados devem ser arquivados.

### Definir responsabilidade pela actualização

É necessário definir quem actualiza o CSV, quem valida duplicados, quando o formulário é reimplementado e como os dispositivos são sincronizados.

### Versionar o formulário

A folha `settings` deve conter `form_title`, `form_id`, `version` e `default_language`. Cada alteração importante deve aumentar a versão.

### Documentar nomes e opções

Um dicionário deve registar variável, tipo, definição, opções, cálculo, dependências, proprietário da regra e histórico de alterações.

### Manter revisão humana

Pontuações e categorias precisam de revisão quando existem fontes contraditórias, caseload incerto, risco de duplicação, informação sensível ou mudanças após a avaliação.

## 18. Limitações

A utilização de CSV externo introduz uma etapa de manutenção. Novos alertas só aparecem depois de actualizar, carregar e sincronizar o ficheiro.

Outras limitações:

- versões diferentes do CSV entre dispositivos;
- necessidade de conectividade para actualização;
- regras de pontuação que exigem revisão periódica;
- diferenças de comportamento entre Enketo e KoboCollect;
- complexidade adicional em repeats e referências entre níveis;
- possibilidade de o contexto mudar entre o alerta e a entrevista.

Quando operacionalmente adequado, integrações dinâmicas entre projectos podem reduzir a manutenção manual. Ainda assim, o CSV continua útil para controlar a lista activa e preparar labels legíveis.

## 19. Conclusão

KoboToolbox e XLSForm podem sustentar um fluxo sofisticado de gestão de alertas, pontuação, entrevistas e observação directa. O valor do sistema não está apenas nas fórmulas, mas na existência de uma arquitectura comum, uma chave estável e regras compreensíveis.

As maiores dificuldades estiveram nas relações entre variáveis: identificadores instáveis, dependências circulares, diferenças entre códigos e labels, inconsistências com ficheiros externos, referências em repeats, filtros incompatíveis com as listas, perguntas obrigatórias fora do seu contexto e combinações contraditórias em perguntas de múltipla escolha.

A principal lição é que **a automação deve tornar a análise mais consistente e rápida, sem esconder as regras nem substituir a verificação humana**. Um bom sistema não é apenas um formulário que passa na validação: é uma arquitectura de dados compreensível, auditável, testada e alinhada com o processo operacional que pretende apoiar.
