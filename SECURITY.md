# Segurança

## Dados que nao devem ser commitados

- Tokens, API keys, senhas e credenciais.
- `auth.json`, `.env`, certificados, chaves privadas e bancos locais.
- Conteudo de `.runtime/`.
- Relatorios temporarios gerados em `evals/reports/*.md`.

## Antes de publicar

Rode:

```bash
git status -sb --ignored
rg -n -i "(api[_-]?key|secret|token|password|auth\.json|OPENAI_API_KEY|sk-|github_pat|ghp_|-----BEGIN)" --glob '!.git/**' --glob '!.runtime/**' --glob '!evals/reports/**'
bash scripts/test-harness-contract.sh
bash scripts/validate-profile.sh
bash scripts/lint-docs.sh
bash scripts/run-scenarios.sh
```

Resultados esperados:

- segredos reais ausentes;
- apenas `.runtime/` e relatorios temporarios em ignorados;
- validadores passando.

## Reporte

Se encontrar segredo versionado, remova o arquivo do Git, rotacione a credencial fora do repositório e registre a correcao em um ADR ou incidente se a decisao afetar o harness.
