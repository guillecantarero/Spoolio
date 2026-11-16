import { emptyState, type State } from './domain';

// Explicitly fictional, optional data. Never inserted into a production backend.
export function demoState(): State {
  const state = emptyState();
  state.filaments = [
    { id: 'demo-forest', brand: 'Marca demo', material: 'PLA', variant: 'Mate', name: 'Bosque', distribution: 'unicolor', colors: [{ hex: '#527E68', name: 'Verde' }], translucent: false, sample: true },
    { id: 'demo-sunset', brand: 'Marca demo', material: 'PLA', variant: 'Silk', name: 'Atardecer', distribution: 'gradiente', colors: [{ hex: '#F4AD71', name: 'Melocotón' }, { hex: '#CB6A97', name: 'Rosa' }, { hex: '#8175B8', name: 'Violeta' }], translucent: false, sample: false },
    { id: 'demo-ink', brand: 'Marca demo', material: 'PETG', variant: '', name: 'Tinta', distribution: 'unicolor', colors: [{ hex: '#34414C', name: 'Azul oscuro' }], translucent: false, sample: false }
  ];
  // This helper only supplies catalog examples; normal commands create units.
  return state;
}
