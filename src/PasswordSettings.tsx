import { useState } from 'react';

export type ChangePassword = (current: string, next: string) => Promise<void>;

export function PasswordSettings({ changePassword, onSaved }: { changePassword: ChangePassword; onSaved: () => void }) {
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  return <section className="panel"><h2>Cambiar contraseña</h2><form onSubmit={async event => {
    event.preventDefault();
    if (busy) return;
    const form = event.currentTarget;
    const data = new FormData(form);
    const current = String(data.get('current'));
    const next = String(data.get('next'));
    setError('');
    if (next !== String(data.get('confirm'))) { setError('Las contraseñas nuevas no coinciden.'); return; }
    if (current === next) { setError('La nueva contraseña debe ser distinta de la actual.'); return; }
    setBusy(true);
    try { await changePassword(current, next); form.reset(); onSaved(); }
    catch (e) { setError((e as Error).message); }
    finally { setBusy(false); }
  }}><fieldset disabled={busy}>
    <label>Contraseña actual<input name="current" type="password" autoComplete="current-password" required/></label>
    <label>Nueva contraseña<input name="next" type="password" autoComplete="new-password" minLength={8} required/></label>
    <label>Repetir nueva contraseña<input name="confirm" type="password" autoComplete="new-password" minLength={8} required/></label>
    <p className="fine">Al menos 8 caracteres.</p>
    {error && <p className="error" role="alert">{error}</p>}
    <button className="primary">{busy ? 'Guardando…' : 'Guardar contraseña'}</button>
  </fieldset></form></section>;
}
