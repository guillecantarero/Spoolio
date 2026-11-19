-- Ejecutar como administrador desde SQL Editor, después de crear la cuenta inicial en Authentication.
-- PLANTILLA PARA OTRO PROYECTO NUEVO. El proyecto actual ya tiene las tres cuentas.
-- No volver a ejecutar este bootstrap sobre el proyecto actual.
-- Sustituir los correos. No poner contraseñas en este archivo.
-- Crear un solo inventario; si ya existe, reutilizarlo y añadir miembros expresamente.
do $$
declare inv uuid; person record; uid uuid;
begin
 if exists(select 1 from public.sp_inventories) then raise exception 'Ya hay un inventario. No ejecutar de nuevo este alta inicial.'; end if;
 insert into public.sp_inventories(name) values('Spoolio') returning id into inv;
 for person in select * from (values
  ('TU_CORREO_REAL','Guillermo')
 ) as people(email,name) loop
  select id into uid from auth.users where lower(email)=lower(person.email);
  if uid is null then raise exception 'Falta crear una de las cuentas en Authentication. No se ha guardado nada.'; end if;
  insert into public.sp_members values(inv,uid,person.name);
  insert into public.sp_places("inventoryId",name,"userId") values(inv,person.name,uid);
 end loop;
 insert into public.sp_places("inventoryId",name) values(inv,'Fablab');
end $$;
