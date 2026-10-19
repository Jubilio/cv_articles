---
title: "Da análise à comunicação: um roteiro para aprender visualização de dados"
description: "Sete recursos sobre visualização de dados, R, ggplot2 e storytelling, com um roteiro de leitura e um exercício aplicado à análise humanitária."
---

# Da análise à comunicação: um roteiro para aprender visualização de dados

**Autor:** Jubílio Filiano Maússe  
**Data:** 19 de Outubro de 2026  
**Área:** Visualização de dados, R, análise humanitária e comunicação de resultados

## Resumo

Aprender a visualizar dados envolve escolhas sobre análise, desenho e comunicação. Este artigo reúne sete recursos que ajudam a desenvolver essas competências: *ggplot2: Elegant Graphics for Data Analysis*, *Hands-On Data Visualization*, *R Graphics Cookbook*, a colecção *Storytelling with Data*, *Fundamentals of Data Visualization*, *Data Visualization: A Practical Introduction* e *R for Health Data Science*. A proposta é explicar o contributo de cada recurso e organizar uma sequência de aprendizagem. Um exercício com dados fictícios de necessidades humanitárias mostra como passar de uma tabela para um gráfico legível, mantendo explícitos o denominador, a fonte e os limites da interpretação.

**Palavras-chave:** visualização de dados; R; ggplot2; storytelling; análise humanitária; comunicação; aprendizagem reproduzível.

## 1. Começar pela pergunta

Uma tabela pode estar correcta e continuar difícil de interpretar. Quando um relatório apresenta dezenas de indicadores, o leitor precisa de perceber quais são as diferenças relevantes, que comparações são possíveis e até onde os dados permitem concluir.

Antes de escolher cores ou escrever código, proponho responder a três perguntas: o que queremos mostrar, quem vai utilizar a informação e que decisão essa pessoa precisa de tomar? Comparar distritos, acompanhar uma evolução e explorar uma relação são tarefas diferentes; cada uma pede uma representação adequada.

Na análise humanitária, acrescentaria uma pergunta: estamos a comparar a mesma população, com a mesma definição de indicador e o mesmo período de referência? Um gráfico bem desenhado depende dessas verificações. Os recursos seguintes ajudam a ligar essa preparação à apresentação dos resultados.

## 2. Sete recursos, contributos diferentes

### 2.1 ggplot2: Elegant Graphics for Data Analysis

O livro de **Hadley Wickham, Danielle Navarro e Thomas Lin Pedersen** explica a gramática dos gráficos implementada pelo ggplot2. O seu principal contributo é mostrar como dados, mapeamentos estéticos, camadas, escalas e sistemas de coordenadas se articulam para construir uma visualização [1].

É uma leitura útil quando já conseguimos produzir alguns gráficos e queremos compreender melhor como os adaptar. Em vez de procurar uma receita para cada situação, passamos a reconhecer os componentes que podemos combinar.

**Aplicação proposta:** construir uma comparação entre distritos e experimentar como a ordenação das categorias, as escalas e as anotações alteram a leitura.

### 2.2 Hands-On Data Visualization

**Jack Dougherty e Ilya Ilyankou** apresentam um percurso que começa em ferramentas acessíveis e avança para modelos de código. O livro inclui gráficos interactivos e mapas, com ferramentas como Google Sheets, Datawrapper e Tableau Public, além de exemplos com Chart.js e Leaflet. Não exige experiência prévia de programação [2].

É particularmente útil para quem precisa de partilhar resultados na Web ou colaborar com colegas que trabalham sobretudo em folhas de cálculo.

**Aplicação proposta:** transformar uma tabela agregada de cobertura de serviços num mapa interactivo, verificando a legibilidade em telemóvel. A publicação deve usar dados apropriados para acesso público, evitando expor localizações sensíveis de agregados familiares.

### 2.3 R Graphics Cookbook

O livro de **Winston Chang** organiza soluções práticas para problemas específicos de gráficos em R. A edição online apresenta mais de 150 receitas, acompanhadas de explicações sobre o funcionamento das soluções [3].

Serve bem como referência durante o trabalho: temos uma tarefa concreta, procuramos uma solução e adaptamos o exemplo aos nossos dados.

**Aplicação proposta:** consultar uma receita para melhorar rótulos ou legendas de um gráfico já existente e verificar se a alteração facilita a comparação que interessa ao leitor.

### 2.4 Storytelling with Data

A colecção associada a **Cole Nussbaumer Knaflic** centra-se na comunicação de resultados. O livro original apresenta um processo para criar gráficos claros; *let’s practice!* acrescenta exercícios; *storytelling with you* aborda apresentações; e *before & after* reúne estudos de transformação de gráficos e slides [4].

