import { BobinaIcono } from './BobinaIcono';
import { HeliceIcono } from './HeliceIcono';
export function FilamentActionIcon({ action }: { action: 'edit' | 'add' }) {
  return <span className="filament-action-art" aria-hidden="true">{action === 'add' ? <BobinaIcono colores={['#A3A3A3']} montadaEnCarrete size={48} decorative/> : <HeliceIcono colores={['#A3A3A3']} size={48}/>}<svg className="filament-action-symbol" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">{action === 'edit' ? <path d="m14 5 5 5M4 20l5-1L21 7a2 2 0 0 0-5-5L4 14z"/> : <path d="M12 5v14M5 12h14" strokeWidth="3"/>}</svg></span>;
}
