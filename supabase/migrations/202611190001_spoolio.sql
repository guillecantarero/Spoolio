begin;
-- Spoolio: all writes go through transactional RPCs. No public signup grants membership.
create table public.sp_inventories (id uuid primary key default gen_random_uuid(), name text not null);
create table public.sp_members (
  "inventoryId" uuid not null references public.sp_inventories(id),
  id uuid not null references auth.users(id), name text not null check(length(trim(name)) between 1 and 80),
  primary key ("inventoryId",id)
);
create table public.sp_places (
  "inventoryId" uuid not null references public.sp_inventories(id), id uuid not null default gen_random_uuid(),
  name text not null, "userId" uuid, primary key ("inventoryId",id), unique ("inventoryId","userId"),
  foreign key ("inventoryId","userId") references public.sp_members("inventoryId",id)
);
create table public.sp_filaments (
  "inventoryId" uuid not null references public.sp_inventories(id), id uuid not null,
  brand text not null check(length(trim(brand)) between 1 and 100), material text not null check(length(trim(material)) between 1 and 100),
  variant text not null default '' check(length(variant)<=100), name text not null check(length(trim(name)) between 1 and 120),
  "nameEn" text not null default '' check(length("nameEn")<=120),
  distribution text not null check(distribution in ('unicolor','gradiente','multicolor')),
  translucent boolean not null default false, sample boolean not null default false,
  primary key ("inventoryId",id)
);
create table public.sp_colors (
  "inventoryId" uuid not null, "filamentId" uuid not null, position integer not null check(position>=0),
  hex text not null check(hex ~ '^#[0-9A-F]{6}$'), name text not null default '',
  primary key ("inventoryId","filamentId",position),
  foreign key ("inventoryId","filamentId") references public.sp_filaments("inventoryId",id) on delete cascade
);
create table public.sp_spools (
  "inventoryId" uuid not null references public.sp_inventories(id), id uuid not null default gen_random_uuid(),
  "filamentId" uuid not null, "locationId" uuid not null, mounted boolean not null,
  amount text not null check(amount in ('≤100 %','<75 %','<50 %','<25 %')),
  version integer not null default 1 check(version>0), "createdAt" timestamptz not null default now(),
  "retiredAt" timestamptz, "retiredBy" uuid, reason text check(reason in ('agotada','retirada manual')),
  primary key ("inventoryId",id),
  foreign key ("inventoryId","filamentId") references public.sp_filaments("inventoryId",id),
  foreign key ("inventoryId","locationId") references public.sp_places("inventoryId",id),
  foreign key ("inventoryId","retiredBy") references public.sp_members("inventoryId",id),
  check (("retiredAt" is null and "retiredBy" is null and reason is null) or ("retiredAt" is not null and "retiredBy" is not null and reason is not null))
);
create table public.sp_nfc (
  "inventoryId" uuid not null, uid text not null check(uid ~ '^([0-9A-F]{2}){1,32}$'), "spoolId" uuid not null,
  primary key ("inventoryId",uid),
  foreign key ("inventoryId","spoolId") references public.sp_spools("inventoryId",id)
);
create table public.sp_events (
  "inventoryId" uuid not null, id uuid not null default gen_random_uuid(), "spoolId" uuid not null,
  "actorId" uuid not null, at timestamptz not null default now(),
  type text not null check(type in ('alta','traslado','edición','retirada')), "from" uuid, "to" uuid, detail text,
  primary key ("inventoryId",id),
  foreign key ("inventoryId","spoolId") references public.sp_spools("inventoryId",id),
  foreign key ("inventoryId","actorId") references public.sp_members("inventoryId",id),
  foreign key ("inventoryId","from") references public.sp_places("inventoryId",id),
  foreign key ("inventoryId","to") references public.sp_places("inventoryId",id)
);
create function public.sp_is_member(p_inventory uuid) returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.sp_members where "inventoryId"=p_inventory and id=auth.uid());
$$;
revoke all on function public.sp_is_member(uuid) from public, anon;
grant execute on function public.sp_is_member(uuid) to authenticated;
do $$ declare t text; begin
 foreach t in array array['sp_inventories','sp_members','sp_places','sp_filaments','sp_colors','sp_spools','sp_nfc','sp_events'] loop
  execute format('alter table public.%I enable row level security',t);
  execute format('revoke all on public.%I from anon, authenticated',t);
  execute format('grant select on public.%I to authenticated',t);
  execute format('create policy member_read on public.%I for select to authenticated using (public.sp_is_member(%I))',t,case when t='sp_inventories' then 'id' else 'inventoryId' end);
 end loop;
