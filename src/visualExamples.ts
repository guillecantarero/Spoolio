import { migrateFilamentNames } from './filamentNames';
import type { Filament, Spool, Event } from './domain';

export const VISUAL_DEMO = 'visual-svg-v1';
// Real families/names where noted; preview colors are illustrative except PLA Basic.
// Multicolor translucent is explicitly fictional, not a claimed Bambu product.
export function visualExamples(actorId: string, at: string) {
  const profiles: Array<[string, string, string, string, string[], boolean]> = [
    ['orange', 'Bambu Lab', 'PLA', 'Basic', ['#FF6A13'], false],
    ['sunset', 'Bambu Lab', 'PLA', 'Silk Multicolor', ['#8263D9', '#E885B6', '#F0C86C'], false],
    ['trans-orange', 'Bambu Lab', 'PETG', 'Translucent', ['#F9A366'], true],
    ['trans-multi', 'Demo visual', 'PETG', 'Translúcido multicolor', ['#8263D9', '#E885B6', '#F0C86C'], true],
    ['white', 'Bambu Lab', 'PLA', 'Basic', ['#FFFFFF'], false],
    ['black', 'Bambu Lab', 'PLA', 'Basic', ['#000000'], false],
  ];
  const names = ['Orange', 'Dawn Radiance · demo', 'Translucent Orange', 'Aurora · ficticio', 'Jade White', 'Black'];
  const filaments: Filament[] = profiles.map(([key, brand, material, variant, colors, translucent], i) => ({ id: `visual-${key}`, brand, material, variant, name: names[i], colors: colors.map(hex => ({ hex, name: '' })), distribution: colors.length > 1 ? 'gradiente' : 'unicolor', translucent, sample: false, demoSet: VISUAL_DEMO }));
  const spools: Spool[] = [];
  const events: Event[] = [];
  // All eight combinations are present for every demo user; extras exercise white/black.
  for (const person of ['me', 'juan', 'oscar']) for (const [index, f] of filaments.entries()) for (const mounted of index < 4 ? [true, false] : [true]) {
    const id = `${f.id}-${person}-${mounted ? 'spool' : 'refill'}`;
    spools.push({ id, filamentId: f.id, locationId: person, mounted, amount: (['≤100 %', '<75 %', '<50 %', '<25 %'] as const)[spools.length % 4], version: 1, createdAt: at, demoSet: VISUAL_DEMO });
    events.push({ id: `${id}-created`, spoolId: id, actorId, at, type: 'alta', to: person });
  }
  return { filaments: filaments.map(migrateFilamentNames), spools, events };
}
