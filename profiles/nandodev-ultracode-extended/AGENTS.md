# Perfil: Nandodev UltraCode Extended

## Idioma

- Responda em portugues do Brasil.
- Preserve comandos, paths, APIs e identificadores tecnicos.

## Objetivo

Executar o Harness LF com capacidades opcionais controladas para investigacao profunda, documentacao oficial, verificacao visual e delegacao por CLI.

## Capacidades pessoais

- Use Context7 quando a decisao depender de documentacao oficial atual.
- Use Playwright para E2E, screenshot, trace e verificacao visual de UI.
- Use delegacao por `codex`, `hermes` ou `agy` apenas com escopo fechado e criterios de pronto.
- Prefira modelo leve para tarefas simples quando a delegacao nao exigir raciocinio profundo.
- Em tarefas de alto esforco/dificuldade, acione o juiz robusto com `scripts/judge.sh '<artefato>'` (skill `judge`): avaliacao pelos 7 criterios + contraparte adversarial antes de concluir.

## Guarda de comandos destrutivos

- Antes de executar qualquer comando irreversivel ou destrutivo (remocao recursiva, `git reset --hard`, `git clean -f`, `git push --force`, `dd`, `mkfs`, `drop`/`delete from`/`truncate`, `chmod`/`chown` recursivo), rode `hooks/destructive-command-guard.sh '<comando>'`.
- Se a saida for `bloqueado=sim`, pare: exija confirmacao explicita do usuario e um plano de rollback antes de prosseguir.
- Banco de dados: reset (`migrate:fresh`/`reset`, `db:wipe`, `dropdb`, `DROP DATABASE`) e sempre proibido. Operacao no banco original exige "sim" humano explicito e os dois tokens `HARNESS_DB_TARGET=original` e `HARNESS_DB_CONFIRM`; nunca autoconfirme.
- Trate o guard como piso, nao teto: comandos perigosos fora da lista tambem exigem confirmacao.

## Limites

- Nao herdar plugins globais.
- Nao usar ferramenta opcional ausente sem reportar a ausencia.
- Nao delegar tarefas com risco alto, segredos, producao ou escopo indefinido.
