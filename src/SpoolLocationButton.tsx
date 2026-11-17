import { useEffect, useId, useRef, useState } from 'react';
import type { Place } from './domain';
import { SpoolActionIcon } from './SpoolActionIcon';

export function SpoolLocationButton({ places, locationId, currentPlace, busy, onMove }: {
  places: Place[]; locationId: string; currentPlace?: string; busy: boolean;
  onMove: (id: string) => Promise<boolean>;
}) {
  const [open, setOpen] = useState(false);
  const root = useRef<HTMLDivElement>(null);
  const trigger = useRef<HTMLButtonElement>(null);
  const timer = useRef<ReturnType<typeof setTimeout> | undefined>(undefined);
  const start = useRef<{ x: number; y: number } | null>(null);
  const suppressClick = useRef(false);
  const saving = useRef(false);
  const id = useId();
  const name = places.find(p => p.id === locationId)?.name ?? '—';
  function clearHold() { clearTimeout(timer.current); timer.current = undefined; start.current = null; }
  function cancel() {
    // Touch emits pointerleave after pointerup, before click: only cancel a live hold.
    if (start.current) suppressClick.current = true;
    clearHold();
  }
  async function move(destination: string) {
    if (busy || saving.current) return;
    saving.current = true;
    try {
      if (destination === locationId || await onMove(destination)) {
        setOpen(false);
        trigger.current?.focus({ preventScroll: true });
      }
    } finally { saving.current = false; }
  }
  useEffect(() => {
    const outside = (e: PointerEvent) => { if (!root.current?.contains(e.target as Node)) setOpen(false); };
    const blur = () => { cancel(); setOpen(false); };
    document.addEventListener('pointerdown', outside);
    window.addEventListener('blur', blur);
    window.addEventListener('scroll', cancel, true);
    return () => {
      clearHold(); document.removeEventListener('pointerdown', outside);
      window.removeEventListener('blur', blur); window.removeEventListener('scroll', cancel, true);
    };
  }, []);
  return <div className="location-control" ref={root} onKeyDown={e => {
    if (e.key === 'Escape') { cancel(); setOpen(false); trigger.current?.focus(); }
  }} onBlur={e => { if (!e.currentTarget.contains(e.relatedTarget)) { cancel(); setOpen(false); } }}>
    <button ref={trigger} className="spool-action location-action" disabled={busy}
      aria-label={`Cambiar ubicación: ${name}`} aria-expanded={open} aria-controls={id}
      title="Pulsa para elegir ubicación; mantén pulsado para moverla contigo"
      onContextMenu={e => e.preventDefault()}
      onPointerDown={e => {
        if (e.button !== 0 || !e.isPrimary || busy) return;
        clearHold(); suppressClick.current = false; start.current = { x: e.clientX, y: e.clientY };
        timer.current = setTimeout(() => {
          clearHold(); suppressClick.current = true;
          if (currentPlace) void move(currentPlace);
        }, 600);
      }}
      onPointerMove={e => { if (start.current && Math.hypot(e.clientX - start.current.x, e.clientY - start.current.y) > 10) cancel(); }}
      onPointerUp={clearHold} onPointerCancel={cancel} onPointerLeave={cancel}
      onClick={e => { if (e.detail !== 0 && suppressClick.current) return; setOpen(v => !v); }}>
      <SpoolActionIcon action="location"/><span>{name}</span>
    </button>
    {open && <div id={id} className="location-options" role="group" aria-label="Elegir ubicación">
      {places.map(place => <button key={place.id} disabled={busy} aria-pressed={place.id === locationId}
        onClick={() => void move(place.id)}>{place.name}</button>)}
    </div>}
  </div>;
}
