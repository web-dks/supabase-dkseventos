#!/bin/bash

# Script para sincronização do Supabase local com o remoto
# Autor: Seu Nome
# Data: $(date +%d/%m/%Y)

# Cores para facilitar a leitura
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Função para exibir uso
usage() {
  echo "Uso: $0 [opção]"
  echo "Opções:"
  echo "  pull       Puxar schema do banco de dados remoto para local"
  echo "  push       Enviar migrações locais para o banco de dados remoto"
  echo "  types      Gerar tipos TypeScript do banco de dados"
  echo "  diff       Criar arquivo de migração com as diferenças"
  echo "  start      Iniciar Supabase local"
  echo "  stop       Parar Supabase local"
  echo "  help       Exibir esta ajuda"
  exit 1
}

# Verificar se o Supabase CLI está instalado
check_supabase() {
  if ! command -v npx supabase &> /dev/null; then
    echo -e "${RED}Erro: Supabase CLI não encontrado. Instale com npm install -g supabase${NC}"
    exit 1
  fi
}

# Verificar se .env.local existe
check_env() {
  if [ ! -f .env.local ]; then
    echo -e "${YELLOW}Aviso: Arquivo .env.local não encontrado. Criando a partir do exemplo...${NC}"
    cp .env.local.example .env.local
    echo -e "${YELLOW}Edite o arquivo .env.local com suas credenciais do Supabase${NC}"
    exit 1
  fi
}

# Iniciar Supabase local
start_supabase() {
  echo -e "${GREEN}Iniciando Supabase local...${NC}"
  npx supabase start
}

# Parar Supabase local
stop_supabase() {
  echo -e "${GREEN}Parando Supabase local...${NC}"
  npx supabase stop
}

# Puxar schema do banco de dados remoto
pull_schema() {
  check_env
  echo -e "${GREEN}Puxando schema do banco de dados remoto...${NC}"
  
  # Perguntar se deve usar a URL do .env
  read -p "Usar URL do banco de dados do arquivo .env.local? (s/n): " use_env
  
  if [ "$use_env" = "s" ] || [ "$use_env" = "S" ]; then
    # Extrair a URL do DB do arquivo .env.local
    DB_URL=$(grep DB_URL .env.local | cut -d '=' -f2)
    
    if [ -z "$DB_URL" ]; then
      echo -e "${RED}Erro: URL do banco de dados não encontrada no arquivo .env.local${NC}"
      echo -e "${YELLOW}Adicione a variável DB_URL ao arquivo .env.local${NC}"
      exit 1
    fi
    
    echo -e "${GREEN}Puxando schema usando URL do arquivo .env.local...${NC}"
    npx supabase db pull --db-url="$DB_URL"
  else
    echo -e "${YELLOW}Informe a URL do banco de dados remoto:${NC}"
    read -p "DB_URL: " db_url
    
    if [ -z "$db_url" ]; then
      echo -e "${RED}Erro: URL do banco de dados não informada${NC}"
      exit 1
    fi
    
    echo -e "${GREEN}Puxando schema usando URL informada...${NC}"
    npx supabase db pull --db-url="$db_url"
  fi
}

# Enviar migrações para o banco de dados remoto
push_migrations() {
  check_env
  echo -e "${GREEN}Enviando migrações para o banco de dados remoto...${NC}"
  
  # Perguntar se deve usar a URL do .env
  read -p "Usar URL do banco de dados do arquivo .env.local? (s/n): " use_env
  
  if [ "$use_env" = "s" ] || [ "$use_env" = "S" ]; then
    # Extrair a URL do DB do arquivo .env.local
    DB_URL=$(grep DB_URL .env.local | cut -d '=' -f2)
    
    if [ -z "$DB_URL" ]; then
      echo -e "${RED}Erro: URL do banco de dados não encontrada no arquivo .env.local${NC}"
      echo -e "${YELLOW}Adicione a variável DB_URL ao arquivo .env.local${NC}"
      exit 1
    fi
    
    echo -e "${GREEN}Enviando migrações usando URL do arquivo .env.local...${NC}"
    npx supabase db push --db-url="$DB_URL"
  else
    echo -e "${YELLOW}Informe a URL do banco de dados remoto:${NC}"
    read -p "DB_URL: " db_url
    
    if [ -z "$db_url" ]; then
      echo -e "${RED}Erro: URL do banco de dados não informada${NC}"
      exit 1
    fi
    
    echo -e "${GREEN}Enviando migrações usando URL informada...${NC}"
    npx supabase db push --db-url="$db_url"
  fi
}

# Criar arquivo de migração com as diferenças
create_diff() {
  echo -e "${GREEN}Criando arquivo de migração com as diferenças...${NC}"
  echo -e "${YELLOW}Informe o nome da migração (sem espaços, use underscores):${NC}"
  read migration_name
  
  if [ -z "$migration_name" ]; then
    echo -e "${RED}Erro: Nome da migração não informado${NC}"
    exit 1
  fi
  
  npx supabase db diff -f "$migration_name"
}

# Gerar tipos TypeScript
generate_types() {
  echo -e "${GREEN}Gerando tipos TypeScript do banco de dados...${NC}"
  
  # Verificar se a pasta exist
  if [ ! -d "src/types" ]; then
    echo -e "${YELLOW}Criando diretório src/types...${NC}"
    mkdir -p src/types
  fi
  
  echo -e "${GREEN}Gerando tipos...${NC}"
  npx supabase gen types typescript --local > src/types/supabase.ts
  
  echo -e "${GREEN}Tipos gerados com sucesso em src/types/supabase.ts${NC}"
}

# Verificar Supabase CLI
check_supabase

# Processar argumentos
if [ $# -eq 0 ]; then
  usage
else
  case "$1" in
    pull)
      pull_schema
      ;;
    push)
      push_migrations
      ;;
    types)
      generate_types
      ;;
    diff)
      create_diff
      ;;
    start)
      start_supabase
      ;;
    stop)
      stop_supabase
      ;;
    help|*)
      usage
      ;;
  esac
fi

echo -e "${GREEN}Operação concluída!${NC}" 