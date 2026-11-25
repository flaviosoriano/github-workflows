# Revisão do Pullfrog

Esta etapa é um processo de trabalho. Com `required_approving_review_count: 0`, a revisão do Pullfrog não bloqueia o merge. O ruleset exige apenas PR e resolução das conversas.

## Ativação por repositório

1. Entre no console do Pullfrog com a conta do GitHub e instale o Pullfrog GitHub App, limitando o acesso aos repositórios que devem usá-lo.
2. Crie `.github/workflows/pullfrog.yml` pelo botão do console ou manualmente. O workflow gerado pelo console é o de referência; este repositório não mantém uma cópia.
3. Configure a chave do provedor do modelo: como segredo do Pullfrog no console ou como segredo do GitHub Actions mapeado no bloco `env:` do workflow.
4. Deixe a revisão automática inicial desligada na seção **Reviews** do console. A primeira revisão é pedida por menção, conforme a regra abaixo. Confira o comportamento das revisões incrementais após pushes neste repositório.
5. Copie o [`AGENTS.md` de pesquisa](../templates/research/AGENTS.md) para a raiz do projeto e preencha os fatos do projeto.

O [guia de instalação](https://docs.pullfrog.com/getting-started) e o [guia de revisões](https://docs.pullfrog.com/pr-reviews) descrevem o console, os provedores e as instruções de revisão.

## Quando pedir revisão

Peça a primeira revisão com um comentário no PR que mencione `@pullfrog` e diga o que conferir. Faça isso quando o PR mudar código que altere dados, splits, métricas, busca, treino ou avaliação, ou fizer uma refatoração grande. Mudanças exclusivamente de documentação ou triviais dispensam o pedido.

## A cada PR

1. Abra o PR e, se a mudança for importante, comente `@pullfrog` com os pontos a conferir.
2. Espere a revisão terminar, leia os achados, corrija os problemas relevantes e resolva as conversas. Leve ao usuário os achados que exigem decisão.
3. Depois de um push, confira se começou a revisão incremental dos commits novos. Se ela não começar, peça nova revisão mencionando `@pullfrog` e os pontos a conferir. Uma menção imediata quando a revisão incremental já está ativa pode gerar revisão duplicada.
4. Execute os testes locais relevantes e confira o diff final. Registre comandos e resultados no PR.

O Pullfrog faz revisão estática: não substitui os testes locais nem as execuções com dados, aos quais ele não tem acesso.
