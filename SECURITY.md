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

Separado e nao definido pelo harness: `trust_level` nao configura por si
`approval_policy` nem `sandbox_mode` (sao chaves independentes). O harness nao define
nenhuma das duas, entao valem os defaults do Codex. Observado empiricamente
(`codex exec` neste runtime): `approval: never` e `sandbox: workspace-write` limitado
a `[workdir, /tmp, $TMPDIR]`. Ou seja, o modo exec nao pede aprovacao, mas confina a
escrita ao workspace + tmp (nao ao disco inteiro); o modo interativo pode diferir.
Para uma postura explicita, defina `approval_policy` e `sandbox_mode` no `config.toml`
do perfil (item de hardening).

Enquanto nao houver hook nativo amarrado (ver `docs/adr/0003-hooks-operacionais.md`
e a proposta de ADR 0004), o guard de comando destrutivo e aplicado apenas por
instrucao no `AGENTS.md` — cumprimento voluntario do agente, nao enforcement do Codex.

O runtime contem um symlink `auth.json` para a credencial do Codex do host. A via
git esta protegida (`.runtime/` e `auth.json` sao ignorados), mas NAO empacote o
runtime seguindo symlinks (evite `tar -h`, `cp -rL`, `rsync -L`): isso derreferencia
o symlink e vaza a credencial real.

## Reporte

Se encontrar segredo versionado, remova o arquivo do Git, rotacione a credencial fora do repositório e registre a correcao em um ADR ou incidente se a decisao afetar o harness.
