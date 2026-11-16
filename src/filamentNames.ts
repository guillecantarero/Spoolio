import type { Filament } from './domain';

export type NameLanguage = 'es' | 'en';
export function filamentName(f: Filament, language: NameLanguage): string {
  return language === 'en' ? f.nameEn?.trim() || f.name : f.name || f.nameEn || '';
}
export function searchText(value: string): string {
  return value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLocaleLowerCase().trim();
}
export function matchesFilament(f: Filament, query: string): boolean {
  const index = searchText([f.brand, f.material, f.variant, f.name, f.nameEn ?? '', ...f.colors.flatMap(c => [c.name, c.hex])].join(' '));
  return searchText(query).split(/\s+/).every(word => index.includes(word));
}

// Only known, unchanged examples receive translations. User-entered names are preserved.
const exampleNames: Record<string, [string, string]> = {
  'visual-orange': ['Naranja', 'Orange'],
  'visual-sunset': ['Resplandor del amanecer · demo', 'Dawn Radiance · demo'],
  'visual-trans-orange': ['Naranja translúcido', 'Translucent Orange'],
  'visual-trans-multi': ['Aurora · ficticio', 'Aurora · fictional'],
  'visual-white': ['Blanco jade', 'Jade White'],
  'visual-black': ['Negro', 'Black'],
};
export function migrateFilamentNames(f: Filament): Filament {
  if (typeof f.nameEn === 'string') return f;
  const names = f.demoSet === 'visual-svg-v1' ? exampleNames[f.id] : undefined;
  if (names && (f.name === names[1] || f.name === names[0])) return { ...f, name: names[0], nameEn: names[1] };
  return { ...f, nameEn: '' };
}
