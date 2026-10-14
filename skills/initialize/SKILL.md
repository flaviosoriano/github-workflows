---
name: initialize
description: Inicializa manualmente um repositório de pesquisa com as receitas do github-workflows.
---

# Inicializar um repositório de pesquisa

Use esta skill somente quando o usuário a invocar. Ela prepara um projeto com o `AGENTS.md` e o modelo de PR do repositório `github-workflows`. O ruleset e a revisão do Pullfrog dependem de configuração por repositório no GitHub.

## Fonte e destino

- A fonte das receitas é `flaviosoriano/github-workflows`. Use o clone local `/home/flaviossf/github-workflows` se ele existir e apontar para esse repositório; caso contrário, obtenha uma cópia de leitura do remoto ou peça o caminho ao usuário. Confirme que `templates/research/AGENTS.md`, `templates/research/pull_request_template.md` e `rulesets/main.json` existem antes de usá-los.
- Use o diretório ou repositório indicado pelo usuário. Se ele não indicar um destino e o diretório atual não for claramente o novo projeto, pergunte onde inicializar. Nunca use o próprio `github-workflows` como destino.
- Inspecione o destino, o estado do Git, o remoto, o `AGENTS.md`, o modelo de PR e o `.gitignore` existentes. Preserve conteúdo e mudanças locais. Se o destino ainda não for um repositório Git, inicialize a branch `main`; se já for, preserve sua branch padrão.

## Preparação local

- Copie os dois modelos apenas para caminhos ausentes: `AGENTS.md` na raiz e `.github/pull_request_template.md`. Se já existirem, integre somente as regras relevantes sem sobrescrever instruções do projeto.
- Preencha no `AGENTS.md` apenas fatos verificáveis do projeto. Peça os dados científicos que faltarem ou deixe os marcadores explícitos e reporte-os ao final. Confira se caminhos de dados, checkpoints e resultados locais constam do `.gitignore` antes de executar experimentos; não invente caminhos nem ignore dados rastreados sem decisão do usuário.
- Mantenha zero aprovações obrigatórias e testes apenas locais. Não instale workflow de CI nem copie o JSON do ruleset para o projeto só para documentá-lo. O único workflow do projeto é o do Pullfrog, criado pelo console dele.

## GitHub, quando solicitado

- Criar remoto, fazer commit ou push exige pedido explícito. Antes de criar um repositório GitHub, confirme conta, nome e visibilidade; para este fluxo pessoal, sugira privado. Não altere um remoto existente por suposição.
- Se o usuário pedir a proteção da branch, leia `docs/adoption.md` e confira regras existentes antes de importar `rulesets/main.json`. Aplique o ruleset somente ao repositório identificado, sem bypass e sem duplicar regras conflitantes. Verifique a configuração após a importação; se não conseguir aplicá-la, entregue o caminho manual e marque a etapa como pendente.
- Se o usuário pedir o Pullfrog, leia `docs/pullfrog-review.md` e oriente a instalação do Pullfrog GitHub App limitada ao repositório, a criação de `.github/workflows/pullfrog.yml` pelo console e a configuração da chave do provedor. A revisão automática fica desligada; as revisões são pedidas por menção a `@pullfrog`. Se a conta tiver revisão automática do Copilot ou do Codex ativada, oriente desativá-la no projeto. Não declare o Pullfrog ativo sem confirmação observável, como o workflow presente no repositório e o app instalado.

## Skills de engenharia

- Depois da preparação local e das etapas do GitHub, invoque a skill `setup-matt-pocock-skills` no destino e siga o processo dela, inclusive as confirmações com o usuário. Rodá-la depois do GitHub permite que ela proponha o rastreador de issues a partir do remoto final.
- Ela edita o `AGENTS.md` criado ou integrado acima; não crie um `CLAUDE.md` paralelo. Se a skill não estiver disponível, marque a etapa como pendente.

## Entrega

Informe arquivos criados ou integrados, campos ainda por preencher, estado do Git, o resultado do `setup-matt-pocock-skills` e quais etapas do GitHub foram verificadas ou ficaram pendentes. O ruleset e o Pullfrog não passam a valer por copiar modelos.
