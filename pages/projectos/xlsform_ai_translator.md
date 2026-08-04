---
title: "XLSForm AI Translator"
---

# XLSForm AI Translator

**Tipo:** Suplemento experimental para Microsoft Excel  
**Tecnologias:** TypeScript, Office.js, Webpack, Express e Vitest  
**Código:** [github.com/Jubilio/xlsform-ai-translator](https://github.com/Jubilio/xlsform-ai-translator)

## O problema que quis resolver

Traduzir um formulário XLSForm não é o mesmo que traduzir um documento normal.

Além dos rótulos e mensagens apresentados ao entrevistador, o ficheiro contém nomes de variáveis, fórmulas, condições de relevância, referências como `${variable}`, listas de opções e elementos HTML. Uma tradução feita sem compreender essa estrutura pode deixar o texto correcto e, ao mesmo tempo, quebrar o formulário.

Criei o XLSForm AI Translator para explorar uma abordagem mais segura: usar serviços de tradução para o conteúdo linguístico, preservando a lógica técnica que KoboToolbox, ODK e outras plataformas precisam de interpretar.

## Como funciona

O suplemento funciona dentro do Excel e permite:

- escolher uma folha, intervalo ou conjunto de colunas para traduzir;
- criar e preencher colunas de idioma de destino;
- visualizar e rever resultados antes de os aplicar;
- proteger variáveis, fórmulas, URLs, HTML e quebras de linha;
- usar glossários para manter termos importantes consistentes;
- guardar um registo técnico das operações de tradução.

A arquitectura separa o suplemento do serviço que comunica com os fornecedores de tradução. Desta forma, as chaves de API permanecem no backend em vez de serem guardadas no livro Excel.

O projecto foi desenhado para suportar diferentes fornecedores, incluindo OpenAI, DeepL e Microsoft Translator, além de um modo simulado para desenvolvimento e testes.

## A principal lição

A maior aprendizagem foi perceber que integrar IA numa ferramenta profissional exige muito mais do que enviar texto a um modelo.

Foi necessário pensar em guardrails: quais células podem ser traduzidas, quais padrões devem ser protegidos, como verificar se os elementos técnicos permanecem intactos e em que momento uma pessoa deve rever o resultado.

Essa lógica é tão importante quanto a qualidade da tradução. Num XLSForm, uma pequena alteração numa expressão pode mudar o fluxo da entrevista ou impedir a publicação do formulário.

## Privacidade e uso responsável

A ferramenta destina-se à tradução da estrutura do questionário, não de dados recolhidos junto dos participantes. Informação pessoal, sensível ou identificável não deve ser enviada a serviços externos de tradução.

As traduções também devem passar por revisão humana, sobretudo quando envolvem terminologia local, consentimento, protecção ou conceitos técnicos. A IA acelera a primeira versão; não elimina a responsabilidade de validação linguística e funcional.

## Próximos passos

Quero aprofundar os testes de preservação de fórmulas e placeholders, melhorar a memória de tradução e os glossários, reforçar a validação automática do XLSForm e simplificar a configuração dos fornecedores.

O objectivo é tornar a tradução mais rápida sem perder aquilo que importa: consistência, controlo e integridade técnica.

[Ver o repositório do XLSForm AI Translator](https://github.com/Jubilio/xlsform-ai-translator)
