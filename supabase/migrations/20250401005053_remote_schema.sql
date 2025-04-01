create extension if not exists "http" with schema "extensions";

-- Verifica se a tabela profiles existe antes de tentar remover triggers, políticas e constraints
DO $$
BEGIN
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'profiles') THEN
    -- Drop trigger
    EXECUTE 'DROP TRIGGER IF EXISTS "set_updated_at" ON "public"."profiles"';
    
    -- Drop policies
    EXECUTE 'DROP POLICY IF EXISTS "Perfis são publicamente visíveis" ON "public"."profiles"';
    EXECUTE 'DROP POLICY IF EXISTS "Usuários podem atualizar seus próprios perfis" ON "public"."profiles"';
    EXECUTE 'DROP POLICY IF EXISTS "Usuários podem inserir seus próprios perfis" ON "public"."profiles"';
    
    -- Revoke permissions
    EXECUTE 'REVOKE DELETE ON TABLE "public"."profiles" FROM "anon"';
    EXECUTE 'REVOKE INSERT ON TABLE "public"."profiles" FROM "anon"';
    EXECUTE 'REVOKE REFERENCES ON TABLE "public"."profiles" FROM "anon"';
    EXECUTE 'REVOKE SELECT ON TABLE "public"."profiles" FROM "anon"';
    EXECUTE 'REVOKE TRIGGER ON TABLE "public"."profiles" FROM "anon"';
    EXECUTE 'REVOKE TRUNCATE ON TABLE "public"."profiles" FROM "anon"';
    EXECUTE 'REVOKE UPDATE ON TABLE "public"."profiles" FROM "anon"';
    
    EXECUTE 'REVOKE DELETE ON TABLE "public"."profiles" FROM "authenticated"';
    EXECUTE 'REVOKE INSERT ON TABLE "public"."profiles" FROM "authenticated"';
    EXECUTE 'REVOKE REFERENCES ON TABLE "public"."profiles" FROM "authenticated"';
    EXECUTE 'REVOKE SELECT ON TABLE "public"."profiles" FROM "authenticated"';
    EXECUTE 'REVOKE TRIGGER ON TABLE "public"."profiles" FROM "authenticated"';
    EXECUTE 'REVOKE TRUNCATE ON TABLE "public"."profiles" FROM "authenticated"';
    EXECUTE 'REVOKE UPDATE ON TABLE "public"."profiles" FROM "authenticated"';
    
    EXECUTE 'REVOKE DELETE ON TABLE "public"."profiles" FROM "service_role"';
    EXECUTE 'REVOKE INSERT ON TABLE "public"."profiles" FROM "service_role"';
    EXECUTE 'REVOKE REFERENCES ON TABLE "public"."profiles" FROM "service_role"';
    EXECUTE 'REVOKE SELECT ON TABLE "public"."profiles" FROM "service_role"';
    EXECUTE 'REVOKE TRIGGER ON TABLE "public"."profiles" FROM "service_role"';
    EXECUTE 'REVOKE TRUNCATE ON TABLE "public"."profiles" FROM "service_role"';
    EXECUTE 'REVOKE UPDATE ON TABLE "public"."profiles" FROM "service_role"';
    
    -- Drop constraints 
    EXECUTE 'ALTER TABLE "public"."profiles" DROP CONSTRAINT IF EXISTS "profiles_id_fkey"';
    EXECUTE 'ALTER TABLE "public"."profiles" DROP CONSTRAINT IF EXISTS "profiles_username_key"';
    EXECUTE 'ALTER TABLE "public"."profiles" DROP CONSTRAINT IF EXISTS "username_length"';
    EXECUTE 'ALTER TABLE "public"."profiles" DROP CONSTRAINT IF EXISTS "profiles_pkey"';
    
    -- Drop indexes
    EXECUTE 'DROP INDEX IF EXISTS "public"."profiles_pkey"';
    EXECUTE 'DROP INDEX IF EXISTS "public"."profiles_username_key"';
    
    -- Drop table
    EXECUTE 'DROP TABLE "public"."profiles"';
  END IF;
END;
$$;

-- Funções podem ser removidas independentemente da existência da tabela
DROP FUNCTION IF EXISTS "public"."create_profile_on_signup"();
DROP FUNCTION IF EXISTS "public"."handle_updated_at"();


