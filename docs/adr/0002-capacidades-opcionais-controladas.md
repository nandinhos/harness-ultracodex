# ADR 0002 - Capacidades opcionais controladas

Status: aceito

Data: 2026-07-03

Owner: mantenedor do harness

## Contexto

O harness precisa ser testado limpo, sem plugins globais, mas tambem precisa suportar investigacao com documentacao oficial, verificacao visual e delegacao para agentes externos quando essas capacidades estiverem disponiveis.

## Opcoes consideradas

| Opcao | Vantagem | Custo |
|---|---|---|
| Core totalmente isolado | Teste sem interferencia | Nao cobre debugging completo. |
| Core com todas as ferramentas | Mais poderoso por padrao | Acopla todos os usuarios ao ambiente pessoal. |
| Core limpo + perfil pessoal estendido | Isolamento e poder controlado | Exige dois runtimes e validacao extra. |

## Decisao

Manter um perfil core limpo e criar um perfil pessoal estendido que habilita Context7, Playwright e delegacao por CLI de forma explicita e opcional.

## Consequencias

- Outros usuarios podem usar o core sem instalar ferramentas pessoais.
- O ambiente pessoal pode usar `context7`, `playwright`, `hermes`, `agy` e `codex` sem contaminar o teste limpo.
- A validacao precisa confirmar ausencia de plugins globais no core e presenca controlada das capacidades no perfil pessoal.

## Gatilho para revisitar

Revisitar se o runtime pessoal comecar a depender de configuracoes globais nao declaradas, ou se usuarios externos precisarem das mesmas capacidades como parte do core.
