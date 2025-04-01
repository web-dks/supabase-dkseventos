import { createClient } from '@supabase/supabase-js';
import { Database } from '@/types/supabase';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Variáveis de ambiente SUPABASE_URL e SUPABASE_ANON_KEY não definidas');
}

/**
 * Cliente Supabase para uso no navegador (cliente)
 * Usa a chave anon/public com segurança RLS
 */
export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey);

/**
 * Função para criar um cliente Supabase com a service role key
 * ATENÇÃO: Usar apenas em funções de servidor (API Routes, Server Actions, etc.)
 * Esta chave ignora as políticas RLS e tem acesso total ao banco de dados
 */
export const createServiceClient = () => {
  const serviceKey = process.env.SUPABASE_SERVICE_KEY;
  
  if (!serviceKey) {
    throw new Error('Variável de ambiente SUPABASE_SERVICE_KEY não definida');
  }
  
  return createClient<Database>(supabaseUrl, serviceKey);
}; 