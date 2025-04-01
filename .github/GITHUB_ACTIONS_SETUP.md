# Configurando o GitHub Actions para Supabase

Este documento explica como configurar os segredos (secrets) necessários para que o GitHub Actions funcione corretamente com o Supabase.

## Segredos necessários

Você precisa configurar dois segredos no seu repositório GitHub:

1. `SUPABASE_ACCESS_TOKEN` - Token de acesso pessoal do Supabase
2. `SUPABASE_PROJECT_ID` - ID do seu projeto Supabase

## Obtendo os valores

### Para obter o SUPABASE_ACCESS_TOKEN:

1. Acesse [app.supabase.com](https://app.supabase.com)
2. Faça login na sua conta
3. Vá para "Account" (clique no seu avatar no canto inferior esquerdo)
4. Clique em "Access Tokens" na barra lateral
5. Clique em "Generate new token"
6. Dê um nome ao token (ex: "GitHub Actions")
7. Copie o token gerado (você não poderá vê-lo novamente)

### Para obter o SUPABASE_PROJECT_ID:

1. Acesse [app.supabase.com](https://app.supabase.com)
2. Selecione seu projeto
3. Vá para "Project Settings" (ícone de engrenagem)
4. Na página "General Settings" você verá "Reference ID"
5. Copie este ID (também pode ser encontrado na URL do seu painel, algo como: `https://app.supabase.com/project/{project-id}/settings/general`)

## Adicionando os segredos ao GitHub

1. Acesse seu repositório no GitHub
2. Vá para "Settings" > "Secrets and variables" > "Actions"
3. Clique em "New repository secret"
4. Adicione os dois segredos um por um:
   - Nome: `SUPABASE_ACCESS_TOKEN` - Valor: [cole o token de acesso]
   - Nome: `SUPABASE_PROJECT_ID` - Valor: [cole o ID do projeto]

## Testando o workflow

Depois de configurar os segredos:

1. Faça uma alteração em algum arquivo na pasta `supabase/migrations` ou `supabase/functions`
2. Faça commit e push para a branch `main`
3. Vá para a aba "Actions" no seu repositório para ver o workflow em execução

Ou você pode executar manualmente:

1. Acesse a aba "Actions" no seu repositório
2. Selecione o workflow "Deploy Supabase" na barra lateral
3. Clique em "Run workflow" e selecione a branch `main`

## Solução de problemas

Se o workflow falhar, verifique:

1. Se os segredos estão configurados corretamente
2. Se seu token de acesso tem permissões suficientes
3. Se o ID do projeto está correto
4. Se você está no plano adequado do Supabase (algumas funcionalidades podem ser limitadas no plano gratuito)

Para mais detalhes, consulte a [documentação oficial do Supabase CLI](https://supabase.com/docs/reference/cli/). 