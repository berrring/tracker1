begin;

create schema if not exists safetrack_private;
revoke all on schema safetrack_private from public, anon, authenticated;
grant usage on schema safetrack_private to authenticated;

do $$
begin
  if to_regprocedure('public.rls_auto_enable()') is not null then
    revoke execute on function public.rls_auto_enable() from public, anon, authenticated;
  end if;
end $$;

create table public.profiles (
  id uuid primary key references auth.users on delete cascade,
  display_name text not null check (char_length(btrim(display_name)) between 1 and 80),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.profiles enable row level security;
revoke all on public.profiles from public, anon, authenticated;
grant select on public.profiles to authenticated;

create table public.families (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(btrim(name)) between 1 and 80),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.families enable row level security;
revoke all on public.families from public, anon, authenticated;
grant select on public.families to authenticated;

create table public.family_memberships (
  family_id uuid references public.families on delete cascade,
  user_id uuid references auth.users on delete cascade,
  role text not null check (role in ('owner', 'member')),
  revoked_at timestamptz,
  primary key (family_id, user_id),
  check (role != 'owner' or revoked_at is null),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.family_memberships enable row level security;
revoke all on public.family_memberships from public, anon, authenticated;
grant select on public.family_memberships to authenticated;

create table public.family_invitations (
  id uuid primary key default gen_random_uuid(),
  family_id uuid not null references public.families on delete cascade,
  invited_by uuid references auth.users on delete set null,
  family_name text not null,
  email text not null check (char_length(email) <= 254 and email = lower(btrim(email)) and email ~ '^[^[:space:]@]+@[^[:space:]@]+[.][^[:space:]@]+$'),
  state text not null default 'pending' check (state in ('pending','accepted','declined','cancelled')),
  expires_at timestamptz not null default (now() + interval '7 days'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.family_invitations enable row level security;
revoke all on public.family_invitations from public, anon, authenticated;
grant select on public.family_invitations to authenticated;

create table public.devices (
  id uuid primary key default gen_random_uuid(),
  family_id uuid not null references public.families on delete cascade,
  label text not null check (char_length(btrim(label)) between 1 and 80),
  revoked_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.devices enable row level security;
revoke all on public.devices from public, anon, authenticated;
grant select on public.devices to authenticated;

create table public.device_pairing_requests (
  id uuid primary key default gen_random_uuid(),
  device_id uuid not null references public.devices on delete cascade,
  requested_by uuid references auth.users on delete set null,
  state text not null default 'pending' check (state in ('pending','approved','rejected','expired')),
  expires_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.device_pairing_requests enable row level security;
revoke all on public.device_pairing_requests from public, anon, authenticated;
grant select on public.device_pairing_requests to authenticated;

create table public.device_status (
  device_id uuid primary key references public.devices on delete cascade,
  battery_percent integer check (battery_percent between 0 and 100),
  connectivity text not null check (connectivity in ('online','offline','unknown')),
  firmware_version text,
  observed_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.device_status enable row level security;
revoke all on public.device_status from public, anon, authenticated;
grant select on public.device_status to authenticated;

create table public.security_events (
  id uuid primary key default gen_random_uuid(),
  family_id uuid not null references public.families on delete cascade,
  actor_id uuid references auth.users on delete set null,
  event_type text not null check (event_type in ('family_created','member_invited','invite_accepted','invite_declined','member_revoked','device_revoked')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.security_events enable row level security;
revoke all on public.security_events from public, anon, authenticated;
grant select on public.security_events to authenticated;

create unique index one_family_owner on public.family_memberships (family_id) where role = 'owner';
create index memberships_by_user on public.family_memberships (user_id, family_id) where revoked_at is null;
create unique index pending_invitation_by_email on public.family_invitations (family_id, email) where state = 'pending';
create index invitations_by_email on public.family_invitations (email, expires_at);
create index invitations_by_family on public.family_invitations (family_id);
create index devices_by_family on public.devices (family_id);
create index pairing_by_device on public.device_pairing_requests (device_id);
create index events_by_family on public.security_events (family_id, created_at desc);

create function safetrack_private.touch() returns trigger
language plpgsql set search_path = '' as $$
begin
  new.updated_at := now();
  return new;
end $$;

create trigger touch_updated_at before update on public.profiles
  for each row execute function safetrack_private.touch();
create trigger touch_updated_at before update on public.families
  for each row execute function safetrack_private.touch();
create trigger touch_updated_at before update on public.family_memberships
  for each row execute function safetrack_private.touch();
create trigger touch_updated_at before update on public.family_invitations
  for each row execute function safetrack_private.touch();
create trigger touch_updated_at before update on public.devices
  for each row execute function safetrack_private.touch();
create trigger touch_updated_at before update on public.device_pairing_requests
  for each row execute function safetrack_private.touch();
create trigger touch_updated_at before update on public.device_status
  for each row execute function safetrack_private.touch();
create trigger touch_updated_at before update on public.security_events
  for each row execute function safetrack_private.touch();

create function safetrack_private.verified_email() returns text
language sql stable security definer set search_path = '' as $$
  select lower(email) from auth.users where id = (select auth.uid()) and email_confirmed_at is not null
$$;

create function safetrack_private.member(target uuid, owner_only boolean default false) returns boolean
language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from public.family_memberships
    where family_id = target and user_id = (select auth.uid())
      and revoked_at is null and (not owner_only or role = 'owner')
      and (select safetrack_private.verified_email()) is not null
  )
$$;

create policy own_profile on public.profiles for select to authenticated using (id = (select auth.uid()));
grant insert (id, display_name), update (display_name) on public.profiles to authenticated;
create policy create_profile on public.profiles for insert to authenticated with check (
  id = (select auth.uid()) and (select safetrack_private.verified_email()) is not null
);
create policy update_profile on public.profiles for update to authenticated
  using (id = (select auth.uid()))
  with check (id = (select auth.uid()) and (select safetrack_private.verified_email()) is not null);

create policy read_family on public.families for select to authenticated using (safetrack_private.member(id));
create policy read_members on public.family_memberships for select to authenticated using (
  safetrack_private.member(family_id) and revoked_at is null
);
create policy read_invitations on public.family_invitations for select to authenticated using (
  safetrack_private.member(family_id, true) or
  (email = (select safetrack_private.verified_email()) and state = 'pending' and expires_at > now())
);
create policy read_devices on public.devices for select to authenticated using (
  revoked_at is null and safetrack_private.member(family_id)
);
create policy read_pairing on public.device_pairing_requests for select to authenticated using (
  exists (select 1 from public.devices d where d.id = device_id
    and (requested_by = (select auth.uid()) or safetrack_private.member(d.family_id, true)))
);
create policy read_device_status on public.device_status for select to authenticated using (
  exists (select 1 from public.devices d where d.id = device_id)
);
create policy read_security_events on public.security_events for select to authenticated using (
  safetrack_private.member(family_id, true)
);

create function safetrack_private.create_family(family_name text) returns uuid
language plpgsql security definer set search_path = '' as $$
declare created uuid;
begin
  if safetrack_private.verified_email() is null then
    raise exception 'Verified account required' using errcode = '42501';
  end if;
  insert into public.families(name) values (btrim(family_name)) returning id into created;
  insert into public.family_memberships(family_id,user_id,role) values (created,auth.uid(),'owner');
  insert into public.security_events(family_id,actor_id,event_type) values (created,auth.uid(),'family_created');
  return created;
end $$;

create function safetrack_private.invite(target uuid, recipient text) returns uuid
language plpgsql security definer set search_path = '' as $$
declare created uuid;
declare label text;
begin
  if not safetrack_private.member(target,true) then
    raise exception 'Family owner required' using errcode = '42501';
  end if;
  select name into label from public.families where id = target for update;
  recipient := lower(btrim(recipient));
  update public.family_invitations set state = 'cancelled'
    where family_id = target and email = recipient and state = 'pending' and expires_at <= now();
  insert into public.family_invitations(family_id,invited_by,family_name,email)
    values (target,auth.uid(),label,recipient)
    on conflict (family_id,email) where state = 'pending' do nothing returning id into created;
  if created is null then
    select id into created from public.family_invitations
      where family_id = target and email = recipient and state = 'pending';
  else
    insert into public.security_events(family_id,actor_id,event_type) values (target,auth.uid(),'member_invited');
  end if;
  return created;
end $$;

create function safetrack_private.respond(invitation uuid, accept boolean) returns void
language plpgsql security definer set search_path = '' as $$
declare entry public.family_invitations%rowtype;
begin
  select i.* into entry from public.family_invitations i
    where i.id = invitation and i.email = safetrack_private.verified_email();
  if not found then raise exception 'Invitation unavailable' using errcode = '42501'; end if;
  perform 1 from public.families where id = entry.family_id for update;
  update public.family_invitations
    set state = case when accept then 'accepted' else 'declined' end
    where id = entry.id and email = safetrack_private.verified_email()
      and state = 'pending' and expires_at > now();
  if not found then raise exception 'Invitation unavailable' using errcode = '42501'; end if;
  if accept then
    insert into public.family_memberships(family_id,user_id,role) values (entry.family_id,auth.uid(),'member')
    on conflict (family_id,user_id) do update set revoked_at = null where family_memberships.role = 'member';
  end if;
  insert into public.security_events(family_id,actor_id,event_type)
    values (entry.family_id,auth.uid(),case when accept then 'invite_accepted' else 'invite_declined' end);
end $$;

create function safetrack_private.revoke_member(target uuid, member_id uuid) returns void
language plpgsql security definer set search_path = '' as $$
begin
  if not safetrack_private.member(target,true) then
    raise exception 'Family owner required' using errcode = '42501';
  end if;
  perform 1 from public.families where id = target for update;
  update public.family_memberships set revoked_at = now()
    where family_id = target and user_id = member_id and role = 'member' and revoked_at is null;
  if not found then raise exception 'Member unavailable' using errcode = '42501'; end if;
  update public.family_invitations set state = 'cancelled'
    where family_id = target and state = 'pending'
      and email = (select lower(email) from auth.users where id = member_id);
  insert into public.security_events(family_id,actor_id,event_type) values (target,auth.uid(),'member_revoked');
end $$;

create function safetrack_private.revoke_device(target uuid) returns void
language plpgsql security definer set search_path = '' as $$
declare family uuid;
begin
  update public.devices d set revoked_at = now()
    where d.id = target and d.revoked_at is null and safetrack_private.member(d.family_id,true)
    returning family_id into family;
  if not found then raise exception 'Device unavailable' using errcode = '42501'; end if;
  insert into public.security_events(family_id,actor_id,event_type) values (family,auth.uid(),'device_revoked');
end $$;

-- PostgREST exposes public invokers. Elevated implementation stays outside its exposed schemas.
revoke all on all functions in schema safetrack_private from public, anon, authenticated;
grant execute on function safetrack_private.create_family(text) to authenticated;
create function public.st_create_family(family_name text) returns uuid
language sql security invoker set search_path = '' as $$
  select safetrack_private.create_family(family_name)
$$;
revoke all on function public.st_create_family(text) from public, anon, authenticated;
grant execute on function public.st_create_family(text) to authenticated;

grant execute on function safetrack_private.invite(uuid,text) to authenticated;
create function public.st_invite(target uuid, recipient text) returns uuid
language sql security invoker set search_path = '' as $$
  select safetrack_private.invite(target,recipient)
$$;
revoke all on function public.st_invite(uuid,text) from public, anon, authenticated;
grant execute on function public.st_invite(uuid,text) to authenticated;

grant execute on function safetrack_private.respond(uuid,boolean) to authenticated;
create function public.st_respond(invitation uuid, accept boolean) returns void
language sql security invoker set search_path = '' as $$
  select safetrack_private.respond(invitation,accept)
$$;
revoke all on function public.st_respond(uuid,boolean) from public, anon, authenticated;
grant execute on function public.st_respond(uuid,boolean) to authenticated;

grant execute on function safetrack_private.revoke_member(uuid,uuid) to authenticated;
create function public.st_revoke_member(target uuid, member_id uuid) returns void
language sql security invoker set search_path = '' as $$
  select safetrack_private.revoke_member(target,member_id)
$$;
revoke all on function public.st_revoke_member(uuid,uuid) from public, anon, authenticated;
grant execute on function public.st_revoke_member(uuid,uuid) to authenticated;

grant execute on function safetrack_private.revoke_device(uuid) to authenticated;
create function public.st_revoke_device(target uuid) returns void
language sql security invoker set search_path = '' as $$
  select safetrack_private.revoke_device(target)
$$;
revoke all on function public.st_revoke_device(uuid) from public, anon, authenticated;
grant execute on function public.st_revoke_device(uuid) to authenticated;

grant execute on function safetrack_private.verified_email(), safetrack_private.member(uuid,boolean) to authenticated;
commit;
