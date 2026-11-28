-- Supabase role and JWT stand-ins for a fresh, isolated PostgreSQL database.
create role anon nologin;
create role authenticated nologin;
create schema auth;
create table auth.users(id uuid primary key,email text,email_confirmed_at timestamptz);
create function auth.uid() returns uuid language sql stable as $$
  select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid
$$;
grant usage on schema auth to anon, authenticated;
create function public.rls_auto_enable() returns int language sql security definer as $$ select 1 $$;
