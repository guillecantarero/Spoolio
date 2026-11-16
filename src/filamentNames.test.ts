import { expect, it } from 'vitest';
import { filamentName, matchesFilament, migrateFilamentNames } from './filamentNames';
import { visualExamples } from './visualExamples';

it('busca ambos idiomas y omite diferencias de acentos, mayúsculas y orden de palabras', () => {
  const orange = visualExamples('me', '2026-11-16').filaments[2];
  expect(matchesFilament(orange, 'NARANJA translucido')).toBe(true);
  expect(matchesFilament(orange, 'orange translucent')).toBe(true);
  expect(filamentName(orange, 'es')).toBe('Naranja translúcido');
  expect(filamentName(orange, 'en')).toBe('Translucent Orange');
  expect(matchesFilament(orange, 'purple')).toBe(false);
});

it('conserva nombres antiguos personalizados y usa el disponible si falta traducción', () => {
  const original = { ...visualExamples('me', '2026-11-16').filaments[0], name: 'Mi naranja especial', nameEn: undefined };
  const upgraded = migrateFilamentNames(original);
  expect(upgraded.name).toBe(original.name);
  expect(upgraded.nameEn).toBe('');
  expect(filamentName(upgraded, 'en')).toBe(original.name);
});
