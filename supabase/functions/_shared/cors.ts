/**
 * Configurações de CORS para as Edge Functions do Supabase
 */

export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
};

/**
 * Middleware para lidar com requisições OPTIONS (preflight)
 * @param req Requisição
 * @returns Resposta com headers CORS
 */
export function handleCorsOptions(req: Request) {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }
} 