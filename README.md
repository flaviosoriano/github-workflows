# github-workflows

Receitas para proteger a branch principal e organizar a revisão em projetos pessoais de pesquisa. O fluxo foi desenhado para uma pessoa que trabalha com agentes: cada mudança passa por PR, é testada localmente e, quando importante, recebe uma revisão do Pullfrog antes do merge.

## Conteúdo

- [`rulesets/main.json`](rulesets/main.json): PR obrigatório na branch padrão, zero aprovações exigidas, conversas resolvidas, merge commit como único método, sem force push e sem exclusão.
- [`templates/research/`](templates/research/): modelos de `AGENTS.md` e de descrição de PR.
- [`docs/pullfrog-review.md`](docs/pullfrog-review.md): ativação e rotina de revisão do Pullfrog.
- [`skills/initialize`](skills/initialize/SKILL.md) e [`skills/implement-issue`](skills/implement-issue/SKILL.md): inicialização de projetos e implementação de issues.

O ruleset não é aplicado automaticamente por estar neste repositório. Cada projeto precisa importar o JSON nas suas configurações. Da mesma forma, o Pullfrog precisa ser instalado e configurado em cada repositório pelo [console do Pullfrog](https://docs.pullfrog.com/getting-started).

## Comece por aqui

1. Confirme que a conta proprietária do repositório privado tem GitHub Pro ativo. O [Student Developer Pack](https://education.github.com/pack) oferece esse plano enquanto o benefício estiver ativo. [Rulesets em repositórios privados exigem Pro, Team ou Enterprise Cloud](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository).
2. Siga o [guia de adoção](docs/adoption.md) para copiar os modelos e importar o ruleset.
3. Instale o Pullfrog e siga o [processo de revisão do Pullfrog](docs/pullfrog-review.md).

O perfil mantém `required_approving_review_count: 0`. `dismiss_stale_reviews_on_push: true` invalida aprovações que porventura existam após mudanças no diff, mas não exige que outra pessoa ou o Pullfrog revise o último commit. A revisão do Pullfrog e os testes locais são etapas do processo; o ruleset do GitHub impõe PR e resolução das conversas.

## Testes locais

Cada projeto define seus comandos de teste e lint no próprio `AGENTS.md`. Antes do merge, execute os comandos relevantes na máquina de desenvolvimento e registre resultados e limitações no PR. Este repositório não instala workflows de teste no GitHub. O único workflow do projeto é o do Pullfrog, criado pelo console dele.

O repositório é uma biblioteca de receitas. Criar um projeto a partir dele como template copiaria também arquivos que o projeto não precisa; por isso a adoção usa apenas os arquivos necessários.

## Instalações de skills

A branch padrão deste repositório é a fonte canônica das skills próprias. Depois de atualizar o clone, copie o diretório completo de cada skill desejada de `skills/` para o diretório de skills do agente, preservando scripts e permissões. Se houver instalações em mais de um diretório de descoberta, sincronize cada cópia usada; confira diferenças locais antes de sobrescrevê-las. Reinicie a sessão do agente quando necessário para carregar a versão atualizada. A instalação de uma skill não atualiza automaticamente as demais cópias nem os projetos já inicializados.