O interesse deste conjunto está na passagem da análise para uma mensagem adequada ao público. É também útil distinguir o acesso aos livros das amostras e materiais complementares disponibilizados no site: esta página é um catálogo, e não uma edição integral gratuita de toda a colecção.

**Aplicação proposta:** rever uma página de relatório, reduzir elementos que competem pela atenção e escrever um título que comunique uma conclusão sustentada pelos dados.

### 2.5 Fundamentals of Data Visualization

**Claus O. Wilke** apresenta um guia para produzir visualizações que representem os dados com rigor, comuniquem uma história e tenham apresentação profissional. O site disponibiliza o manuscrito integral do autor, anterior à revisão editorial final [5].

É um bom ponto de partida para desenvolver critérios de avaliação visual antes de aprofundar uma ferramenta específica.

**Aplicação proposta:** comparar duas representações do mesmo indicador e justificar a escolha com base na tarefa de leitura, na clareza das escalas e na facilidade de comparação.

### 2.6 Data Visualization: A Practical Introduction

O livro de **Kieran Healy** liga princípios de visualização à produção de gráficos reproduzíveis em R e ggplot2. O percurso inclui preparação de dados, construção de gráficos, modelos, mapas e refinamento visual, sem pressupor conhecimento anterior de R [6].

É adequado para quem quer aprender a produzir os exemplos e compreender as escolhas que os sustentam.

**Aplicação proposta:** reproduzir um exemplo, substituir os dados por uma tabela própria e registar as alterações necessárias. Esse processo ajuda a perceber se compreendemos o código e as variáveis representadas.

### 2.7 R for Health Data Science

O livro de **Ewen Harrison e Riinu Pius** acrescenta uma perspectiva de ciência de dados aplicada à saúde. A versão electrónica disponibiliza também uma ligação aos conjuntos de dados utilizados nos exemplos [7].

Neste roteiro, proponho utilizá-lo como complemento temático para leitores que trabalham com dados de saúde e querem relacionar a visualização com um processo analítico mais amplo.

**Aplicação proposta:** seleccionar um exemplo com dados disponibilizados pelos autores, identificar a unidade de análise e explicar o resultado com uma figura e uma nota metodológica curta.

## 3. Qual escolher primeiro?

A tabela seguinte apresenta a minha proposta de utilização, tendo em conta o objectivo de aprendizagem.

| Objectivo | Recurso de entrada | Passo seguinte |
| --- | --- | --- |
| Desenvolver critérios de desenho visual | Fundamentals of Data Visualization | Avaliar um gráfico próprio |
| Começar a produzir gráficos em R | Data Visualization: A Practical Introduction | Reproduzir e adaptar um exemplo |
| Compreender a lógica do ggplot2 | ggplot2: Elegant Graphics for Data Analysis | Construir um gráfico por camadas |
| Resolver um problema específico em R | R Graphics Cookbook | Adaptar uma receita ao projecto |
| Publicar gráficos e mapas interactivos | Hands-On Data Visualization | Criar uma página com dados agregados |
| Melhorar a comunicação num relatório | Storytelling with Data | Rever título, destaque e anotações |
| Trabalhar com exemplos de dados de saúde | R for Health Data Science | Relacionar figura e interpretação |

Para quem começa em R, sugiro combinar Healy com Wilke: praticar a construção e avaliar a apresentação. O livro de ggplot2 permite depois aprofundar os mecanismos; o Cookbook acompanha as dúvidas concretas. Para quem já produz gráficos regularmente, uma revisão orientada pela comunicação pode ter aplicação imediata.

## 4. Exercício: de uma tabela para uma mensagem legível

Considere uma tabela **inteiramente fictícia**, com quatro distritos e uma variável binária: se o agregado familiar reportou dificuldade de acesso à água. Os valores abaixo servem apenas para demonstrar o código; não representam resultados de uma avaliação.

O exemplo usa somente o pacote `ggplot2`. Caso ainda não esteja instalado, execute `install.packages("ggplot2")` uma vez.

```r
library(ggplot2)

dados <- data.frame(
  distrito = c("Distrito A", "Distrito B", "Distrito C", "Distrito D"),
  respostas_validas = c(80, 100, 60, 90),
  com_dificuldade = c(52, 48, 18, 36)
)

dados$proporcao <- dados$com_dificuldade / dados$respostas_validas
dados$distrito <- reorder(dados$distrito, dados$proporcao)
dados$rotulo <- sprintf(
  "%.0f%% (n=%d)",
  100 * dados$proporcao,
  dados$respostas_validas
)

grafico <- ggplot(dados, aes(x = proporcao, y = distrito)) +
  geom_col(fill = "#21647D", width = 0.65) +
  geom_text(aes(label = rotulo), hjust = -0.1, size = 3.8) +
  scale_x_continuous(
    limits = c(0, 1),
    breaks = seq(0, 1, 0.25),
    labels = function(x) paste0(100 * x, "%"),
    expand = expansion(mult = c(0, 0.02))
  ) +
  labs(
    title = "O Distrito A apresenta a maior proporção na amostra fictícia",
    subtitle = "Agregados familiares que reportam dificuldade de acesso à água",
    x = "Percentagem das respostas válidas",
    y = NULL,
    caption = paste(
      "Fonte: dados fictícios para aprendizagem. n = respostas válidas.",
      "Proporções não ponderadas; sem inferência para a população.",
      sep = "\n"
    )
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title.position = "plot",
    plot.caption = element_text(hjust = 0)
  )

print(grafico)
ggsave("dificuldade_acesso_agua.png", grafico,
       width = 10, height = 5.5, dpi = 300)
```

