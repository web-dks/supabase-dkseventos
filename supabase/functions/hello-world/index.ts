// Follow this setup guide to integrate the Deno runtime into your application:
// https://deno.com/manual/runtime/manual/vscode_deno
// Importar CORS compartilhado
import { corsHeaders, handleCorsOptions } from '../_shared/cors.ts';

// Esta função Edge é um exemplo de como criar uma API
// no Supabase utilizando as Edge Functions
// Documentação: https://supabase.com/docs/guides/functions

Deno.serve(async (req) => {
  // Lidar com requisições OPTIONS para CORS
  const corsResponse = handleCorsOptions(req);
  if (corsResponse) return corsResponse;

  try {
    // Dados de exemplo
    const data = {
      message: 'Olá do Supabase Edge Functions!',
      timestamp: new Date().toISOString(),
    };

    // Retornar resposta JSON
    return new Response(
      JSON.stringify(data),
      {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
        },
        status: 200,
      },
    );
  } catch (error) {
    // Lidar com erros
    console.error('Erro:', error.message);
    
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
        },
        status: 500,
      },
    );
  }
}); 