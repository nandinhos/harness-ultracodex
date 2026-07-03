# 11 - Ferramentas Opcionais

O harness possui um core limpo e ferramentas opcionais. O core nao depende dessas ferramentas; o perfil pessoal pode ativa-las explicitamente.

## Ferramentas

| Ferramenta | Uso | Obrigatoria no core |
|---|---|---|
| `context7` | Consultar documentacao oficial atual de bibliotecas, frameworks, SDKs, CLIs e servicos. | Nao |
| `playwright` | Testes E2E, screenshots, traces e verificacao visual. | Nao |
| `hermes` | Delegar tarefas especificas via Hermes Agent CLI. | Nao |
| `agy` | Delegar tarefas especificas via Antigravity CLI. | Nao |
| `codex` | Delegar tarefas simples para modelo mais leve via `codex exec`. | Nao |

## Variaveis

| Variavel | Default | Funcao |
|---|---|---|
| `HARNESS_ENABLE_CONTEXT7` | `1` no perfil pessoal | Habilitar MCP Context7 no runtime pessoal. |
| `HARNESS_ENABLE_PLAYWRIGHT` | `1` no perfil pessoal | Exigir disponibilidade de Playwright para verificacao visual. |
| `HARNESS_ENABLE_DELEGATION` | `1` no perfil pessoal | Habilitar scripts de delegacao. |
| `HARNESS_DELEGATE_PROVIDER` | `codex` | Escolher `codex`, `hermes` ou `agy`. |
| `HARNESS_LIGHT_MODEL` | `gpt-5.4-mini` | Modelo para tarefas simples quando o provider aceitar override. |
| `HARNESS_TIMEOUT` | `300` | Timeout em segundos para comandos delegados. |

## Regras

- Ferramentas MCP (ex.: `context7`) sao declaradas no `config.toml` do runtime (na config base, visivel a `codex mcp list`/`codex doctor`), nao herdadas de config global.
- Capacidades de CLI do host (`playwright`, `hermes`, `agy`, `codex`) sao detectadas via `command -v` pelos scripts; sua ausencia e reportada, nunca assumida silenciosamente.
- Ausencia de ferramenta opcional deve ser reportada, nao ignorada.
- Delegacao precisa ter escopo fechado, arquivos permitidos, criterio de pronto e formato de resposta.
- Playwright e exigido para afirmar que uma mudanca visual foi verificada.
- Context7 e exigido para decisoes dependentes de API ou documentacao mutavel.
