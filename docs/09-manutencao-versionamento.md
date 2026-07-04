# 09 - Manutencao e Versionamento

## Politica de mudanca

| Mudanca | Exige |
|---|---|
| Novo principio operacional | Documento em `docs/` e ADR. |
| Nova skill | `SKILL.md`, cenario avaliativo e validacao. |
| Novo hook | Documento em `docs/06-hooks-e-automacoes.md` e teste manual/script. |
| Nova regra de risco | Atualizacao da matriz e cenario que falha sem a regra. |
| Mudanca de prioridade | ADR obrigatorio. |
| Nova ferramenta opcional | Documento em `docs/11-ferramentas-opcionais.md`, script de deteccao e cenario avaliativo. |
| Upgrade do Codex CLI | Rodar `scripts/test-native-hook-enforcement.sh` (opt-in) para confirmar que o enforcement nativo nao quebrou (matcher/schema de deny). |

## Versionamento

- Use commits pequenos e coesos.
- Mensagens de commit devem ser em portugues do Brasil.
- ADRs documentam decisoes que mudam comportamento do harness.

## Convencao de commit (DEVORQ)

Formato: `tipo (escopo): descricao` em portugues do Brasil, no imperativo,
primeira linha com no maximo 72 caracteres.

- Tipos: `feat`, `fix`, `refactor`, `docs`, `test`, `style`, `perf`, `chore`.
- Escopo (opcional): area entre parenteses, ex.: `(hooks)`, `(scripts)`, `(evals)`, `(profiles)`, `(security)`, `(config)`, `(docs)`.
- Proibido: emojis e linha `Co-authored-by` / `Co-Authored-By`.

Exemplos:

```
feat (hooks): ativa guardrails de comando destrutivo
fix (scripts): corrige deteccao de force push no guard
docs (evals): separa validacao estrutural de comportamental
```
