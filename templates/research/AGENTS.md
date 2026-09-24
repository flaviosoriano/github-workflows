# AGENTS.md

Este arquivo reúne as instruções dos agentes para este projeto de pesquisa.

## Contexto do projeto

Preencha antes de usar este modelo:

- Dados e origem: `<descreva>`
- Unidade de separação entre treino e avaliação: `<paciente, usuário, documento, período etc.>`
- Divisão canônica dos dados: `<arquivo ou procedimento>`
- Métrica principal: `<nome e definição>`
- Comandos de teste e lint: `<comandos>`
- Local dos dados, checkpoints e resultados que devem permanecer fora do Git: `<caminhos>`

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

- Use um worktree por tarefa e mantenha o checkout principal da `main` limpo. Consulte `git worktree list` e reutilize o worktree existente ao continuar a mesma tarefa.
- Antes de remover um worktree, confira mudanças locais, commits não mesclados e processos em execução. Inspecione também os arquivos ignorados pelo Git, incluindo datasets, checkpoints e resultados. Identifique quais precisam ser preservados no checkout principal da `main`, confira colisões nos caminhos de destino e transfira-os sem sobrescrever arquivos existentes. Confirme que os artefatos necessários chegaram ao destino antes de remover o worktree; se houver dúvida ou colisão, peça uma decisão. Artefatos ignorados continuam locais; transferi-los não significa adicioná-los ao Git.
- Prepare commits por caminho após conferir o status. Faça commit, push ou abra PR somente com autorização; publicar não autoriza merge. Descreva no PR apenas verificações realmente executadas.

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
