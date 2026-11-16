import { amounts, type Filament, type Place, type Spool } from './domain';
import { filamentName, type NameLanguage } from './filamentNames';

export const orderOptions = {
  name: 'Nombre · A–Z',
  nameDesc: 'Nombre · Z–A',
  brand: 'Marca · A–Z',
  material: 'Material · A–Z',
  location: 'Ubicación · A–Z',
  amount: 'Cantidad · menos primero',
  recent: 'Más recientes primero',
} as const;
export type InventoryOrder = keyof typeof orderOptions;
export function validOrder(value: string | null): InventoryOrder { return value && value in orderOptions ? value as InventoryOrder : 'name'; }

/** Sort whole profile groups first, then units inside each group. Never split a profile. */
export function orderInventory(units: Spool[], filaments: Filament[], places: Place[], order: InventoryOrder, language: NameLanguage): Spool[] {
  const collator = new Intl.Collator(language, { sensitivity: 'base', numeric: true });
  const profiles = new Map(filaments.map(f => [f.id, f]));
  const locations = new Map(places.map(p => [p.id, p.name]));
  const groups = new Map<string, Spool[]>();
  for (const unit of units) groups.set(unit.filamentId, [...(groups.get(unit.filamentId) ?? []), unit]);
  const compareUnits = (a: Spool, b: Spool) => {
    let difference = 0;
    if (order === 'amount') difference = amounts.indexOf(b.amount) - amounts.indexOf(a.amount);
    if (order === 'recent') difference = b.createdAt.localeCompare(a.createdAt);
    if (order === 'location') difference = collator.compare(locations.get(a.locationId) ?? '', locations.get(b.locationId) ?? '');
    return difference || collator.compare(locations.get(a.locationId) ?? '', locations.get(b.locationId) ?? '') || Number(b.mounted) - Number(a.mounted) || a.id.localeCompare(b.id);
  };
  const ordered = [...groups.values()].map(group => group.sort(compareUnits));
  ordered.sort((a, b) => {
    const af = profiles.get(a[0].filamentId)!; const bf = profiles.get(b[0].filamentId)!;
    let difference = 0;
    if (order === 'brand') difference = collator.compare(af.brand, bf.brand);
    if (order === 'material') difference = collator.compare(`${af.material} ${af.variant}`, `${bf.material} ${bf.variant}`);
    if (order === 'amount') difference = amounts.indexOf(b[0].amount) - amounts.indexOf(a[0].amount);
    if (order === 'recent') difference = b[0].createdAt.localeCompare(a[0].createdAt);
    if (order === 'location') difference = collator.compare(locations.get(a[0].locationId) ?? '', locations.get(b[0].locationId) ?? '');
    return difference || collator.compare(filamentName(af, language), filamentName(bf, language)) * (order === 'nameDesc' ? -1 : 1) || collator.compare(af.brand, bf.brand) || af.id.localeCompare(bf.id);
  });
  return ordered.flat();
}
