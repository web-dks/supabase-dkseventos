-- Criação da tabela de perfis
CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid REFERENCES auth.users ON DELETE CASCADE NOT NULL PRIMARY KEY,
  updated_at timestamp with time zone,
  username text UNIQUE,
  full_name text,
  avatar_url text,
  website text,
  
  CONSTRAINT username_length CHECK (char_length(username) >= 3)
);

-- Comentários na tabela e colunas para facilitar a documentação
COMMENT ON TABLE public.profiles IS 'Perfis de usuários do sistema.';
COMMENT ON COLUMN public.profiles.id IS 'ID do usuário referenciando auth.users.';
COMMENT ON COLUMN public.profiles.username IS 'Nome de usuário único para o perfil.';
COMMENT ON COLUMN public.profiles.full_name IS 'Nome completo do usuário.';
COMMENT ON COLUMN public.profiles.avatar_url IS 'URL da imagem de avatar do usuário.';
COMMENT ON COLUMN public.profiles.website IS 'Site pessoal do usuário.';

-- Habilitar Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Criar políticas RLS
-- Política para qualquer pessoa visualizar perfis públicos
CREATE POLICY "Perfis são publicamente visíveis"
  ON public.profiles
  FOR SELECT
  TO PUBLIC
  USING (true);

-- Política para permitir que usuários atualizem apenas seus próprios perfis
CREATE POLICY "Usuários podem atualizar seus próprios perfis"
  ON public.profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);
  
-- Política para permitir que usuários criem seus próprios perfis
CREATE POLICY "Usuários podem inserir seus próprios perfis"
  ON public.profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Função para definir o timestamp de atualização automaticamente
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para atualizar o timestamp automaticamente
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

-- Função para criar perfil automaticamente após a criação do usuário
CREATE OR REPLACE FUNCTION public.create_profile_on_signup()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, username, full_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'preferred_username', 
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para criar perfil automaticamente
CREATE TRIGGER create_profile_on_signup
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.create_profile_on_signup(); 