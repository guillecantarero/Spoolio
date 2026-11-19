import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import { PGlite } from '@electric-sql/pglite';
const db=new PGlite();
const sql=await fs.readFile('supabase/catalog/01-reemplazar-pruebas-catalogo.sql','utf8');
const input=JSON.parse(await fs.readFile('supabase/catalog/catalogo-verificado.json','utf8'));
const inv='10000000-0000-0000-0000-000000000001', user='20000000-0000-0000-0000-000000000001',place='30000000-0000-0000-0000-000000000001',filament='40000000-0000-0000-0000-000000000001';
try {
 await db.exec(`create role anon; create role authenticated; create schema auth; create table auth.users(id uuid primary key);
 create function auth.uid() returns uuid language sql stable as $$ select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid $$;
 grant usage on schema auth to anon,authenticated; grant execute on function auth.uid() to anon,authenticated;`);
 await db.exec(await fs.readFile('supabase/migrations/202611190001_spoolio.sql','utf8'));
 await db.exec(`insert into auth.users values ('${user}');insert into sp_inventories values ('${inv}','Spoolio');insert into sp_members values ('${inv}','${user}','Prueba');insert into sp_places values ('${inv}','${place}','Prueba','${user}');`);
 await db.query("select set_config('request.jwt.claim.sub',$1,false)",[user]);
 const command=async c=>db.query('select sp_command($1,$2::jsonb,null)',[inv,JSON.stringify(c)]);
 await command({type:'saveFilament',filament:{id:filament,brand:'Demo',material:'PLA',variant:'Basic',name:'Demo',nameEn:'Demo',distribution:'unicolor',colors:[{hex:'#123456',name:''}],translucent:false,sample:false}});
 await command({type:'createSpool',filamentId:filament,locationId:place,mounted:true,amount:'≤100 %',nfcUids:['04AA']});
 // Deliberate bad HEX after DELETE must roll back the original inventory.
 await assert.rejects(db.exec(sql.replace('"#FFFFFF"','"INVALID"')));
 await db.exec('rollback');
 assert.equal((await db.query('select count(*)::int n from sp_spools')).rows[0].n,1);
 assert.equal((await db.query('select count(*)::int n from sp_nfc')).rows[0].n,1);
 await db.exec(sql);
 for(const table of ['sp_spools','sp_nfc','sp_events'])assert.equal((await db.query(`select count(*)::int n from ${table}`)).rows[0].n,0);
 for(const table of ['auth.users','sp_members','sp_places','sp_inventories'])assert.equal((await db.query(`select count(*)::int n from ${table}`)).rows[0].n,1);
 const snapshot=(await db.query('select sp_snapshot($1) state',[inv])).rows[0].state;
 assert.equal(snapshot.filaments.length,input.length);
 for(const r of input){const actual=snapshot.filaments.find(f=>f.id===r.id); assert.equal(actual.name,r.name);assert.equal(actual.nameEn,r.nameEn);assert.equal(actual.distribution,r.distribution);assert.equal(actual.translucent,r.translucent);assert.equal(actual.sample,false);assert.deepEqual(actual.colors.map(c=>c.hex),r.colors);}
 await assert.rejects(db.exec(sql),/ya se ha importado/);await db.exec('rollback');
 assert.equal((await db.query('select count(*)::int n from sp_filaments')).rows[0].n,input.length);
 console.log('OK: importación, colores ordenados, snapshot, preservación de cuentas/ubicaciones, rollback y bloqueo de repetición.');
} finally {await db.close();}
