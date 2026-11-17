import { NavigationIcon } from './NavigationIcon';
import { useEffect, useRef, useState } from 'react';
import { cancelNfc, nativeNfc, scanUid } from './nfc';

export function NfcRadar({ onRead, paused }: { onRead: (uid: string) => void; paused: boolean }) {
  const [reading, setReading] = useState(false);
  const [error, setError] = useState('');
  const active = useRef(false);
  const mounted = useRef(false);
  const generation = useRef(0);
  async function stop() {
    generation.current++;
    if (active.current) { active.current = false; await cancelNfc(); }
    if (mounted.current) setReading(false);
  }
  async function scan() {
    if (active.current || paused) return;
    const run = ++generation.current;
    active.current = true; setReading(true); setError('');
    try {
      const uid = await scanUid();
      if (mounted.current && run === generation.current) onRead(uid);
    } catch (e) {
      if (mounted.current && run === generation.current) setError((e as Error).message);
    } finally {
      if (mounted.current && run === generation.current) { active.current = false; setReading(false); }
    }
  }
  useEffect(() => {
    mounted.current = true;
    const timer = window.setTimeout(() => { if (nativeNfc) void scan(); }, 0);
    return () => { window.clearTimeout(timer); mounted.current = false; void stop(); };
  }, []);
  useEffect(() => { if (paused) void stop(); }, [paused]);
  return <div className="nfc-radar-control">
    <div className={`nfc-radar ${reading ? 'is-reading' : ''}`} aria-hidden="true"><NavigationIcon index={2}/></div>
    <p role="status">{reading ? 'Buscando etiqueta NFC…' : nativeNfc ? 'Lectura detenida' : 'NFC disponible en la app Android'}</p>
    {reading && <p className="fine">Acerca la etiqueta a la parte trasera del móvil.</p>}
    {error && <p role="alert" className="error">{error}</p>}
    {nativeNfc && <button type="button" disabled={paused} onClick={() => void (reading ? stop() : scan())}>{reading ? 'Cancelar lectura' : 'Volver a escanear'}</button>}
  </div>;
}
