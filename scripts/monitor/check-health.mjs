import { pathToFileURL } from 'node:url';

export async function checkHealth(env = process.env, request = fetch) {
  const url = env.SUPABASE_URL?.trim();
  const key = env.SUPABASE_PUBLISHABLE_KEY?.trim();
  if (!url || !/^https:\/\/[a-z0-9-]+\.supabase\.co\/?$/i.test(url) || !key) throw new Error('Configura SUPABASE_URL y SUPABASE_PUBLISHABLE_KEY.');
  if (!key.startsWith('sb_publishable_') && !key.startsWith('eyJ')) throw new Error('Usa la clave pública publishable o anon.');
  if (key.startsWith('eyJ')) {
    try { if (JSON.parse(Buffer.from(key.split('.')[1], 'base64url').toString()).role !== 'anon') throw new Error(); }
    catch { throw new Error('No se admiten claves privilegiadas.'); }
  }
  const response = await request(`${url.replace(/\/$/,'')}/rest/v1/sp_health?select=status&id=eq.1&limit=1`, {
    headers: { apikey: key, ...(key.startsWith('eyJ') ? { Authorization: `Bearer ${key}` } : {}) },
    signal: AbortSignal.timeout(15000), redirect: 'error',
  });
  if (!response.ok) throw new Error(`Comprobación fallida (HTTP ${response.status}).`);
  const data = await response.json();
  if (!Array.isArray(data) || data.length !== 1 || data[0].status !== 'ok') throw new Error('Respuesta de estado inesperada.');
  return true;
}
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  checkHealth().then(() => console.log(`${new Date().toISOString()} Supabase OK`)).catch(error => { console.error(`${new Date().toISOString()} ${error.message}`); process.exitCode = 1; });
}
