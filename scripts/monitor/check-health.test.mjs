import { test } from 'node:test';
import assert from 'node:assert/strict';
import { checkHealth } from './check-health.mjs';
const env={SUPABASE_URL:'https://example.supabase.co',SUPABASE_PUBLISHABLE_KEY:'sb_publishable_example'};
test('consulta únicamente salud y valida respuesta',async()=>{
 await checkHealth(env,async(url,options)=>{
  assert.equal(url,'https://example.supabase.co/rest/v1/sp_health?select=status&id=eq.1&limit=1');
  assert.equal(options.headers.apikey,env.SUPABASE_PUBLISHABLE_KEY);
  assert.equal(options.method,undefined);
  return new Response(JSON.stringify([{status:'ok'}]));
 });
});
test('rechaza claves privilegiadas y URL ajena',async()=>{
 await assert.rejects(checkHealth({...env,SUPABASE_PUBLISHABLE_KEY:'sb_secret_example'}));
 await assert.rejects(checkHealth({...env,SUPABASE_URL:'https://other.example'}));
});
test('falla ante respuesta vacía, HTTP fallido y error de red',async()=>{
 await assert.rejects(checkHealth(env,async()=>new Response('[]')));
 await assert.rejects(checkHealth(env,async()=>new Response('',{status:503})));
 await assert.rejects(checkHealth(env,async()=>{throw new Error('Sin red');}));
});
