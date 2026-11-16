import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';
import { describe, expect, it } from 'vitest';
import { BobinaIcono } from './BobinaIcono';
import { applyCommand, emptyState } from './domain';
import { LocalDemoRepository } from './repository';

describe('SVG aprobado', () => {
  for (const mounted of [true, false]) for (const multi of [true, false]) for (const translucent of [true, false]) {
    it(`${mounted ? 'bobina' : 'refill'} / ${multi ? 'multi' : 'un color'} / ${translucent ? 'translúcido' : 'opaco'}`, () => {
      const html = renderToStaticMarkup(<BobinaIcono colores={multi ? ['#8263D9', '#E885B6', '#F0C86C'] : ['#E87856']} montadaEnCarrete={mounted} translucido={translucent}/>);
      expect(html.includes('data-part="lateral-trasero"')).toBe(mounted);
      expect(html.includes('data-part="lateral-delantero"')).toBe(mounted);
      expect(html.includes('data-part="damero"')).toBe(translucent);
      expect(html).toContain(`fill-opacity="${translucent ? '0.65' : '1'}"`);
      expect(html).toContain('clip-rule="evenodd"');
      expect(html.match(/fill-opacity=/g)).toHaveLength(multi ? 2 : 1);
      if (mounted) expect(html).toContain('fill="var(--spool-front, #E4E0D5)" fill-rule="evenodd"');
      if (multi) expect(html).toContain('offset="0.5" stop-color="#E885B6"');
    });
  }
  it('evita conflictos entre instancias y ofrece respaldo para valores inválidos', () => {
    const html = renderToStaticMarkup(<><BobinaIcono colores={['invalid', '#FFFFFF', '#000000']} translucido/><BobinaIcono colores={[]} decorative/></>);
    const ids = [...html.matchAll(/\sid="([^"]+)"/g)].map(m => m[1]);
    expect(new Set(ids).size).toBe(ids.length);
    for (const ref of html.matchAll(/url\(#([^\)]+)\)/g)) expect(ids).toContain(ref[1]);
    expect(html).toContain('#92979E');
    expect(html).toContain('aria-hidden="true"');
    expect(html).toContain('role="img"');
  });
});

describe('Datos de demostración y compatibilidad', () => {
  it('añade ocho combinaciones por persona una sola vez y limpia sin borrar unidades propias', () => {
    const seeded = applyCommand(emptyState(), { type: 'installVisualDemo' }, 'me');
    expect(seeded.spools.filter(s => s.locationId === 'me')).toHaveLength(10);
    expect(applyCommand(seeded, { type: 'installVisualDemo' }, 'juan')).toBe(seeded);
    const own = applyCommand(seeded, { type: 'createSpool', filamentId: 'visual-orange', locationId: 'fablab', mounted: true, amount: '≤100 %' }, 'me');
    const cleaned = applyCommand(own, { type: 'removeVisualDemo' }, 'me');
    expect(cleaned.spools).toHaveLength(1);
    expect(cleaned.filaments.map(f => f.id)).toEqual(['visual-orange']);
    expect(cleaned.events).toHaveLength(1);
    expect(cleaned.visualDemoInitialized).toBe(true);
  });
  it('convierte perfiles antiguos a opacos sin cambiar sus colores', () => {
    const state = applyCommand(emptyState(), { type: 'installVisualDemo' }, 'me');
    const legacy = JSON.parse(JSON.stringify(state));
    legacy.filaments.forEach((f: { translucent?: boolean }) => delete f.translucent);
    const repo = new LocalDemoRepository({ getItem: () => JSON.stringify(legacy), setItem: () => {} });
    const upgraded = repo.read();
    expect(upgraded.filaments.every(f => f.translucent === false)).toBe(true);
    expect(upgraded.filaments[1].colors).toEqual(state.filaments[1].colors);
  });
});
