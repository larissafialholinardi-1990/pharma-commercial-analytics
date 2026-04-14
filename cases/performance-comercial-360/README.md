# 📊 Performance Comercial 360°

Case desenvolvido para processo seletivo na indústria farmacêutica, simulando dados de sell-in B2B entre distribuidores e farmácias.

> ⚠️ Todos os dados são fictícios ou anonimizados. Nomes de clientes e produtos foram substituídos por identificadores genéricos.

---

## 🎯 Objetivo

Construir uma solução analítica completa de performance comercial, cobrindo faturamento, margem, descontos, prazos e precificação — com foco em insights acionáveis para a força de vendas.

---

## 📑 Páginas do Dashboard

| Página | Descrição |
|---|---|
| Resumo Executivo | KPIs gerais: faturamento líquido, margem, desconto, ticket médio, devolução |
| Visão por Produtos | Rentabilidade, evolução mensal, top/bottom performers |
| Detalhe do Produto | Drill-down por produto: mix de clientes, índice de saúde, margem ao longo do tempo |
| Performance por Cliente | Faturamento, churn, rentabilidade e ranking de crescimento |
| Análise de Descontos | Correlação desconto x rentabilidade, evolução mensal, matriz cliente x produto |
| Visão de Prazos | Prazo médio por cliente/produto, impacto financeiro, clientes fora da política |
| Dinâmica de Preço | Elasticidade volume x preço, variação vs ano anterior, preço médio por produto |

---

## 🔑 Destaques Técnicos

- Waterfall **Bruto → Líquido** (Devolução, Impostos, Abatimentos)
- Scatter **Desconto x Rentabilidade** e **Prazo x Rentabilidade** por cliente
- **Índice de Saúde do Produto** com gauge dinâmico baseado em giro contínuo
- **Elasticidade Volume x Preço** calculada via DAX
- Navegação entre páginas com botões customizados
- Design consistente com identidade visual do cliente

---

## 🛠️ Stack

| Camada | Tecnologia |
|---|---|
| BI Tool | Power BI Desktop |
| Linguagem | DAX |
| Dados | Simulados / Anonimizados |

---

## 🖼️ Screenshots

![Resumo Executivo](screenshots/01_resumo_executivo.png)
![Visão por Produtos](screenshots/02_produtos.png)
![Detalhe do Produto](screenshots/03_detalhe_produto.png)
![Performance por Cliente](screenshots/04_clientes.png)
![Análise de Descontos](screenshots/05_descontos.png)
![Visão de Prazos](screenshots/06_prazos.png)
![Dinâmica de Preço](screenshots/07_preco.png)
