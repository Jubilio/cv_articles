---
title: "CensureMe"
description: "Uma extensão experimental para dar ao utilizador maior controlo sobre conteúdos sensíveis apresentados no navegador."
---

# CensureMe

**Tipo:** Extensão experimental para navegador  
**Tecnologias:** JavaScript, TensorFlow.js, NSFW.js e Chrome Extensions  
**Repositório:** [github.com/Jubilio/censureme](https://github.com/Jubilio/censureme)

## A ideia

O CensureMe começou como uma experiência sobre uma questão pessoal: como permitir que cada utilizador tenha mais controlo sobre o tipo de conteúdo que aparece no seu próprio navegador?

Em vez de depender apenas das regras de uma plataforma, a extensão procura oferecer uma camada configurável no lado do utilizador. A intenção não é decidir o que outras pessoas podem ver, mas permitir que alguém escolha filtros para a sua própria experiência de navegação.

## Como funciona

O protótipo combina diferentes mecanismos:

- análise visual de vídeo com NSFW.js e TensorFlow.js;
- deteção de palavras definidas pelo utilizador em legendas e textos;
- timestamps comunitários para sinalizar ou saltar segmentos;
- bloqueio configurável de sites adultos;
- ações como desfocar, silenciar, saltar ou cobrir o conteúdo;
- controlo de sensibilidade e ativação independente dos filtros.

Esta combinação foi importante porque nenhum método é suficiente isoladamente. Uma lista de palavras não compreende imagens, enquanto um classificador visual não conhece necessariamente o contexto de uma cena. O projeto explora como diferentes sinais podem trabalhar em conjunto.

## O que aprendi

O CensureMe levou-me para uma área diferente dos meus projetos de dados e GIS. Tive de pensar sobre:

- execução de modelos diretamente no navegador;
- impacto da análise em tempo real no desempenho;
- comunicação entre scripts de uma extensão;
- armazenamento de preferências;
- falsos positivos e falsos negativos;
- limites entre proteção, autonomia e censura;
- responsabilidade do utilizador ao configurar os filtros.

Também percebi que “IA” não elimina a necessidade de regras transparentes. Um classificador pode errar e o significado de uma cena depende do contexto. Por isso, considero o projeto um protótipo experimental de controlo pessoal de conteúdo, e não um sistema infalível de moderação.

## Privacidade e limitações

A proposta favorece processamento local sempre que possível. Ainda assim, qualquer evolução do projeto deve manter atenção especial à privacidade, às permissões do navegador e à forma como listas comunitárias seriam moderadas.

Entre as limitações atuais estão:

- precisão variável da deteção visual;
- possível impacto no desempenho de vídeos;
- necessidade de rever e atualizar listas de bloqueio;
- diferenças entre plataformas de vídeo;
- dificuldade de interpretar contexto apenas com modelos automáticos.

## Próximos passos possíveis

- painel mais claro para explicar por que um conteúdo foi sinalizado;
- regras diferentes por site;
- perfis de sensibilidade;
- testes automatizados em diferentes navegadores;
- processamento local mais eficiente;
- documentação sobre privacidade e modelo de ameaças;
- opção de exportar e importar configurações.

## Código

O protótipo e as instruções de instalação estão disponíveis no [repositório CensureMe](https://github.com/Jubilio/censureme).
