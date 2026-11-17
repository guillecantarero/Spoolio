import { describe, expect, it, vi } from 'vitest';
import { applyCommand, emptyState, type State } from './domain';
import { demoState } from './demo';
import { LocalDemoRepository } from './repository';

function withSpool(): State { return applyCommand(demoState(), { type: 'createSpool', filamentId: 'demo-forest', locationId: 'me', mounted: true, amount: '≤100 %' }, 'me'); }
describe('Inventario e historial', () => {
  it('permite perfiles sin unidades pero impide unidades sin perfil', () => {
    expect(demoState().spools).toHaveLength(0);
    expect(() => applyCommand(emptyState(), { type: 'createSpool', filamentId: 'missing', locationId: 'me', mounted: true, amount: '≤100 %' }, 'me')).toThrow('catálogo');
  });
  it('rechaza actores desconocidos y ubicaciones inexistentes', () => {
    const command = { type: 'createSpool' as const, filamentId: 'demo-forest', locationId: 'missing', mounted: true, amount: '≤100 %' as const };
    expect(() => applyCommand(demoState(), command, 'outsider')).toThrow('perfil');
    expect(() => applyCommand(demoState(), command, 'me')).toThrow('ubicación');
  });
  it('registra origen, destino y actor juntos sin modificar el estado previo', () => {
    const before = withSpool(); const spool = before.spools[0];
    const after = applyCommand(before, { type: 'updateSpool', id: spool.id, version: 1, locationId: 'fablab', mounted: true, amount: '<50 %' }, 'juan', '2026-11-16T12:00:00Z');
    expect(before.spools[0].locationId).toBe('me');
    expect(after.spools[0].locationId).toBe('fablab');
    expect(after.events[1]).toMatchObject({ type: 'traslado', actorId: 'juan', from: 'me', to: 'fablab', at: '2026-11-16T12:00:00Z' });
  });
  it('no duplica movimientos y detecta ediciones obsoletas', () => {
    const s = withSpool(); const spool = s.spools[0];
    const c = { type: 'updateSpool' as const, id: spool.id, version: 1, locationId: 'me', mounted: true, amount: '≤100 %' as const };
    expect(applyCommand(s, c, 'me')).toBe(s);
    const moved = applyCommand(s, { ...c, locationId: 'juan' }, 'juan');
    expect(() => applyCommand(moved, { ...c, locationId: 'oscar' }, 'oscar')).toThrow('otra ventana');
  });
  it('retira sin perder catálogo, muestra o historial y bloquea cambios posteriores', () => {
    const before = withSpool(); const id = before.spools[0].id;
    const after = applyCommand(before, { type: 'retire', id, version: 1, reason: 'agotada' }, 'oscar');
    expect(after.spools.filter(s => !s.retiredAt)).toHaveLength(0);
    expect(after.spools[0].retiredBy).toBe('oscar');
    expect(after.events.map(e => e.type)).toEqual(['alta', 'retirada']);
    expect(after.filaments[0].sample).toBe(true);
    expect(() => applyCommand(after, { type: 'deleteFilament', id: 'demo-forest' }, 'me')).toThrow('historial');
    expect(() => applyCommand(after, { type: 'retire', id, version: 2, reason: 'agotada' }, 'me')).toThrow('retirada');
  });
  it('conserva orden de colores y valida hexadecimales', () => {
    const f = demoState().filaments[1];
    const saved = applyCommand(emptyState(), { type: 'saveFilament', filament: f }, 'me');
    expect(saved.filaments[0].colors.map(c => c.hex)).toEqual(['#F4AD71', '#CB6A97', '#8175B8']);
    expect(() => applyCommand(saved, { type: 'saveFilament', filament: { ...f, colors: [{ hex: 'red', name: '' }] } }, 'me')).toThrow('hexadecimal');
    expect(() => applyCommand(saved, { type: 'saveFilament', filament: { ...f, colors: [] } }, 'me')).toThrow('hexadecimal');
  });
});
describe('Persistencia local de demostración', () => {
  it('no publica el cambio cuando falla el almacenamiento', async () => {
    vi.stubGlobal('navigator', { locks: { request: (_: string, fn: () => State) => fn() } });
    const before = withSpool();
    const storage = { getItem: () => JSON.stringify(before), setItem: () => { throw new Error('Quota exceeded'); } };
    const repo = new LocalDemoRepository(storage);
    await expect(repo.execute({ type: 'retire', id: before.spools[0].id, version: 1, reason: 'agotada' }, 'me')).rejects.toThrow('No se pudo guardar');
    expect(repo.read().spools[0].retiredAt).toBeUndefined();
    vi.unstubAllGlobals();
  });
  it('no sobrescribe un formato desconocido o datos corruptos', () => {
    const write = vi.fn();
    const repo = new LocalDemoRepository({ getItem: () => '{broken', setItem: write });
    expect(() => repo.read()).toThrow('No se han sobrescrito');
    expect(write).not.toHaveBeenCalled();
  });
});


describe('Corrección del perfil de una bobina', () => {
  it('cambia el perfil con historial y conserva sus etiquetas y ubicación', () => {
    const before = applyCommand(demoState(), { type: 'createSpool', filamentId: 'demo-forest', locationId: 'fablab', mounted: true, amount: '≤100 %', nfcUids: ['04AB0021'] }, 'me');
    const spool = before.spools[0];
    const command = { type: 'updateSpool' as const, id: spool.id, version: spool.version, filamentId: 'demo-sunset', locationId: spool.locationId, mounted: false, amount: '<50 %' as const };
    const after = applyCommand(before, command, 'me');
    expect(after.spools[0]).toMatchObject({ filamentId: 'demo-sunset', locationId: 'fablab', nfcUids: ['04AB0021'], mounted: false, amount: '<50 %' });
    expect(after.events.some(e => e.detail === 'Filamento: Bosque → Atardecer')).toBe(true);
    expect(() => applyCommand(before, { ...command, filamentId: 'missing' }, 'me')).toThrow('catálogo');
    expect(before.spools[0].filamentId).toBe('demo-forest');
  });
});