end $$;
create function public.sp_snapshot(p_inventory uuid) returns jsonb language plpgsql stable security definer set search_path='' as $$
begin
 if not public.sp_is_member(p_inventory) then raise exception 'No tienes acceso a este inventario.' using errcode='42501'; end if;
 return jsonb_build_object('schema',1,'visualDemoInitialized',true,'visualDemoAmountsV1',true,
 'users',(select coalesce(jsonb_agg(to_jsonb(x)-'inventoryId' order by name,id),'[]') from public.sp_members x where "inventoryId"=p_inventory),
 'places',(select coalesce(jsonb_agg(jsonb_strip_nulls(to_jsonb(x)-'inventoryId') order by name,id),'[]') from public.sp_places x where "inventoryId"=p_inventory),
 'filaments',(select coalesce(jsonb_agg(to_jsonb(f)-'inventoryId'||jsonb_build_object('colors',
   (select coalesce(jsonb_agg(jsonb_build_object('hex',c.hex,'name',c.name) order by position),'[]') from public.sp_colors c where c."inventoryId"=p_inventory and c."filamentId"=f.id)) order by f.id),'[]') from public.sp_filaments f where "inventoryId"=p_inventory),
 'spools',(select coalesce(jsonb_agg(jsonb_strip_nulls(to_jsonb(s)-'inventoryId')||jsonb_build_object('nfcUids',
   (select coalesce(jsonb_agg(uid order by uid),'[]') from public.sp_nfc n where n."inventoryId"=p_inventory and n."spoolId"=s.id)) order by s."createdAt",s.id),'[]') from public.sp_spools s where "inventoryId"=p_inventory),
 'events',(select coalesce(jsonb_agg(jsonb_strip_nulls(to_jsonb(e)-'inventoryId') order by at,id),'[]') from public.sp_events e where "inventoryId"=p_inventory));
end $$;
revoke all on function public.sp_snapshot(uuid) from public, anon;
grant execute on function public.sp_snapshot(uuid) to authenticated;

create function public.sp_command(p_inventory uuid,p_command jsonb,p_expected jsonb default null) returns jsonb
language plpgsql security definer set search_path='' as $$
declare
 actor uuid:=auth.uid(); kind text:=p_command->>'type'; f jsonb; color jsonb; i integer:=0;
 sid uuid; fid uuid; loc uuid; tag text; old public.sp_spools%rowtype; current_profile jsonb;
 fmt boolean; qty text;
