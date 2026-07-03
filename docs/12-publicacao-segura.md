# 12 - Publicacao Segura

## Objetivo

Publicar o Harness LF sem vazar dados locais, credenciais, caches, sessoes ou relatorios temporarios.

## Checklist

1. Conferir estado do Git:

   ```bash
   git status -sb --ignored
   ```

2. Confirmar que os ignorados esperados sao apenas `.runtime/` e relatorios em `evals/reports/*.md`.

3. Procurar padroes sensiveis:

   ```bash
   rg -n -i "(api[_-]?key|secret|token|password|auth\.json|OPENAI_API_KEY|sk-|github_pat|ghp_|-----BEGIN)" --glob '!.git/**' --glob '!.runtime/**' --glob '!evals/reports/**'
   ```

4. Rodar validacoes:

   ```bash
   bash scripts/test-harness-contract.sh
   bash scripts/validate-profile.sh
   bash scripts/lint-docs.sh
   bash scripts/run-scenarios.sh
   ```

5. Conferir runtimes isolados:

   ```bash
   bash scripts/build-clean-runtime.sh
   bash scripts/build-personal-runtime.sh
   bash scripts/verify-runtime.sh .runtime/codex-clean --expect-core
   bash scripts/verify-runtime.sh .runtime/codex-nandodev --expect-extended
   ```

## Bloqueadores

Nao publicar se houver:

- segredo real em arquivo rastreado;
- `.runtime/` staged;
- relatorio temporario staged;
- arquivo de credencial staged;
- validador falhando sem explicacao.
