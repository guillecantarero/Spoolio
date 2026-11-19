import { createClient } from '@supabase/supabase-js';
import type { Command, Filament, State } from './domain';
import type { Repository } from './repository';

const url = import.meta.env.VITE_SUPABASE_URL?.trim();
const key = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY?.trim();
export const remoteMode = import.meta.env.VITE_DATA_MODE === 'supabase';
export function remoteClient() {
  if (!url || !key) throw new Error('Falta configurar Supabase. Revisa las variables locales del proyecto.');
  if (!/^https:\/\/[a-z0-9-]+\.supabase\.co\/?$/i.test(url)) throw new Error('La URL debe ser la dirección HTTPS del proyecto Supabase.');
  if (key.startsWith('sb_secret_')) throw new Error('Usa una clave pública, nunca una clave secreta en la app.');
  if (key.startsWith('eyJ')) {
    try { if (JSON.parse(atob(key.split('.')[1].replace(/-/g, '+').replace(/_/g, '/'))).role !== 'anon') throw new Error(); }
    catch { throw new Error('La clave debe ser publishable o anon, nunca service_role.'); }
  }
  return createClient(url, key, { auth: { persistSession: true, autoRefreshToken: true } });
}
export type Client = ReturnType<typeof remoteClient>;
export async function changeAccountPassword(client: Client, current: string, next: string) {
  const { error } = await client.auth.updateUser({ password: next, current_password: current });
  if (!error) return;
  if (error.code === 'invalid_credentials') throw new Error('La contraseña actual no es correcta.');
  if (error.code === 'weak_password') throw new Error('La nueva contraseña no cumple los requisitos de seguridad. Usa una más larga y variada.');
  if (error.code === 'same_password') throw new Error('La nueva contraseña debe ser distinta de la actual.');
  throw new Error('No se pudo cambiar la contraseña. Revisa la contraseña actual y la conexión e inténtalo de nuevo.');
}
export class SupabaseRepository implements Repository {
  constructor(private client: Client, readonly inventoryId: string) {}
  private failure(error: { code?: string; message: string }): Error {
    if (error.code === '23505') return new Error('Esta etiqueta o identificador ya está registrado.');
    if (error.code === '23503') return new Error('La operación tiene referencias no válidas o datos asociados que deben conservarse.');
    return new Error(error.message || 'No se pudo conectar al inventario.');
  }
  async read(): Promise<State> {
    const { data, error } = await this.client.rpc('sp_snapshot', { p_inventory: this.inventoryId });
    if (error) throw this.failure(error);
    return data as State;
  }
  async execute(command: Command, _actorId: string, expected?: Filament | null): Promise<State> {
    // The server derives the actor from the authenticated JWT, never from the caller.
    const { data, error } = await this.client.rpc('sp_command', { p_inventory: this.inventoryId, p_command: command, p_expected: expected ?? null });
    if (error) throw this.failure(error);
    return data as State;
  }
}
