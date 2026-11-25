# AGENTS.md

Este arquivo reúne as instruções dos agentes para este projeto de pesquisa.

## Contexto do projeto

Preencha antes de usar este modelo:

- Objetivo: `<pergunta de pesquisa e documento da proposta>`
- Dados e origem: `<descreva>`
- Unidade de separação entre treino e avaliação: `<paciente, usuário, documento, período etc.>`
- Divisão canônica dos dados: `<arquivo ou procedimento>`
- Métrica primária única: `<nome, definição e como é reportada, por exemplo por dataset>`
- Comandos de teste e lint: `<comandos>`
- Local dos dados, checkpoints e resultados que devem permanecer fora do Git: `<caminhos>`. Indique também onde gravam os treinos rodados em outro worktree, por exemplo no checkout principal da `main`.

## Trabalho com o usuário

- Responda de forma curta e direta. Relate problemas percebidos fora da tarefa, mas só abra issues ou documentos se o usuário pedir.
- Peça confirmação antes de remover uma funcionalidade cuja intenção não esteja clara.

## Código e testes locais

- Leia o arquivo inteiro antes de editá-lo e consulte os contratos dos chamadores afetados. Reutilize as interfaces existentes antes de criar outra implementação.
- Preserve a correção numérica e os controles experimentais. Deixe falhas de equivalência e limitações de ambiente visíveis; uma alternativa que muda o experimento exige decisão explícita.
- Ao corrigir um bug, adicione um teste de regressão que falhe sem a correção. Teste comportamento observável, não apenas o retorno de mocks.
- Execute os testes e o lint locais relevantes antes de concluir. Registre os comandos, resultados e limitações no PR. Uma nova execução que passa não resolve, por si só, um teste intermitente.
- Atualize no mesmo PR a documentação afetada pela mudança, substituindo instruções que ficaram obsoletas.

## Experimentos e evidência

- Trate smoke tests, depuração e runs exploratórios como provisórios. Não crie hashes, snapshots ou mecanismos de congelamento da configuração para eles.
- Quando um resultado sustentar uma conclusão no PR ou em uma publicação, registre a configuração efetiva em formato legível, o estado do código, dados e divisão, sementes, comando, resultados e limitações. Registre versões e hardware quando afetarem o resultado.
- Se um run exploratório passar a ser usado como evidência, repita-o com esse registro. Use hashes somente quando precisar verificar a integridade de um artefato externo mutável ou quando o protocolo do projeto exigir.
- Para treinos, sweeps, avaliações extensas ou comandos que possam continuar após a sessão atual, use uma sessão `tmux` dedicada à tarefa. Registre o nome da sessão, o comando e o caminho do log; confirme que a execução começou. Acompanhe-a até obter o resultado e o código de saída. Se ainda estiver rodando ao informar o usuário, diga isso claramente e indique como consultar a sessão.

## Worktrees e Git

### Gerenciamento de worktrees

- Use um worktree por tarefa e mantenha o checkout principal da `main` limpo. Consulte `git worktree list` e reutilize o worktree existente ao continuar a mesma tarefa.
- Depois do merge de um PR, remova o worktree e a branch da tarefa, local e remota, sem deixar para uma limpeza posterior. Se o diretório de trabalho atual estiver nesse worktree, volte antes para o checkout principal da `main`. Faça as verificações de segurança descritas abaixo antes de remover e, se alguma falhar ou houver dúvida, peça uma decisão.
- Nunca remova o worktree que contém o diretório de trabalho original da sessão do agente, nem a branch dele, mesmo depois do merge. Deixe-o no lugar e informe o usuário de que ele ficou para ser removido fora da sessão.

### Remoção segura de worktrees

- Antes de remover um worktree, confira mudanças locais, commits não mesclados e processos em execução.
- Inspecione também os arquivos ignorados pelo Git, incluindo datasets, checkpoints e resultados.
- Identifique quais artefatos precisam ser preservados no checkout principal da `main`, confira colisões nos caminhos de destino e transfira-os sem sobrescrever arquivos existentes.
- Confirme que os artefatos necessários chegaram ao destino antes de remover o worktree. Se houver dúvida ou colisão, peça uma decisão.
- Artefatos ignorados continuam locais; transferi-los não significa adicioná-los ao Git.

### Commits atômicos

- Organize as alterações em commits pequenos, atômicos e logicamente independentes. Cada commit deve representar uma única mudança coerente, que possa ser compreendida, revisada e revertida isoladamente.
- Separe alterações de funcionalidades, correções, refatorações, documentação e formatação em commits distintos sempre que forem logicamente independentes. Não fragmente artificialmente mudanças que dependem umas das outras.
- Antes de preparar os commits, revise `git status` e `git diff` e agrupe as modificações por responsabilidade.
- Utilize `git add` com caminhos específicos ou `git add -p` para selecionar apenas as alterações pertencentes a cada commit. Evite `git add .` e `git add -A`.
- Sempre que possível, mantenha o projeto em um estado funcional após cada commit. Inclua os testes diretamente relacionados à mudança no mesmo commit e execute as verificações pertinentes.
- Escreva mensagens de commit curtas e descritivas, seguindo o padrão de mensagens adotado pelo repositório.
- Não inclua alterações não relacionadas, arquivos temporários, datasets, checkpoints, resultados experimentais ou informações sensíveis nos commits.
- A autorização para realizar commits continua obrigatória. Após obtê-la, siga a divisão planejada em commits atômicos e apresente um resumo das alterações incluídas em cada um.

### Commits e Pull Requests

- Faça commit, push ou abra PR somente com autorização; publicar não autoriza merge.
- Invocar `/implement-issue` autoriza as operações de publicação e revisão descritas na skill para as issues indicadas; o merge exige `--merge` ou pedido explícito.
- Descreva no PR apenas verificações realmente executadas.

### Revisão com Pullfrog

- O Pullfrog não revisa PRs automaticamente. Quando um PR ou um commit novo for importante, peça a revisão com um comentário no PR que mencione `@pullfrog` e diga o que conferir.
- Considere importante qualquer mudança de código que altere dados, splits, métricas, busca, treino ou avaliação, além de refatorações grandes. Mudanças exclusivamente de documentação ou triviais dispensam o pedido. `<ajuste a lista às áreas críticas do projeto>`
- Espere a revisão terminar e leia os achados antes do merge. Resolva os problemas identificados ou apresente-os ao usuário quando uma decisão for necessária.
- O Pullfrog faz revisão estática: não substitui os testes locais nem as execuções com dados, aos quais ele não tem acesso.

## Code Review Rules

### Separação dos dados

Ao mudar pré-processamento, seleção de atributos ou ajuste de parâmetros, verifique se somente os dados de treino são usados para ajustar transformações. Aplique transformações já ajustadas aos dados de validação e teste.

### Integridade da avaliação

Ao mudar a divisão dos dados, preserve a unidade de separação definida acima. Mostre explicitamente qualquer exceção e seu efeito na comparação com resultados anteriores.

Ao comparar experimentos, mantenha fixos dados, divisão, sementes, estado inicial e protocolo de avaliação. Declare qualquer diferença e não trate uma execução sem dados, dispositivo ou dependências necessários como evidência de aprovação.

### Métricas

Ao mudar uma métrica, confira mapeamento de rótulos, denominador e agregação. Atualize um caso de referência que permita reproduzir o valor esperado.

### Evidência no PR

Confira se as conclusões do PR correspondem aos testes e resultados apresentados. Separe resultados medidos de diagnósticos locais e explicite o que não foi verificado.
