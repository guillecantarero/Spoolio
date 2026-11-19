import fs from 'node:fs/promises';
const dir='supabase/catalog';
const rows=JSON.parse(await fs.readFile(`${dir}/catalogo-verificado.json`,'utf8'));
const data=rows.map(({id,brand,material,variant,name,nameEn,distribution,translucent,sample,colors})=>({id,brand,material,variant,name,nameEn,distribution,translucent,sample,colors}));
if(new Set(data.map(r=>r.id)).size!==data.length)throw Error('IDs repetidos');
for(const r of data){if(!r.colors.length||r.colors.some(c=>!/^#[0-9A-F]{6}$/.test(c)))throw Error('HEX inválido');if(r.distribution==='unicolor'&&r.colors.length!==1)throw Error('Distribución inválida');}
const sql=`-- Spoolio · catálogo verificado 2026-11-19
-- EJECUTAR UNA SOLA VEZ en Supabase SQL Editor como administrador.
-- BORRA TODO el catálogo, bobinas, UID NFC e historial del único inventario.
-- Autorizado por el usuario: todos los datos actuales son de prueba.
-- CONSERVA cuentas Auth, miembros, ubicaciones, inventario, funciones y políticas.
-- Carga ${data.length} perfiles; NO crea bobinas. Muestras inicialmente pendientes.
-- Fuentes y exclusiones: supabase/catalog/README.md y catalogo-verificado.json.
-- No ejecutar sobre inventarios con datos reales. Ante cualquier error: ROLLBACK;
BEGIN;
CREATE TEMP TABLE spoolio_catalog_import ON COMMIT DROP AS
SELECT * FROM jsonb_to_recordset($catalog$
${JSON.stringify(data,null,2)}
$catalog$::jsonb) AS x(id uuid,brand text,material text,variant text,name text,"nameEn" text,distribution text,translucent boolean,sample boolean,colors jsonb);
DO $$
DECLARE inv uuid;
BEGIN
 IF (SELECT count(*) FROM public.sp_inventories) <> 1 THEN
  RAISE EXCEPTION 'Se esperaba exactamente un inventario. No se ha borrado nada.';
 END IF;
 SELECT id INTO inv FROM public.sp_inventories FOR UPDATE;
 IF EXISTS(SELECT 1 FROM public.sp_filaments f JOIN spoolio_catalog_import x ON f.id=x.id WHERE f."inventoryId"=inv) THEN
  RAISE EXCEPTION 'Este catálogo ya se ha importado total o parcialmente. Se impide repetir el borrado.';
 END IF;
 IF (SELECT count(*) FROM spoolio_catalog_import) <> ${data.length} THEN RAISE EXCEPTION 'Carga incompleta'; END IF;
 DELETE FROM public.sp_events WHERE "inventoryId"=inv;
 DELETE FROM public.sp_nfc WHERE "inventoryId"=inv;
 DELETE FROM public.sp_spools WHERE "inventoryId"=inv;
 DELETE FROM public.sp_colors WHERE "inventoryId"=inv;
 DELETE FROM public.sp_filaments WHERE "inventoryId"=inv;
 INSERT INTO public.sp_filaments("inventoryId",id,brand,material,variant,name,"nameEn",distribution,translucent,sample)
 SELECT inv,id,brand,material,variant,name,"nameEn",distribution,translucent,sample FROM spoolio_catalog_import;
 INSERT INTO public.sp_colors("inventoryId","filamentId",position,hex,name)
 SELECT inv,x.id,(c.ordinality-1)::integer,c.hex,''
 FROM spoolio_catalog_import x CROSS JOIN LATERAL jsonb_array_elements_text(x.colors) WITH ORDINALITY AS c(hex,ordinality);
 IF (SELECT count(*) FROM public.sp_filaments WHERE "inventoryId"=inv) <> ${data.length} THEN RAISE EXCEPTION 'Recuento final incorrecto'; END IF;
END $$;
SELECT brand,material,variant,count(*) AS perfiles FROM public.sp_filaments GROUP BY brand,material,variant ORDER BY brand,material,variant;
COMMIT;
`;
await fs.writeFile(`${dir}/01-reemplazar-pruebas-catalogo.sql`,sql);
console.log(data.length,'perfiles;',data.reduce((n,r)=>n+r.colors.length,0),'colores');
