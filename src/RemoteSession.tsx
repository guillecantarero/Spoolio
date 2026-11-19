import { useEffect, useState, type ReactNode } from 'react';
import { SupabaseRepository, changeAccountPassword, type Client } from './supabaseRepository';
import type { State } from './domain';

export function RemoteSession({ children, client }: { client: Client; children: (state: State, actor: string, repository: SupabaseRepository, logout: () => Promise<void>, changePassword: (current: string, next: string) => Promise<void>) => ReactNode }) {
  const [actor, setActor] = useState<string | null>(null);
  const [loaded, setLoaded] = useState<{ state: State; repository: SupabaseRepository } | null>(null);
  const [error, setError] = useState('');
  const [busy, setBusy] = useState(false);
  const [ready, setReady] = useState(false);
  const [retry, setRetry] = useState(0);
  useEffect(() => {
    const { data } = client.auth.onAuthStateChange((_event, session) => { setActor(session?.user.id ?? null); setReady(true); });
    return () => data.subscription.unsubscribe();
  }, [client]);
  useEffect(() => {
    let live = true; setLoaded(null); setError('');
    if (!actor) return;
    void (async () => {
      try {
        const { data, error } = await client.from('sp_inventories').select('id').limit(2);
        if (error) throw error;
        if (data.length !== 1) throw new Error('Tu cuenta debe estar asociada a un inventario. Pide al administrador que revise tu acceso.');
        const repository = new SupabaseRepository(client, data[0].id);
        const state = await repository.read();
        if (!state.users.some(u => u.id === actor) || !state.places.some(p => p.userId === actor)) throw new Error('Falta configurar tu usuario o ubicación.');
        if (live) setLoaded({ state, repository });
      } catch (e) { if (live) setError((e as Error).message); }
    })();
    return () => { live = false; };
  }, [actor, client, retry]);
  async function logout() {
    setBusy(true);
    try { const { error } = await client.auth.signOut({ scope: 'local' }); if (error) throw error; setLoaded(null); setActor(null); }
    catch (e) { setError((e as Error).message); throw e; }
    finally { setBusy(false); }
  }
  if (actor && loaded) return children(loaded.state, actor, loaded.repository, logout, (current, next) => changeAccountPassword(client, current, next));
  return <div className="welcome"><div className="welcome-card"><div className="wordmark">◉ spoolio</div><h1>{actor ? 'Conectando al inventario' : 'Iniciar sesión'}</h1>
    {error && <p role="alert" className="error">{error}</p>}
    {!ready ? <p role="status">Comprobando sesión…</p> : actor ? <><button disabled={busy} onClick={() => setRetry(n => n + 1)}>Reintentar conexión</button><button disabled={busy} onClick={() => { void logout().catch(() => {}); }}>Cerrar sesión</button></> :
      <form onSubmit={async e => {
        e.preventDefault(); const form = e.currentTarget; const d = new FormData(form); setBusy(true); setError('');
        try { const { error } = await client.auth.signInWithPassword({ email: String(d.get('email')).trim(), password: String(d.get('password')) }); if (error) throw new Error('No se pudo iniciar sesión. Revisa el correo, la contraseña y la conexión.'); form.reset(); }
        catch (e) { setError((e as Error).message); } finally { setBusy(false); }
      }}><fieldset disabled={busy}><label>Correo<input type="email" name="email" autoComplete="username" required/></label><label>Contraseña<input type="password" name="password" autoComplete="current-password" required/></label><button className="primary">{busy ? 'Entrando…' : 'Entrar'}</button></fieldset></form>}
  </div></div>;
}
