# Revisão do Codex em cada PR

Esta etapa é um processo de trabalho. O GitHub não usa uma revisão do Codex como substituto de aprovações humanas exigidas pelo ruleset. Com zero aprovações exigidas, a revisão do Codex não bloqueia automaticamente o merge. [Documentação oficial da OpenAI](https://learn.chatgpt.com/docs/third-party/github).

## Ativação por repositório

1. Conecte o repositório ao Codex cloud e habilite **Code review** nas configurações do Codex.
2. Ative **Automatic reviews** para que o Codex examine PRs novos quando forem apresentados para revisão.
3. Copie o [`AGENTS.md` de pesquisa](../templates/research/AGENTS.md) para a raiz do projeto, preencha os fatos do projeto e ajuste as regras de revisão. O Codex lê a seção `## Code Review Rules` aplicável ao código alterado.

O [guia oficial do Codex](https://learn.chatgpt.com/docs/third-party/github) descreve a ativação, a revisão automática, `@codex review` e as regras em `AGENTS.md`.

## A cada PR

1. Abra o PR como pronto para revisão e aguarde a resposta do Codex.
2. Leia os achados, corrija os problemas relevantes e resolva as conversas de revisão.
3. Depois de um novo push que altere o diff, comente `@codex review` no PR. Aguarde a nova resposta antes do merge.
4. Execute os testes locais relevantes e confira o diff final. Registre comandos e resultados no PR.

`dismiss_stale_reviews_on_push: true` revoga aprovações anteriores quando o diff muda. Com `required_approving_review_count: 0`, isso não cria a obrigação de uma nova revisão. O passo 3 cobre a revisão do Codex sobre mudanças posteriores.
