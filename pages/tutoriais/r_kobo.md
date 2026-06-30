---
title: "Integração R e KoBoToolbox"
---

# Análise de Dados: R e KoBoToolbox

*(Conteúdo em desenvolvimento)*

Brevemente partilharei aqui scripts em `R` focados no processamento de dados humanitários recolhidos via KoBoToolbox:

1. **Ligação à API do KoBoToolbox:** Como puxar os dados mais recentes de um formulário diretamente para o RStudio sem ter de descarregar ficheiros Excel.
2. **Auditoria de Dados (Data Cleaning):** Scripts para identificar *outliers*, calcular durações de entrevistas, e sinalizar inquéritos suspeitos usando o pacote `High Frequency Checks (HFC)`.
3. **Mapeamento Automático com `sf`:** Como transformar os pontos GPS recolhidos num ficheiro Kobo num mapa estático simples usando `ggplot2` e `sf` logo após a extração dos dados.
