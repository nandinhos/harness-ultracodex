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

## Nivel de confianca do runtime

Os build scripts gravam `trust_level = "trusted"` para o projeto no `config.toml`
gerado. Isso reduz prompts de aprovacao nativos do Codex para o projeto. Como o
harness nao aplica enforcement de kernel, o substituto operacional e a instrucao
nos `AGENTS.md` de rodar `hooks/destructive-command-guard.sh` antes de comandos
destrutivos (ver `docs/adr/0003-hooks-operacionais.md`).

Decisao em aberto: confirmar no Codex CLI alvo exatamente o que `trusted` desabilita.
Se suprimir a aprovacao de comandos, reavaliar o default ou manter o guard como
substituto explicito. Nao ampliar `trust_level` sem substituto operacional verificado.

## Reporte

Se encontrar segredo versionado, remova o arquivo do Git, rotacione a credencial fora do repositório e registre a correcao em um ADR ou incidente se a decisao afetar o harness.
