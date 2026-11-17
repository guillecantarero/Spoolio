import { useEffect, useRef, useState } from 'react';
import { cancelNfc, scanUid } from './nfc';
export function NfcScanButton({ onRead, children = 'Escanear etiqueta', className = '', disabled = false, label }: {
  onRead: (uid: string) => void | Promise<void>; children?: React.ReactNode; className?: string; disabled?: boolean; label?: string;
}) {
  const [reading, setReading] = useState(false);
  const [error, setError] = useState('');
  const active = useRef(false);
  const mounted = useRef(true);
  useEffect(() => { mounted.current = true; return () => { mounted.current = false; if (active.current) void cancelNfc(); }; }, []);
  async function scan() {
    if (active.current) return;
    active.current = true; setReading(true); setError('');
    try { const uid = await scanUid(); if (mounted.current) await onRead(uid); }
    catch (e) { if (mounted.current) setError((e as Error).message); }
    finally { active.current = false; if (mounted.current) setReading(false); }
  }
  return <div className="nfc-control"><button type="button" className={className} aria-label={label} title={label} disabled={disabled || reading} onClick={scan}>{children}</button>{reading && <div role="status"><p>Acerca una etiqueta a la parte trasera del móvil…</p><button type="button" onClick={() => void cancelNfc()}>Cancelar lectura</button></div>}{error && <p role="alert" className="error">{error}</p>}</div>;
}
