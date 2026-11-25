---
name: implement-issue
description: "Implementa issues do GitHub de ponta a ponta: worktree, código com testes, PR e babysit da revisão até o PR ficar pronto para merge."
disable-model-invocation: true
argument-hint: "<issue...> | linha:\"<label>\" [--merge]"
---

# /implement-issue

Argumentos: `$ARGUMENTS`

- `241` → uma issue.
- `91 92 93` → **fila**, executada em sequência: a próxima issue começa só quando o PR da anterior estiver **pronto para merge** (ou mesclado, com `--merge`).
- `linha:"<label>"` → todas as issues abertas com esse label, na ordem das dependências declaradas nelas ("Bloqueado por #X").
- `--merge` → faz o merge de cada PR que ficar pronto. Sem essa opção, nenhum merge acontece.

## Autorização

Invocar esta skill autoriza, para as issues da fila: criar worktree e branch, fazer commits, push, abrir o PR, comentar no PR, responder e resolver threads de revisão e fazer push de correções. O merge exige `--merge` ou um pedido explícito do usuário. Siga o restante do `AGENTS.md` do repositório; ele é a fonte dos comandos de teste e lint, dos critérios de revisão do Pullfrog e das regras de worktree.

Pare e pergunte ao usuário somente quando:

- a issue deixa em aberto uma decisão que altera o comportamento ou o resultado, ou uma remoção de funcionalidade de intenção incerta: apresente alternativas, efeitos e recomendação antes de perguntar;
- um achado de revisão exige uma decisão dele;
- o babysit esgota as rodadas ou um script termina em timeout ou falha.

Em fila, ao parar numa issue, registre o motivo e siga para a próxima que não dependa dela.

## Ciclo por issue

### 1. Preparação

Leia o `AGENTS.md`, a issue (`gh issue view <n> --comments`) e a issue-mãe ou spec que ela citar. Confira `git worktree list` e `gh pr list --search "<n>"`.

Pronto quando: as dependências da issue estão fechadas, nenhum outro worktree ou PR trabalha nela, e você consegue escrever o critério de aceitação em uma frase. Se a issue estiver bloqueada ou em andamento, pule-a.

### 2. Worktree

`git fetch` e `git worktree add -b <tipo>/<n>-<slug> ../<repo>-wt-<slug> origin/main`. Todo o trabalho da issue acontece nesse worktree.

### 3. Implementação

Use `/tdd` nas fronteiras que a issue define. Toda mudança de comportamento tem teste; todo bug corrigido tem teste de regressão que falha sem a correção. Métricas e cálculos numéricos têm caso de referência calculado à mão.

Pronto quando: cada item do critério de aceitação da issue tem código e teste correspondentes.

### 4. Verificação local

Rode os testes e o lint do `AGENTS.md` e guarde comandos e saídas. Execuções experimentais longas (horas) ficam fora do ciclo: implemente, teste em escala de smoke e liste o comando completo no PR.

Pronto quando: a suíte e o lint passam no worktree.

### 5. Publicação

Commits atômicos com `git add <caminhos>`, push e `gh pr create --base main` com `Closes #<n>` no corpo. Escreva o corpo com `/pr` e liste nele apenas as verificações executadas no passo 4.

Se a mudança é **importante** pelos critérios do `AGENTS.md`, anote `SINCE=$(date -u +%Y-%m-%dT%H:%M:%SZ)` e, caso não haja revisão inicial automática, comente `@pullfrog` no PR com 3 ou 4 pontos concretos a conferir (o que pode estar numericamente errado, que contrato pode quebrar, se os testes pegariam o erro). Se não é importante, o babysit dispensa a revisão do Pullfrog.

### 6. Babysit

Repita rodadas até o PR estar **pronto para merge**, no máximo 5 rodadas.

**Esperar.** Localize o diretório desta instalação da skill e substitua `<diretório-da-skill>` pelo caminho absoluto. Quando o ambiente oferecer uma ferramenta de acompanhamento de PR, prefira-a; caso contrário, rode o script em background para o usuário poder conversar:

```
<diretório-da-skill>/scripts/wait-review.sh <pr> "$SINCE" 30
```

| Saída | Significado | Ação |
|---|---|---|
| 0 | revisões terminaram | leia o relatório |
| 3 | nenhuma revisão começou | atualize `SINCE`, comente `@pullfrog` com o que mudou e o que conferir, espere de novo |
| 1 ou outra falha | um run falhou ou não foi possível consultar o GitHub | investigue e pare se não for transitório |
| 2 | timeout | pare e informe |

O script consulta os 30 runs mais recentes do workflow; se houver mais runs no intervalo, verifique os demais no GitHub antes de concluir que nenhuma revisão começou.

**Ler.** `<diretório-da-skill>/scripts/pr-report.sh <pr> "$SINCE"` mostra o estado do merge, os checks, as revisões e os comentários desde `SINCE` e as threads não resolvidas. Se informar que a consulta foi truncada, consulte as páginas restantes antes de decidir se o PR está pronto.

**Avaliar.** O Pullfrog revisa estaticamente e pode errar. Classifique cada achado depois de conferi-lo no código:

- **procede** → corrija com teste, responda na thread com o commit da correção e resolva a thread;
- **não procede** → responda na thread com a evidência (trecho de código, teste, saída) e resolva a thread;
- **decisão do usuário** → deixe a thread aberta e leve o achado ao usuário com as opções.

Sugestões de estilo ou escopo fora da issue viram itens do relatório final, não código neste PR.

**Corrigir.** Rode de novo o passo 4, anote `SINCE`, faça commits atômicos e push. Confira se a revisão incremental do Pullfrog começa; se ela não começar, peça-a com `@pullfrog`. Se o PR entrar em conflito com a `main`, faça merge de `origin/main` na branch, resolva o conflito, rode o passo 4 e faça push. A rodada seguinte revisa o merge.

Resolver threads: `gh api graphql -f query='mutation($id:ID!){resolveReviewThread(input:{threadId:$id}){thread{isResolved}}}' -f id=<thread>`.

**Pronto para merge** quando, no `pr-report.sh`, tudo vale ao mesmo tempo:

- a revisão mais recente do Pullfrog é do commit `head` e não tem achado pendente (dispensado para mudanças não importantes);
- nenhuma thread não resolvida; uma thread que aguarda decisão do usuário impede declarar o PR pronto;
- todos os checks passam;
- `mergeable` é `MERGEABLE`;
- a suíte local passou no commit `head`.

### 7. Fechamento

- Sem `--merge`: informe "PR #N pronto para merge" e siga para a próxima issue.
- Com `--merge`: `gh pr merge <pr> --merge`, `git pull --ff-only` no checkout da `main`, e remova o worktree e a branch seguindo as regras de remoção segura do `AGENTS.md`.

## Relatório final

Uma tabela com uma linha por issue: issue, PR, rodadas de babysit, estado (pronto, mesclado, parado), e o que ficou com o usuário (decisões pendentes, sugestões fora do escopo, comandos de execuções longas).
