import { visualExamples, VISUAL_DEMO } from './visualExamples';
export const amounts = ['≤100 %', '<75 %', '<50 %', '<25 %'] as const;
export type Amount = typeof amounts[number];
export type Distribution = 'unicolor' | 'gradiente' | 'multicolor';
export type Color = { hex: string; name: string };
export type Filament = { id: string; brand: string; material: string; variant: string; name: string; nameEn?: string; distribution: Distribution; colors: Color[]; sample: boolean; translucent: boolean; demoSet?: string };
export type Person = { id: string; name: string };
export type Place = { id: string; name: string; userId?: string };
export type Spool = { id: string; filamentId: string; locationId: string; mounted: boolean; amount: Amount; version: number; createdAt: string; retiredAt?: string; retiredBy?: string; reason?: string; demoSet?: string };
export type Event = { id: string; spoolId: string; actorId: string; at: string; type: 'alta' | 'traslado' | 'edición' | 'retirada'; from?: string; to?: string; detail?: string };
export type State = { schema: 1; visualDemoInitialized?: boolean; visualDemoAmountsV1?: boolean; users: Person[]; places: Place[]; filaments: Filament[]; spools: Spool[]; events: Event[] };
export type Command =
  | { type: 'installVisualDemo' }
  | { type: 'removeVisualDemo' }
  | { type: 'saveFilament'; filament: Filament }
  | { type: 'deleteFilament'; id: string }
  | { type: 'createSpool'; filamentId: string; locationId: string; mounted: boolean; amount: Amount }
  | { type: 'updateSpool'; id: string; version: number; locationId: string; mounted: boolean; amount: Amount }
  | { type: 'retire'; id: string; version: number; reason: 'agotada' | 'retirada manual' }
  | { type: 'rename'; name: string };

export function emptyState(): State {
  return { schema: 1, users: [{ id: 'me', name: 'Mi perfil' }, { id: 'juan', name: 'Juan' }, { id: 'oscar', name: 'Óscar' }], places: [{ id: 'me', name: 'Mi perfil', userId: 'me' }, { id: 'juan', name: 'Juan', userId: 'juan' }, { id: 'oscar', name: 'Óscar', userId: 'oscar' }, { id: 'fablab', name: 'Fablab' }], filaments: [], spools: [], events: [] };
}

function requireValue(condition: unknown, message: string): asserts condition { if (!condition) throw new Error(message); }

// Pure domain operations. Production will enforce these rules server-side too.
export function applyCommand(state: State, command: Command, actorId: string, now = new Date().toISOString(), id = () => crypto.randomUUID()): State {
  requireValue(state.users.some(u => u.id === actorId), 'Selecciona un perfil de demostración válido.');
  const next = structuredClone(state);
  const location = (value: string) => requireValue(next.places.some(p => p.id === value), 'La ubicación no existe.');
  const amount = (value: string) => requireValue((amounts as readonly string[]).includes(value), 'Selecciona una cantidad válida.');
  const event = (spoolId: string, type: Event['type'], extra: Partial<Event> = {}) => next.events.push({ id: id(), spoolId, actorId, at: now, type, ...extra });
  if (command.type === 'installVisualDemo') {
    if (next.visualDemoInitialized) return state;
    const examples = visualExamples(actorId, now);
    requireValue(!examples.filaments.some(f => next.filaments.some(existing => existing.id === f.id)), 'Ya existen identificadores de ejemplos visuales.');
    next.filaments.push(...examples.filaments); next.spools.push(...examples.spools); next.events.push(...examples.events);
    next.visualDemoInitialized = true;
    next.visualDemoAmountsV1 = true;
  } else if (command.type === 'removeVisualDemo') {
    const removed = new Set(next.spools.filter(s => s.demoSet === VISUAL_DEMO).map(s => s.id));
    next.spools = next.spools.filter(s => !removed.has(s.id));
    next.events = next.events.filter(e => !removed.has(e.spoolId));
    next.filaments = next.filaments.filter(f => f.demoSet !== VISUAL_DEMO || next.spools.some(s => s.filamentId === f.id));
    next.visualDemoInitialized = true;
  } else if (command.type === 'saveFilament') {
    const f = structuredClone(command.filament);
    requireValue(typeof f.translucent === 'boolean', 'Indica si el filamento es translúcido.');
    f.nameEn = (f.nameEn ?? '').trim();
    f.brand = f.brand.trim(); f.material = f.material.trim(); f.name = f.name.trim(); f.variant = f.variant.trim();
    requireValue(f.id && f.brand && f.material && f.name, 'Completa marca, material y nombre del color.');
    requireValue(['unicolor', 'gradiente', 'multicolor'].includes(f.distribution), 'Tipo de color inválido.');
    requireValue(f.colors.length > 0 && f.colors.every(c => /^#[0-9a-f]{6}$/i.test(c.hex)), 'Cada color necesita un hexadecimal válido, por ejemplo #FF0000.');
    requireValue(f.distribution !== 'unicolor' || f.colors.length === 1, 'Un perfil unicolor debe tener un solo color.');
    f.colors = f.colors.map(c => ({ name: c.name.trim(), hex: c.hex.toUpperCase() }));
    const index = next.filaments.findIndex(item => item.id === f.id);
    if (index < 0) next.filaments.push(f); else next.filaments[index] = f;
  } else if (command.type === 'deleteFilament') {
    requireValue(!next.spools.some(s => s.filamentId === command.id), 'Este filamento tiene unidades o historial asociado y no se puede eliminar.');
    next.filaments = next.filaments.filter(f => f.id !== command.id);
  } else if (command.type === 'rename') {
    requireValue(command.name.trim(), 'Escribe un nombre.');
    next.users.find(u => u.id === actorId)!.name = command.name.trim();
    next.places.filter(p => p.userId === actorId).forEach(p => { p.name = command.name.trim(); });
  } else if (command.type === 'createSpool') {
    requireValue(next.filaments.some(f => f.id === command.filamentId), 'Selecciona un filamento del catálogo.');
    location(command.locationId); amount(command.amount);
    const spoolId = id();
    next.spools.push({ id: spoolId, filamentId: command.filamentId, locationId: command.locationId, mounted: command.mounted, amount: command.amount, version: 1, createdAt: now });
    event(spoolId, 'alta', { to: command.locationId });
  } else {
    const spool = next.spools.find(s => s.id === command.id);
    requireValue(spool, 'No se encuentra la bobina.');
    requireValue(!spool.retiredAt, 'Esta bobina ya está retirada.');
    requireValue(spool.version === command.version, 'La bobina ha cambiado en otra ventana. Cierra la ficha y vuelve a abrirla.');
    if (command.type === 'retire') {
      requireValue(['agotada', 'retirada manual'].includes(command.reason), 'Motivo de retirada inválido.');
      spool.retiredAt = now; spool.retiredBy = actorId; spool.reason = command.reason; spool.version++;
      event(spool.id, 'retirada', { from: spool.locationId, detail: command.reason });
    } else {
      location(command.locationId); amount(command.amount);
      const moved = spool.locationId !== command.locationId;
      const edited = spool.mounted !== command.mounted || spool.amount !== command.amount;
      if (!moved && !edited) return state;
      if (moved) event(spool.id, 'traslado', { from: spool.locationId, to: command.locationId });
      if (edited) event(spool.id, 'edición', { detail: `${spool.mounted ? 'Montada' : 'Refill'} · ${spool.amount} → ${command.mounted ? 'Montada' : 'Refill'} · ${command.amount}` });
      spool.locationId = command.locationId; spool.mounted = command.mounted; spool.amount = command.amount; spool.version++;
    }
  }
  return next;
}
