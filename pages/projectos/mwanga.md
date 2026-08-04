---
title: "Mwanga"
---

# Mwanga

**Tipo:** Plataforma independente de finanças pessoais e familiares em desenvolvimento  
**Tecnologias:** React, Vite, Node.js, Express, SQLite/PostgreSQL, PWA e Capacitor  
**Código:** [github.com/Jubilio/mwanga](https://github.com/Jubilio/mwanga)

## Porque comecei este projecto

O Mwanga nasceu de uma pergunta simples: como transformar o registo de receitas e despesas numa visão realmente útil sobre a vida financeira de uma família?

Muitas ferramentas mostram números, mas deixam a interpretação inteiramente com o utilizador. Com este projecto, quis explorar uma experiência mais completa — organizar movimentos financeiros, acompanhar objectivos e apresentar sinais que ajudem a perceber hábitos, riscos e progresso ao longo do tempo.

Também tem sido o meu laboratório pessoal para aprender como se constrói um produto digital de ponta a ponta: da interface e experiência do utilizador à API, autenticação, base de dados e funcionamento offline.

## O que estou a construir

A proposta do Mwanga combina:

- registo e categorização de receitas e despesas;
- orçamentos, metas de poupança e acompanhamento patrimonial;
- painéis e visualizações para compreender tendências;
- uma pontuação financeira dinâmica;
- a **Binth**, uma assistente concebida para transformar dados em explicações e sugestões;
- uma experiência PWA, preparada para utilização em dispositivos móveis e cenários com conectividade irregular.

O projecto inclui ainda uma arquitectura para diferentes planos de utilização. Isto obrigou-me a pensar não apenas numa aplicação que funciona, mas num produto que pode evoluir de forma sustentável.

## Decisões técnicas

No frontend, React e Vite suportam uma interface modular, responsiva e rica em visualizações. A aplicação usa armazenamento local para parte da experiência offline e Capacitor como ponte para Android e iOS.

No backend, uma API em Node.js e Express trata autenticação, regras de negócio e persistência. A arquitectura contempla SQLite para ambientes mais simples e PostgreSQL para uma evolução com maior escala.

O projecto também me levou a trabalhar com temas que não aparecem num protótipo básico: controlo de acesso, validação, limites de requisições, notificações, documentação de API, observabilidade e protecção de dados.

## O que tenho aprendido

O Mwanga ensinou-me que um produto financeiro não é apenas um conjunto de gráficos. É preciso:

- criar uma estrutura de dados coerente antes de produzir indicadores;
- explicar resultados sem dar uma falsa sensação de certeza;
- equilibrar funcionalidades avançadas com uma experiência simples;
- desenhar cuidadosamente a sincronização entre dados locais e remotos;
- tratar privacidade e segurança como decisões de arquitectura;
- validar a utilidade do produto com pessoas reais, não apenas com código.

## Estado e próximos passos

O Mwanga é um produto independente em evolução. As pontuações e sugestões são recursos de apoio à organização pessoal; não substituem aconselhamento financeiro profissional.

Os próximos passos incluem ampliar os testes automatizados, reforçar o modelo de segurança, melhorar acessibilidade e sincronização offline, e testar as principais jornadas com utilizadores antes de aumentar o número de funcionalidades.

[Ver o repositório do Mwanga](https://github.com/Jubilio/mwanga)
