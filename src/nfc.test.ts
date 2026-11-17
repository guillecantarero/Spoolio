import { describe, expect, it } from 'vitest';
import { applyCommand, findSpoolByUid, normalizeUid, type Command } from './domain';
import { demoState } from './demo';
const create = (nfcUids: string[] = []): Command => ({ type: 'createSpool', filamentId: 'demo-forest', locationId: 'me', mounted: true, amount: '≤100 %', nfcUids });
describe('Asociación NFC', () => {
  it('normaliza sin invertir bytes ni perder ceros iniciales', () => {
    expect(normalizeUid('04:ab:00:21')).toBe('04AB0021');
    expect(() => normalizeUid('abc')).toThrow();
    expect(() => normalizeUid('not-a-tag')).toThrow();
  });
  it('permite guardar sin etiquetas y consultar una bobina por cualquiera de sus dos etiquetas', () => {
    expect(applyCommand(demoState(), create(), 'me').spools[0].nfcUids).toEqual([]);
    const state = applyCommand(demoState(), create(['04:ab:00:21', '04ab0022']), 'me');
    expect(findSpoolByUid(state, '04ab0021')?.id).toBe(state.spools[0].id);
    expect(findSpoolByUid(state, '04ab0022')?.id).toBe(state.spools[0].id);
  });
  it('rechaza etiquetas repetidas y no modifica los datos al fallar', () => {
    expect(() => applyCommand(demoState(), create(['04AB0021', '04:ab:00:21']), 'me')).toThrow('misma');
    const state = applyCommand(demoState(), create(['04AB0021']), 'me');
    expect(() => applyCommand(state, create(['04AB0021']), 'me')).toThrow('asociada');
    expect(state.spools).toHaveLength(1);
  });
  it('añade una etiqueta a una unidad existente con historial y control de versión', () => {
    const state = applyCommand(demoState(), create(), 'me'); const spool = state.spools[0];
    const linked = applyCommand(state, { type: 'linkNfc', id: spool.id, version: 1, uid: '04AB0021' }, 'me');
    expect(linked.spools[0].version).toBe(2);
    expect(linked.events.at(-1)?.detail).toContain('04AB0021');
    expect(() => applyCommand(linked, { type: 'linkNfc', id: spool.id, version: 1, uid: '04AB0022' }, 'me')).toThrow('cambiado');
  });
  it('conserva y reserva las etiquetas de unidades retiradas', () => {
    const state = applyCommand(demoState(), create(['04AB0021']), 'me');
    const retired = applyCommand(state, { type: 'retire', id: state.spools[0].id, version: 1, reason: 'agotada' }, 'me');
    expect(findSpoolByUid(retired, '04AB0021')?.retiredAt).toBeTruthy();
    expect(() => applyCommand(retired, create(['04AB0021']), 'me')).toThrow('asociada');
    expect(() => applyCommand(retired, { type: 'linkNfc', id: state.spools[0].id, version: 2, uid: '04AB0022' }, 'me')).toThrow('retirada');
  });
});
