# github-workflows

Receitas para proteger a branch principal e organizar a revisão em projetos pessoais de pesquisa. O fluxo foi desenhado para uma pessoa que trabalha com agentes: cada mudança passa por PR, recebe uma revisão do Codex e é testada localmente antes do merge.

## Conteúdo

- [`rulesets/main.json`](rulesets/main.json): PR obrigatório na branch padrão, zero aprovações exigidas, conversas resolvidas, sem force push e sem exclusão.
- [`templates/research/`](templates/research/): modelos de `AGENTS.md` e de descrição de PR.
- [`docs/codex-review.md`](docs/codex-review.md): ativação e rotina de revisão do Codex.

O ruleset não é aplicado automaticamente por estar neste repositório. Cada projeto precisa importar o JSON nas suas configurações. Da mesma forma, a revisão do Codex precisa ser ativada para cada repositório no [Codex](https://learn.chatgpt.com/docs/third-party/github).

## Comece por aqui

1. Confirme que a conta proprietária do repositório privado tem GitHub Pro ativo. O [Student Developer Pack](https://education.github.com/pack) oferece esse plano enquanto o benefício estiver ativo. [Rulesets em repositórios privados exigem Pro, Team ou Enterprise Cloud](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository).
2. Siga o [guia de adoção](docs/adoption.md) para copiar os modelos e importar o ruleset.
3. Ative a revisão automática e siga o [processo de revisão do Codex](docs/codex-review.md).

O perfil mantém `required_approving_review_count: 0`. `dismiss_stale_reviews_on_push: true` invalida aprovações que porventura existam após mudanças no diff, mas não exige que outra pessoa ou o Codex revise o último commit. A revisão do Codex e os testes locais são etapas do processo; o ruleset do GitHub impõe PR e resolução das conversas.

## Testes locais

Cada projeto define seus comandos de teste e lint no próprio `AGENTS.md`. Antes do merge, execute os comandos relevantes na máquina de desenvolvimento e registre resultados e limitações no PR. Este repositório não instala workflows de teste no GitHub.

O repositório é uma biblioteca de receitas. Criar um projeto a partir dele como template copiaria também arquivos que o projeto não precisa; por isso a adoção usa apenas os arquivos necessários.
