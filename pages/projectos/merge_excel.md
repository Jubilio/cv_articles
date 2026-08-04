---
title: "Excel Merge GUI"
description: "Uma aplicação desktop em Python para combinar ficheiros Excel de forma visual, escolhendo as chaves e o tipo de junção."
---

# Excel Merge GUI

**Tipo:** Aplicação desktop independente  
**Tecnologias:** Python, pandas e Tkinter  
**Repositório:** [github.com/Jubilio/merge_excel](https://github.com/Jubilio/merge_excel)

## Como surgiu

O Excel Merge GUI nasceu de uma necessidade muito simples: combinar ficheiros Excel sem ter de reescrever o mesmo código sempre que mudavam os ficheiros, as colunas de ligação ou o tipo de junção.

Embora o `pandas` já torne um merge relativamente direto para quem programa, essa operação continua menos acessível para alguém que apenas quer escolher dois ficheiros, indicar as colunas em comum e guardar o resultado. Decidi então colocar essa lógica por trás de uma interface gráfica pequena e prática.

## O que a ferramenta faz

A aplicação permite:

- selecionar dois ficheiros `.xlsx` ou `.xls`;
- identificar as colunas que existem nos dois ficheiros;
- escolher uma ou várias chaves de correspondência;
- executar junções `inner`, `left`, `right` ou `outer`;
- concatenar os dados quando não é indicada uma chave;
- escolher o nome e o local do ficheiro final;
- trabalhar com listas extensas de colunas numa janela redimensionável.

A lógica de processamento fica no `pandas`, enquanto o Tkinter fornece uma interface local que não exige um servidor nem o carregamento de dados para a Internet.

## O que aprendi

Este projeto foi pequeno, mas ensinou-me uma lição importante sobre desenvolvimento: uma ferramenta útil não precisa começar como uma plataforma complexa. Muitas vezes, o verdadeiro valor está em retirar etapas repetitivas de uma tarefa comum.

Também me obrigou a pensar em aspetos que não aparecem num simples script:

- validação dos ficheiros selecionados;
- correspondência exata entre nomes de colunas;
- diferença entre os tipos de merge;
- mensagens de erro compreensíveis;
- escolha segura do destino do ficheiro;
- comportamento da interface com tabelas largas.

Foi uma das experiências que reforçou o meu interesse em transformar rotinas de tratamento de dados em ferramentas que outras pessoas possam utilizar sem editar código.

## Próximos passos possíveis

A ferramenta pode evoluir com:

- pré-visualização das primeiras linhas antes do merge;
- relatório de chaves sem correspondência;
- deteção de duplicados nas colunas selecionadas;
- comparação dos tipos das chaves;
- suporte a múltiplos ficheiros;
- empacotamento como executável para Windows;
- registo das operações realizadas.

## Código

O código-fonte e as instruções de utilização estão disponíveis no [repositório Excel Merge GUI](https://github.com/Jubilio/merge_excel).
