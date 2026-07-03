---
name: agent-orchestration
description: Use when delegating bounded subtasks to another agent or lighter model through Codex CLI, Hermes CLI, Antigravity CLI, or a local orchestration script to save tokens without losing control of scope and evidence.
---

# Agent Orchestration

## Regra central

Delegar somente tarefas pequenas, independentes e com escopo fechado.

## Pode delegar

- busca localizada;
- resumo de arquivos;
- primeira passada de auditoria;
- geracao de lista;
- verificacao mecanica;
- tarefas simples para modelo leve.

## Nao delegar

- decisao irreversivel;
- producao, segredos ou dados sensiveis;
- mudanca com blast radius alto;
- tarefa sem criterio de pronto;
- edicao concorrente nos mesmos arquivos.

## Brief minimo

Inclua objetivo, arquivos permitidos, proibicoes, criterio de pronto, formato de resposta e nivel de evidencia esperado.