begin
 if not public.sp_is_member(p_inventory) then raise exception 'No tienes acceso a este inventario.' using errcode='42501'; end if;
 -- Serialize small-inventory writes, including UID claims and catalog edits.
 perform 1 from public.sp_inventories where id=p_inventory for update;
 if kind='saveFilament' then
  f:=p_command->'filament'; fid:=(f->>'id')::uuid;
  select value into current_profile from jsonb_array_elements(public.sp_snapshot(p_inventory)->'filaments') where value->>'id'=fid::text;
  if current_profile is distinct from p_expected then raise exception 'El filamento ha cambiado. Recarga antes de editar.' using errcode='40001'; end if;
  if jsonb_typeof(f->'colors') is distinct from 'array' or jsonb_array_length(f->'colors')<1 then raise exception 'Añade al menos un color.'; end if;
  if f->>'distribution'='unicolor' and jsonb_array_length(f->'colors')<>1 then raise exception 'Un perfil sólido necesita un color.'; end if;
  insert into public.sp_filaments("inventoryId",id,brand,material,variant,name,"nameEn",distribution,translucent,sample)
   values(p_inventory,fid,trim(f->>'brand'),trim(f->>'material'),trim(coalesce(f->>'variant','')),trim(f->>'name'),trim(coalesce(f->>'nameEn','')),f->>'distribution',(f->>'translucent')::boolean,(f->>'sample')::boolean)
   on conflict ("inventoryId",id) do update set brand=excluded.brand,material=excluded.material,variant=excluded.variant,name=excluded.name,"nameEn"=excluded."nameEn",distribution=excluded.distribution,translucent=excluded.translucent,sample=excluded.sample;
  delete from public.sp_colors where "inventoryId"=p_inventory and "filamentId"=fid;
  for color in select value from jsonb_array_elements(f->'colors') loop
   insert into public.sp_colors values(p_inventory,fid,i,upper(color->>'hex'),trim(coalesce(color->>'name',''))); i:=i+1;
  end loop;
 elsif kind='deleteFilament' then
  fid:=(p_command->>'id')::uuid;
  select value into current_profile from jsonb_array_elements(public.sp_snapshot(p_inventory)->'filaments') where value->>'id'=fid::text;
  if current_profile is distinct from p_expected then raise exception 'El filamento ha cambiado. Recarga antes de eliminar.' using errcode='40001'; end if;
  delete from public.sp_filaments where "inventoryId"=p_inventory and id=fid;
 elsif kind='rename' then
  update public.sp_members set name=trim(p_command->>'name') where "inventoryId"=p_inventory and id=actor;
  update public.sp_places set name=trim(p_command->>'name') where "inventoryId"=p_inventory and "userId"=actor;
 elsif kind='createSpool' then
  insert into public.sp_spools("inventoryId","filamentId","locationId",mounted,amount)
   values(p_inventory,(p_command->>'filamentId')::uuid,(p_command->>'locationId')::uuid,(p_command->>'mounted')::boolean,p_command->>'amount') returning id into sid;
  for tag in select value from jsonb_array_elements_text(coalesce(p_command->'nfcUids','[]')) loop
   tag:=upper(regexp_replace(tag,'[:\s-]','','g'));
   insert into public.sp_nfc values(p_inventory,tag,sid);
  end loop;
  insert into public.sp_events("inventoryId","spoolId","actorId",type,"to") values(p_inventory,sid,actor,'alta',(p_command->>'locationId')::uuid);
 elsif kind in ('updateSpool','retire','linkNfc') then
  sid:=(p_command->>'id')::uuid;
  select * into old from public.sp_spools where "inventoryId"=p_inventory and id=sid;
  if not found then raise exception 'No se encuentra la bobina.'; end if;
  if old."retiredAt" is not null then raise exception 'Esta bobina ya está retirada.'; end if;
  if old.version is distinct from (p_command->>'version')::integer then raise exception 'La bobina ha cambiado. Recarga antes de editar.' using errcode='40001'; end if;
  if kind='linkNfc' then
   tag:=upper(regexp_replace(p_command->>'uid','[:\s-]','','g'));
   insert into public.sp_nfc values(p_inventory,tag,sid);
   insert into public.sp_events("inventoryId","spoolId","actorId",type,detail) values(p_inventory,sid,actor,'edición','Etiqueta NFC asociada: '||tag);
  elsif kind='retire' then
   update public.sp_spools set "retiredAt"=now(),"retiredBy"=actor,reason=p_command->>'reason' where "inventoryId"=p_inventory and id=sid;
   insert into public.sp_events("inventoryId","spoolId","actorId",type,"from",detail) values(p_inventory,sid,actor,'retirada',old."locationId",p_command->>'reason');
  else
   fid:=coalesce((p_command->>'filamentId')::uuid,old."filamentId"); loc:=(p_command->>'locationId')::uuid;
   fmt:=(p_command->>'mounted')::boolean; qty:=p_command->>'amount';
   if fid=old."filamentId" and loc=old."locationId" and fmt=old.mounted and qty=old.amount then return public.sp_snapshot(p_inventory); end if;
   if fid<>old."filamentId" then
    insert into public.sp_events("inventoryId","spoolId","actorId",type,detail)
     values(p_inventory,sid,actor,'edición','Filamento: '||(select name from public.sp_filaments where "inventoryId"=p_inventory and id=old."filamentId")||' → '||(select name from public.sp_filaments where "inventoryId"=p_inventory and id=fid));
   end if;
   if loc<>old."locationId" then
    insert into public.sp_events("inventoryId","spoolId","actorId",type,"from","to") values(p_inventory,sid,actor,'traslado',old."locationId",loc);
   end if;
   if fmt<>old.mounted or qty<>old.amount then
    insert into public.sp_events("inventoryId","spoolId","actorId",type,detail) values(p_inventory,sid,actor,'edición',case when old.mounted then 'Montada' else 'Refill' end||' · '||old.amount||' → '||case when fmt then 'Montada' else 'Refill' end||' · '||qty);
   end if;
   update public.sp_spools set "filamentId"=fid,"locationId"=loc,mounted=fmt,amount=qty where "inventoryId"=p_inventory and id=sid;
  end if;
  update public.sp_spools set version=version+1 where "inventoryId"=p_inventory and id=sid;
 else raise exception 'Operación no permitida.';
 end if;
 return public.sp_snapshot(p_inventory);
end $$;
revoke all on function public.sp_command(uuid,jsonb,jsonb) from public, anon;
grant execute on function public.sp_command(uuid,jsonb,jsonb) to authenticated;

-- Public probe contains no inventory or identity data and cannot modify anything.
create table public.sp_health (id integer primary key check(id=1), status text not null check(status='ok'));
insert into public.sp_health values(1,'ok');
alter table public.sp_health enable row level security;
revoke all on public.sp_health from anon,authenticated;
grant select on public.sp_health to anon,authenticated;
create policy health_read on public.sp_health for select to anon,authenticated using(true);

commit;
