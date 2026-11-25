# Adotar as receitas em um projeto

## 1. Preparar o projeto

Copie [`templates/research/AGENTS.md`](../templates/research/AGENTS.md) para `AGENTS.md` na raiz do projeto e [`templates/research/pull_request_template.md`](../templates/research/pull_request_template.md) para `.github/pull_request_template.md`.

Preencha os fatos reais do projeto no `AGENTS.md`, incluindo os comandos de teste e lint que você executa localmente. Os campos `<descreva>` são apenas marcadores. O modelo de PR pede que você registre os comandos executados, os resultados e as limitações relevantes.

## 2. Proteger a branch principal

Importe [`rulesets/main.json`](../rulesets/main.json) em **Settings → Rules → Rulesets → New ruleset → Import a ruleset**. O alvo `~DEFAULT_BRANCH` acompanha a branch padrão do projeto. Verifique na tela de importação que o ruleset está ativo e que a lista de bypass está vazia. O ruleset aceita apenas merge commit; em **Settings → General → Pull Requests**, ative também **Automatically delete head branches** para que a branch remota da tarefa seja removida no merge. [GitHub Docs](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository).

## 3. Ativar o Pullfrog

Siga o [guia de revisão](pullfrog-review.md) para instalar o Pullfrog, criar o workflow e configurar a chave do provedor. Peça a primeira revisão por menção a `@pullfrog` nos PRs importantes e confira a revisão incremental depois dos pushes.

Se a conta tiver revisão automática do Copilot ou do Codex ativada, desative-a para o projeto. Este fluxo usa apenas o Pullfrog.

O ruleset importado é uma cópia da receita. Alterações futuras neste repositório não atualizam automaticamente os projetos consumidores.
