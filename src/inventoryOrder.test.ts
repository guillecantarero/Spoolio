import { expect, it } from 'vitest';
import { orderInventory, orderOptions, type InventoryOrder } from './inventoryOrder';
import { emptyState } from './domain';
import { visualExamples } from './visualExamples';

it('mantiene cada perfil contiguo con todos los criterios sin mutar el inventario', () => {
  const demo = visualExamples('me', '2026-11-16T12:00:00Z');
  const before = demo.spools.map(s => s.id);
  for (const order of Object.keys(orderOptions) as InventoryOrder[]) {
    const sorted = orderInventory(demo.spools, demo.filaments, emptyState().places, order, 'es');
    const runs = sorted.filter((s, i) => !i || s.filamentId !== sorted[i - 1].filamentId).map(s => s.filamentId);
    expect(new Set(runs).size).toBe(runs.length);
    expect(sorted).toHaveLength(demo.spools.length);
  }
  expect(demo.spools.map(s => s.id)).toEqual(before);
});

it('prioriza la unidad menos llena y la más reciente sin separar su grupo', () => {
  const demo = visualExamples('me', '2026-11-16T12:00:00Z');
  demo.spools.forEach(s => { s.amount = '≤100 %'; });
  const target = demo.spools.find(s => s.filamentId === 'visual-white')!;
  target.amount = '<25 %'; target.createdAt = '2026-11-17T12:00:00Z';
  for (const order of ['amount', 'recent'] as const) {
    const sorted = orderInventory(demo.spools, demo.filaments, emptyState().places, order, 'es');
    expect(sorted[0].id).toBe(target.id);
    expect(sorted.slice(0, 3).every(s => s.filamentId === target.filamentId)).toBe(true);
  }
});
