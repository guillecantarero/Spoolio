import { PGlite } from '@electric-sql/pglite';
import { readFileSync } from 'node:fs';
import { beforeAll, afterAll, expect, test } from 'vitest';
const db = new PGlite();
const inv='10000000-0000-0000-0000-000000000001';
const user='20000000-0000-0000-0000-000000000001';
const stranger='20000000-0000-0000-0000-000000000002';
const place='30000000-0000-0000-0000-000000000001';
const otherPlace='30000000-0000-0000-0000-000000000002';
const filament={id:'40000000-0000-0000-0000-000000000001',brand:'Prueba',material:'PLA',variant:'Basic',name:'Azul',nameEn:'Blue',distribution:'unicolor',colors:[{hex:'#0085FF',name:''}],translucent:false,sample:false};
async function command(c: object, expected: object|null=null) {
 return (await db.query<{state:any}>('select public.sp_command($1,$2::jsonb,$3::jsonb) as state',[inv,JSON.stringify(c),expected ? JSON.stringify(expected):null])).rows[0].state;
}
beforeAll(async()=>{
 await db.exec(`create role anon; create role authenticated; create schema auth; create table auth.users(id uuid primary key);
 create function auth.uid() returns uuid language sql stable as $$ select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid $$;
 grant usage on schema auth to anon,authenticated; grant execute on function auth.uid() to anon,authenticated;`);
 await db.exec(readFileSync('supabase/migrations/202611190001_spoolio.sql','utf8'));
 await db.query('insert into auth.users values ($1),($2)',[user,stranger]);
 await db.query('insert into sp_inventories values ($1,$2)',[inv,'Spoolio']);
 await db.query('insert into sp_members values ($1,$2,$3)',[inv,user,'Juan']);
 await db.query('insert into sp_places values ($1,$2,$3,$4),($1,$5,$6,null)',[inv,place,'Juan',user,otherPlace,'Fablab']);
 await db.exec('set role authenticated');
 await db.query("select set_config('request.jwt.claim.sub',$1,false)",[user]);
},60000);
afterAll(()=>db.close());
test('permisos, transacciones, UID, versiones e historial en PostgreSQL',async()=>{
 await expect(db.query('insert into sp_inventories(name) values ($1)',['Intruso'])).rejects.toThrow();
 await command({type:'saveFilament',filament});
 const state=await command({type:'createSpool',filamentId:filament.id,locationId:place,mounted:true,amount:'≤100 %',nfcUids:['04:AA']});
 const spool=state.spools[0];
 expect(spool.nfcUids).toEqual(['04AA']);
 expect(state.events[0].actorId).toBe(user);
 await expect(command({type:'createSpool',filamentId:filament.id,locationId:place,mounted:true,amount:'≤100 %',nfcUids:['04AA']})).rejects.toThrow();
 const moved=await command({type:'updateSpool',id:spool.id,version:1,locationId:otherPlace,mounted:false,amount:'<50 %'});
 expect(moved.spools).toHaveLength(1);
 expect(moved.events.filter((e:any)=>e.type==='traslado')).toHaveLength(1);
 expect(moved.spools[0].version).toBe(2);
 await expect(command({type:'updateSpool',id:spool.id,version:1,locationId:place,mounted:true,amount:'≤100 %'})).rejects.toThrow(/ha cambiado/);
 await expect(command({type:'saveFilament',filament:{...filament,name:'Modificado'}})).rejects.toThrow(/ha cambiado/);
 await expect(command({type:'saveFilament',filament:{...filament,colors:[{hex:'INVALID',name:''}] }},filament)).rejects.toThrow();
 const retired=await command({type:'retire',id:spool.id,version:2,reason:'agotada'});
 expect(retired.filaments[0].colors).toEqual(filament.colors);
 expect(retired.spools[0].retiredBy).toBe(user);
 await expect(command({type:'deleteFilament',id:filament.id},filament)).rejects.toThrow();
 await expect(command({type:'createSpool',filamentId:filament.id,locationId:place,mounted:true,amount:'≤100 %',nfcUids:['04AA']})).rejects.toThrow();
 await db.query("select set_config('request.jwt.claim.sub',$1,false)",[stranger]);
 expect((await db.query('select * from sp_spools')).rows).toHaveLength(0);
 await expect(command({type:'rename',name:'Intruso'})).rejects.toThrow(/acceso/);
 await expect(db.query('select sp_snapshot($1)',[inv])).rejects.toThrow(/acceso/);
 await db.exec('set role anon');
 expect((await db.query('select * from sp_health')).rows).toEqual([{id:1,status:'ok'}]);
 await expect(db.query('select * from sp_members')).rejects.toThrow();
 await expect(db.query("update sp_health set status='ok'")).rejects.toThrow();
},30000);

test('un miembro no puede relacionar bobinas con otro inventario',async()=>{
 await db.exec('reset role');
 const inv2='10000000-0000-0000-0000-000000000002';
 const place2='30000000-0000-0000-0000-000000000003';
 await db.query('insert into sp_inventories values ($1,$2)',[inv2,'Otro']);
 await db.query('insert into sp_members values ($1,$2,$3)',[inv2,stranger,'Otro usuario']);
 await db.query('insert into sp_places values ($1,$2,$3,$4)',[inv2,place2,'Otro usuario',stranger]);
 await db.exec('set role authenticated');
 await db.query("select set_config('request.jwt.claim.sub',$1,false)",[user]);
 expect((await db.query('select id from sp_inventories')).rows).toEqual([{id:inv}]);
 await expect(command({type:'createSpool',filamentId:filament.id,locationId:place2,mounted:true,amount:'≤100 %'})).rejects.toThrow();
 await expect(db.query('select sp_snapshot($1)',[inv2])).rejects.toThrow(/acceso/);
});