A ordenação facilita a comparação; os rótulos permitem ler os valores; a nota explica o significado de `n`. O título descreve o que aparece na amostra fictícia, sem transformar a diferença observada numa conclusão sobre a população.

Num projecto real, substituir esta tabela exige rever o denominador e o desenho amostral. A divisão simples utilizada aqui não substitui uma estimativa ponderada quando esta é necessária. Também convém avaliar a incerteza antes de interpretar diferenças entre distritos, sobretudo quando as bases de resposta são pequenas ou muito diferentes.

O exercício pode ser repetido em três etapas: produzir uma primeira versão, pedir a um colega que explique o que entendeu e rever a figura com base nas dificuldades de leitura identificadas. A justificação das alterações é tão útil quanto o gráfico final.

## 5. Levar a aprendizagem para o trabalho

Para aplicar estes recursos, proponho escolher um único gráfico de um relatório recente. Primeiro, escrever a pergunta analítica e confirmar a definição do indicador. Depois, reproduzir a figura a partir dos dados e guardar o código. Por fim, rever escalas, rótulos, cores e título, verificando se a mensagem continua fiel aos resultados.

Na revisão, vale confirmar se unidades e períodos estão explícitos, se ausência de dados foi distinguida de zero e se comparações usam bases compatíveis. Em mapas, convém perguntar se a dimensão territorial está a dominar a leitura de um indicador que seria mais claro num gráfico de barras.

Os livros podem acompanhar momentos diferentes desse processo: os fundamentos ajudam a escolher, os exemplos ensinam a construir e os recursos de comunicação ajudam a apresentar. A prática consiste em fazer essas escolhas de forma consciente e conseguir explicá-las a quem vai utilizar a informação.

## Recurso complementar: modelação estatística com Stata e R

O curso [Statistical Modelling with Stata](https://personalpages.manchester.ac.uk/staff/Mark.Lunt/stats_course.html), de **Mark Lunt, da Universidade de Manchester**, complementa este roteiro com fundamentos de análise estatística. Foi originalmente preparado para ensinar investigadores a analisar dados em Stata; os exercícios práticos foram também adaptados para R por **David Selby** [8].

Os temas incluem resumos gráficos e numéricos, amostragem, intervalos de confiança, testes de hipóteses, modelos lineares, regressão logística, resultados categóricos, modelos de contagem e análise de sobrevivência. A página reúne slides, exercícios, soluções e conjuntos de dados. Os autores indicam que a adaptação entre Stata e R continua em desenvolvimento.

**Como utilizar neste roteiro:** começar pelas sessões sobre resumos de dados e amostragem, relacionando a escolha dos gráficos com a interpretação das estimativas e da incerteza. Depois, avançar para os modelos adequados à pergunta analítica e ao tipo de variável.

**Aplicação proposta:** reproduzir um exercício em R e apresentar o resultado com um gráfico, uma interpretação curta e uma explicação dos pressupostos utilizados. Para aplicar a avaliações humanitárias, verificar adicionalmente como o desenho amostral deve ser considerado na análise.

## Referências e recursos

1. Wickham, H.; Navarro, D.; Pedersen, T. L. [ggplot2: Elegant Graphics for Data Analysis](https://ggplot2-book.org/).
2. Dougherty, J.; Ilyankou, I. [Hands-On Data Visualization: Interactive Storytelling from Spreadsheets to Code](https://handsondataviz.org/).
3. Chang, W. [R Graphics Cookbook, 2nd edition](https://r-graphics.org/).
4. Storytelling with Data. [Livros e materiais complementares](https://www.storytellingwithdata.com/books).
5. Wilke, C. O. [Fundamentals of Data Visualization](https://clauswilke.com/dataviz/).
6. Healy, K. [Data Visualization: A Practical Introduction](https://socviz.co/).
7. Harrison, E.; Pius, R. [R for Health Data Science](https://argoshare.is.ed.ac.uk/healthyr_book/).
8. Lunt, M. [Statistical Modelling with Stata — exercícios também disponíveis em R](https://personalpages.manchester.ac.uk/staff/Mark.Lunt/stats_course.html).
