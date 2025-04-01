-- Verifica se a tabela existe antes de tentar remover políticas
DO $$
BEGIN
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'carros') THEN
    -- Drop policies relacionadas à tabela carros
    EXECUTE 'DROP POLICY IF EXISTS "Carros disponíveis são publicamente visíveis" ON public.carros';
    EXECUTE 'DROP POLICY IF EXISTS "Usuários autenticados podem ver todos os carros" ON public.carros';
    EXECUTE 'DROP POLICY IF EXISTS "Usuários podem registrar seus próprios carros" ON public.carros';
    EXECUTE 'DROP POLICY IF EXISTS "Usuários podem atualizar seus próprios carros" ON public.carros';
    EXECUTE 'DROP POLICY IF EXISTS "Usuários podem excluir seus próprios carros" ON public.carros';

    -- Drop trigger e função associada
    EXECUTE 'DROP TRIGGER IF EXISTS set_updated_at_carros ON public.carros';
  END IF;
END;
$$;

-- Estas funções/índices podem ser removidos independentemente da existência da tabela
DROP FUNCTION IF EXISTS public.handle_updated_at_carros();

-- Drop índices (estes comandos já têm IF EXISTS, então são seguros)
DROP INDEX IF EXISTS idx_carros_user_id;
DROP INDEX IF EXISTS idx_carros_disponivel;
DROP INDEX IF EXISTS idx_carros_marca_modelo;
DROP INDEX IF EXISTS idx_carros_preco_diaria;

-- Drop tabela (já tem IF EXISTS, então é seguro)
DROP TABLE IF EXISTS public.carros; 