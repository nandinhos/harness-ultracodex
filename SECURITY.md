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
gerado.

Confirmado na fonte do Codex 0.142.5 (`config/src/loader`): `trusted` HABILITA o
carregamento de config project-local, **hooks** e exec policies do projeto. Um
projeto nao-confiavel tem esses recursos filtrados. Portanto `trusted` e
pre-requisito para qualquer guardrail nativo baseado em hook — nao um afrouxamento
de seguranca, como o review inicial supos.

`approval_policy` e `sandbox_mode` sao chaves independentes de `trust_level`. O
harness agora as define explicitamente (hardening): `approval_policy = "on-request"`
em ambos os perfis; `sandbox_mode = "read-only"` no core limpo e `"workspace-write"`
no perfil pessoal. Em `codex exec` (nao-interativo) a aprovacao e forcada a `never`
(nao ha como perguntar), mas o `sandbox_mode` vale — confirmado: o core roda em
`read-only`. Em modo interativo, `on-request` pede aprovacao ao escalar.

O guard de comando destrutivo agora tem **enforcement nativo** (hook `PreToolUse`,
ver `docs/adr/0004-guard-hook-nativo.md`), alem da camada advisory do `AGENTS.md`. O
hook exige trust (aprovacao unica interativa que persiste, ou
`--dangerously-bypass-hook-trust` em automacao); enquanto nao confiado, vale a camada
advisory.

O runtime contem um symlink `auth.json` para a credencial do Codex do host. A via
git esta protegida (`.runtime/` e `auth.json` sao ignorados), mas NAO empacote o
runtime seguindo symlinks (evite `tar -h`, `cp -rL`, `rsync -L`): isso derreferencia
o symlink e vaza a credencial real.

## Reporte

Se encontrar segredo versionado, remova o arquivo do Git, rotacione a credencial fora do repositório e registre a correcao em um ADR ou incidente se a decisao afetar o harness.
