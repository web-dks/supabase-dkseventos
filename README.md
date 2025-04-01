# Configuração do Supabase Local para o Projeto DK Eventos

## Pré-requisitos

### 1. Instalar Docker Desktop
- Baixe e instale o Docker Desktop do [site oficial](https://www.docker.com/products/docker-desktop/)
- Após a instalação, execute o Docker Desktop
- **Importante**: Certifique-se de que o Docker Desktop esteja rodando antes de tentar iniciar o Supabase

### 2. Configuração de Node.js
- Certifique-se de que o Node.js versão 16 ou superior está instalado
- Você pode verificar sua versão com o comando `node -v`
- Instale as dependências do projeto com `npm install`

## Passos para iniciar o Supabase localmente

1. **Iniciar o Docker Desktop**
   - Abra o aplicativo Docker Desktop e aguarde até que ele esteja em execução (ícone verde)

2. **Iniciar o Supabase**
   - Execute o comando:
   ```bash
   npx supabase start --exclude vector
   ```
   - **Nota**: Excluímos o serviço "vector" para evitar problemas comuns relacionados à conexão de rede no Windows/WSL2
   - Este processo pode levar alguns minutos na primeira vez
   - Caso o comando acima falhe, tente parar qualquer serviço Supabase em execução primeiro:
   ```bash
   npx supabase stop
   ```

3. **Verificar se o Supabase está rodando**
   - Execute o comando:
   ```bash
   npx supabase status
   ```
   - Você verá as URLs e credenciais para acessar os serviços locais

## Serviços disponíveis após a inicialização

Quando o Supabase estiver rodando, você terá acesso aos seguintes serviços:

1. **Supabase Studio**: http://127.0.0.1:54323
   - Interface para gerenciar seu banco de dados, APIs, autenticação e armazenamento

2. **API Supabase**: http://127.0.0.1:54321
   - Endpoint para acessar suas APIs RESTful e GraphQL

3. **Banco de Dados PostgreSQL**: 
   - Host: 127.0.0.1
   - Porta: 54322
   - Usuário: postgres
   - Senha: postgres
   - Database: postgres

4. **Servidor de Email para testes**: http://127.0.0.1:54324
   - Para visualizar emails enviados durante o desenvolvimento

## Configuração da aplicação para usar o Supabase local

Crie um arquivo `.env.local` (se ainda não existir) para configurar as variáveis de ambiente:

```
# Ambiente de desenvolvimento (local)
NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0

# Ambiente de produção (remoto) - descomente quando quiser usar o ambiente remoto
# NEXT_PUBLIC_SUPABASE_URL=https://seu-projeto.supabase.co
# NEXT_PUBLIC_SUPABASE_ANON_KEY=sua_chave_anon_remota
```

## Linkando com o Supabase Remoto

Para conectar seu ambiente local ao seu projeto Supabase hospedado na nuvem, siga estes passos:

### 1. Criar um projeto Supabase na nuvem (se ainda não tiver)

- Acesse [app.supabase.com](https://app.supabase.com)
- Crie uma conta ou faça login
- Clique em "New Project"
- Preencha os detalhes solicitados e crie o projeto

### 2. Obter as credenciais do projeto remoto

- Acesse o painel do seu projeto no Supabase
- Navegue até "Project Settings" > "API"
- Você encontrará duas informações essenciais:
  - **URL do projeto** - ex: `https://abcdefghijklmn.supabase.co`
  - **anon/public key** - a chave que começa com `eyJ...`
  - **service_role key** - necessária para operações administrativas

### 3. Configurar o CLI do Supabase para acesso remoto

Instale o CLI do Supabase globalmente (se ainda não estiver instalado):
```bash
npm install -g @supabase/cli
```

Configure o acesso ao projeto remoto:
```bash
npx supabase login
```
Siga as instruções para autenticar com seu token de acesso do Supabase.

Depois de autenticado, vincule seu projeto local ao remoto:
```bash
npx supabase link --project-ref seu-project-ref
```
Substitua `seu-project-ref` pelo ID do seu projeto (encontrado na URL do dashboard ou nas configurações)

### 4. Sincronizar o esquema do banco de dados

Para puxar o esquema do banco remoto para seu ambiente local:
```bash
npx supabase db pull
```

Para aplicar o esquema local ao banco remoto:
```bash
npx supabase db push
```

### 5. Alternar entre ambientes local e remoto na aplicação

Edite o arquivo `.env.local` para alternar entre os ambientes:

Para ambiente local:
```
NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0

# NEXT_PUBLIC_SUPABASE_URL=https://seu-projeto.supabase.co
# NEXT_PUBLIC_SUPABASE_ANON_KEY=sua_chave_anon_remota
```

Para ambiente remoto:
```
# NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
# NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0

NEXT_PUBLIC_SUPABASE_URL=https://seu-projeto.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=sua_chave_anon_remota
```

### 6. Trabalhando com migrações

Para desenvolvimento colaborativo, é recomendado usar migrações:

1. **Criar uma migração para suas alterações:**
```bash
npx supabase db diff --schema public -f nome_da_migracao
```

2. **Verificar as migrações criadas:**
Elas estarão na pasta `supabase/migrations/`

3. **Aplicar migrações ao ambiente remoto:**
```bash
npx supabase db push
```

### 7. Sincronizando funções Edge

Para sincronizar funções Edge com o ambiente remoto:
```bash
npx supabase functions deploy nome-da-funcao
```

Para implantar todas as funções:
```bash
npx supabase functions deploy
```

## Solução de problemas comuns

### Problema: Erro "Network unreachable"
Se você encontrar erros relacionados a "Network unreachable" ao iniciar o Supabase:
1. Certifique-se de que o Docker Desktop está rodando
2. Use a flag `--exclude vector` como mostrado acima
3. Se o problema persistir, reinicie o Docker Desktop

### Problema: Conflito de containers
Se você encontrar erros de conflito de containers:
1. Pare o Supabase: `npx supabase stop`
2. Verifique se há containers rodando: `docker ps -a`
3. Limpe containers parados: `docker container prune`
4. Tente iniciar novamente o Supabase

### Problema: Portas já em uso
Se algumas portas já estiverem em uso:
1. Verifique quais aplicações estão usando essas portas
2. Encerre essas aplicações ou altere as portas no arquivo `supabase/config.toml`

## Integração com GitHub e Processos de Deploy

### GitHub e Supabase
Importante: Ao enviar alterações para o GitHub, elas **não são automaticamente sincronizadas** com o Supabase remoto. Esses são processos separados:

1. **Push para GitHub**: Envia seu código para o repositório remoto
2. **Sincronização com Supabase**: Requer comandos específicos do CLI do Supabase

### Opções para sincronizar com Supabase remoto:

#### 1. Sincronização manual (recomendado para times pequenos)
Após desenvolver e testar localmente:
```bash
# Aplica alterações ao banco de dados remoto
npx supabase db push

# Deploy de funções edge, se houver
npx supabase functions deploy
```

#### 2. Configurar CI/CD para sincronização automática
Para ambientes de produção, você pode configurar pipelines no GitHub Actions para sincronizar automaticamente:

Exemplo de arquivo workflow `.github/workflows/supabase-deploy.yml`:
```yaml
name: Deploy Supabase Migrations

on:
  push:
    branches: [ main ]
    paths:
      - 'supabase/migrations/**'
      - 'supabase/functions/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '16'
          
      - name: Install Supabase CLI
        run: npm install -g @supabase/cli
        
      - name: Login to Supabase
        run: supabase login --key ${{ secrets.SUPABASE_ACCESS_TOKEN }}
        
      - name: Link to Supabase project
        run: supabase link --project-ref ${{ secrets.SUPABASE_PROJECT_ID }}
        
      - name: Deploy database migrations
        run: supabase db push
        
      - name: Deploy Edge Functions
        run: supabase functions deploy
```

Para configurar este workflow:
1. Crie um token de acesso no Supabase (Project Settings > API)
2. Adicione os seguintes secrets ao repositório GitHub:
   - `SUPABASE_ACCESS_TOKEN`: Seu token de acesso pessoal do Supabase
   - `SUPABASE_PROJECT_ID`: O ID do seu projeto Supabase

### Práticas recomendadas para gerenciamento

1. **Ambiente de staging**: Considere ter um projeto Supabase separado para testes antes do deploy em produção
2. **Backup regular**: Faça backups do banco de dados de produção regularmente
3. **Migrations controladas**: Teste migrações localmente antes de aplicá-las remotamente
4. **Revisão por pares**: Tenha outro desenvolvedor revisando as mudanças antes do deploy

## Trabalhando com bancos de dados locais e remotos

### Sincronizando esquemas
Para extrair o esquema do banco remoto:
```bash
npx supabase db pull
```

Para criar uma migração a partir de alterações locais:
```bash
npx supabase db diff -f nome_da_migracao
```

Para aplicar migrações ao banco remoto:
```bash
npx supabase db push --db-url=SUPABASE_URL
```

## Parando o Supabase

Quando terminar de trabalhar:
```bash
npx supabase stop
```

## Observações

- O Supabase local executa uma instância completa do PostgreSQL e outros serviços Supabase
- Dados criados localmente não são sincronizados automaticamente com o banco remoto
- Use as migrações para manter os ambientes sincronizados
- Feche o Docker Desktop quando não estiver usando o Supabase para liberar recursos do sistema 