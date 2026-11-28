\set ON_ERROR_STOP on
begin;
insert into auth.users values
  ('00000000-0000-0000-0000-000000000001','owner@example.invalid',now()),
  ('00000000-0000-0000-0000-000000000002','member@example.invalid',now()),
  ('00000000-0000-0000-0000-000000000003','other@example.invalid',now()),
  ('00000000-0000-0000-0000-000000000004','unverified@example.invalid',null);

do $$
begin
  if (select count(*) from pg_tables where schemaname='public' and rowsecurity) <> 8 then raise exception 'expected eight RLS tables'; end if;
  if has_table_privilege('anon','public.families','select') then raise exception 'anonymous table grant'; end if;
  if has_function_privilege('anon','public.st_create_family(text)','execute') then raise exception 'anonymous RPC grant'; end if;
  if has_function_privilege('authenticated','public.rls_auto_enable()','execute') then raise exception 'advisor grant persists'; end if;
end $$;

set local role authenticated;
set local request.jwt.claim.sub = '00000000-0000-0000-0000-000000000004';
do $$ begin
  perform public.st_create_family('Unverified family');
  raise exception 'unverified creation allowed';
exception when insufficient_privilege then null; end $$;

set local request.jwt.claim.sub = '00000000-0000-0000-0000-000000000001';
select set_config('safetrack.owner_family',public.st_create_family('Fixture Family')::text,true);
select set_config('safetrack.invite_id',public.st_invite(current_setting('safetrack.owner_family')::uuid,'member@example.invalid')::text,true);
select public.st_invite(current_setting('safetrack.owner_family')::uuid,'other@example.invalid');
do $$ begin
  if (select count(*) from public.family_memberships) <> 1 then raise exception 'owner missing'; end if;
  begin
    insert into public.family_memberships values (
      current_setting('safetrack.owner_family')::uuid,auth.uid(),'member',null,now(),now()
    );
    raise exception 'direct membership write accepted';
  exception when insufficient_privilege then null; end;
end $$;

reset role;
insert into public.devices(id,family_id,label)
  values ('00000000-0000-0000-0000-000000000010',current_setting('safetrack.owner_family')::uuid,'Fixture device');
insert into public.device_status(device_id,connectivity,observed_at)
  values ('00000000-0000-0000-0000-000000000010','unknown',now());

set local role authenticated;
set local request.jwt.claim.sub = '00000000-0000-0000-0000-000000000003';
select public.st_create_family('Isolated family');
do $$ begin
  if (select count(*) from public.families) <> 1 or (select count(*) from public.devices) <> 0
    or (select count(*) from public.device_status) <> 0 then raise exception 'cross-family leak'; end if;
  begin
    perform public.st_respond(current_setting('safetrack.invite_id')::uuid,true);
    raise exception 'foreign invite accepted';
  exception when insufficient_privilege then null; end;
  perform public.st_respond((select id from public.family_invitations limit 1),false);
end $$;

set local request.jwt.claim.sub = '00000000-0000-0000-0000-000000000002';
do $$ begin
  if (select count(*) from public.family_invitations) <> 1 then raise exception 'incoming invite missing'; end if;
  perform public.st_respond(current_setting('safetrack.invite_id')::uuid,true);
  if (select count(*) from public.devices) <> 1 then raise exception 'accepted member has no devices'; end if;
  if (select count(*) from public.security_events) <> 0 then raise exception 'audit events exposed to member'; end if;
  begin
    perform public.st_invite(current_setting('safetrack.owner_family')::uuid,'forbidden@example.invalid');
    raise exception 'member can invite';
  exception when insufficient_privilege then null; end;
end $$;

set local request.jwt.claim.sub = '00000000-0000-0000-0000-000000000001';
select public.st_invite(current_setting('safetrack.owner_family')::uuid,'member@example.invalid');
select public.st_revoke_member(current_setting('safetrack.owner_family')::uuid,'00000000-0000-0000-0000-000000000002');
select public.st_revoke_device('00000000-0000-0000-0000-000000000010');
do $$ begin
  if (select count(*) from public.devices) <> 0 or (select count(*) from public.device_status) <> 0
    then raise exception 'revoked device remains readable'; end if;
  if (select count(*) from public.security_events) <> 8 then
    raise exception 'missing security events';
  end if;
end $$;

set local request.jwt.claim.sub = '00000000-0000-0000-0000-000000000002';
do $$ begin
  if (select count(*) from public.families) <> 0
    or (select count(*) from public.family_memberships) <> 0
    or (select count(*) from public.family_invitations) <> 0
    or (select count(*) from public.devices) <> 0
    or (select count(*) from public.device_status) <> 0
    then raise exception 'revoked family access remains'; end if;
end $$;
rollback;
select 'SafeTrack security checks passed' as result;
