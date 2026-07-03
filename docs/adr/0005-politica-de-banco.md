# ADR 0005 - Politica de seguranca de banco de dados

Status: aceito

Data: 2026-07-03

Owner: mantenedor do harness

## Contexto

Operacoes de banco sao uma classe de risco irreversivel propria (reset apaga tudo;
migrations/seeds no banco de producao corrompem dados). O harness precisa de uma
camada dedicada, aplicada pelo mesmo guard/hook nativo (ADR 0004).

## Decisao

Tres regras no `destructive-command-guard.sh`:

- **A — Reset de banco: bloqueio absoluto.** `migrate:fresh`/`reset`/`refresh`,
  `db:wipe`, `db:reset`, `db:drop`, `prisma migrate reset`, `db push --force-reset`,
  `sequelize db:drop`, `manage.py flush`/`reset_db`, `dropdb`, `dropDatabase()`,
  `DROP DATABASE`/`SCHEMA`. Nunca liberado, nem com confirmacao.
- **B — Banco de teste obrigatorio.** Operacoes que mutam banco (migrate/seed/DDL,
  `psql`/`mysql`/`mongosh` com escrita) so passam livremente contra um alvo de teste.
  Deteccao (combinada): `APP_ENV`/`DB_CONNECTION`/`NODE_ENV`/`RAILS_ENV`/`DB_DATABASE`
  contendo `test`, OU o nome/URL no comando contendo `test`, OU o alvo listado em
  `HARNESS_TEST_DB` (allowlist separada por espaco).
- **C — Banco original: ordem explicita + dupla confirmacao.** Operacao de mutacao
  contra alvo NAO-teste e bloqueada, exceto com DOIS tokens de ambiente:
  `HARNESS_DB_TARGET=original` E `HARNESS_DB_CONFIRM` igual a
  `HARNESS_DB_CONFIRM_PHRASE` (default `CONFIRMO-OPERACAO-NO-BANCO-ORIGINAL`).

O `AGENTS.md` obriga: o agente so define esses tokens apos "sim" humano explicito;
nunca autoconfirma.

## Consequencias

- Reset de banco nunca ocorre por acao do agente.
- Trabalho de banco default e no banco de teste; o original exige cerimonia deliberada.
- Cobertura por regex e heuristica (nao cobre todo comando de escrita concebivel);
  postura conservadora (prefere bloquear). Coberto por `scripts/test-destructive-guard.sh`.

## Gatilho para revisitar

- Se surgirem falsos-positivos frequentes em comandos legitimos de teste, refinar a deteccao.
- Se um novo framework/CLI de banco entrar no uso, adicionar seus padroes de reset/mutacao.
