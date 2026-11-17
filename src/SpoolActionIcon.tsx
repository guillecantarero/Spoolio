import { BobinaIcono } from './BobinaIcono';
export function SpoolActionIcon({ action }: { action: 'edit' | 'retire' | 'location' }) {
  return <span className="spool-action-art" aria-hidden="true"><BobinaIcono colores={['#A3A3A3']} vacia={action === 'retire'} size={60} decorative/>{action !== 'location' && <svg className="spool-action-symbol" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">{action === 'edit' ? <><path d="m14 5 5 5M4 20l5-1L21 7a2 2 0 0 0-5-5L4 14z"/></> : <><path d="M3 6h18M9 6V3h6v3M5 6l1 15h12l1-15M10 10v7M14 10v7"/></>}</svg>}</span>;
}
