-- Drop policies relacionadas à tabela carros
DROP POLICY IF EXISTS "Carros disponíveis são publicamente visíveis" ON public.carros;
DROP POLICY IF EXISTS "Usuários autenticados podem ver todos os carros" ON public.carros;
DROP POLICY IF EXISTS "Usuários podem registrar seus próprios carros" ON public.carros;
DROP POLICY IF EXISTS "Usuários podem atualizar seus próprios carros" ON public.carros;
DROP POLICY IF EXISTS "Usuários podem excluir seus próprios carros" ON public.carros;

-- Drop trigger e função associada
DROP TRIGGER IF EXISTS set_updated_at_carros ON public.carros;
DROP FUNCTION IF EXISTS public.handle_updated_at_carros();

-- Drop índices
DROP INDEX IF EXISTS idx_carros_user_id;
DROP INDEX IF EXISTS idx_carros_disponivel;
DROP INDEX IF EXISTS idx_carros_marca_modelo;
DROP INDEX IF EXISTS idx_carros_preco_diaria;

-- Drop tabela
DROP TABLE IF EXISTS public.carros; 