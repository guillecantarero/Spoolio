import { androidDevice, getDeviceInfo } from './deviceInfo';
import { BenchyAnimation } from './BenchyAnimation';
import { useEffect, useRef, useState } from 'react';
import { cancelNfc, nativeNfc, scanUid } from './nfc';

export function NfcRadar({ onRead, paused }: { onRead: (uid: string) => void; paused: boolean }) {
  const [nfcEnabled, setNfcEnabled] = useState<boolean | null>(null);
  const grounded = nfcEnabled === false;
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
    if (androidDevice) void getDeviceInfo().then(info => {
      if (mounted.current && run === generation.current) setNfcEnabled(info.supported && info.enabled);
    }).catch(() => {});
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
  useEffect(() => {
    if (!androidDevice) return;
    let live = true;
    async function updateStatus() {
      try { const info = await getDeviceInfo(); if (live) setNfcEnabled(info.supported && info.enabled); }
      catch { if (live) setNfcEnabled(null); }
    }
    void updateStatus();
    const visible = () => { if (document.visibilityState === 'visible') void updateStatus(); };
    window.addEventListener('focus', updateStatus);
    document.addEventListener('visibilitychange', visible);
    return () => { live = false; window.removeEventListener('focus', updateStatus); document.removeEventListener('visibilitychange', visible); };
  }, []);
  return <div className="nfc-radar-control">
    <div className={`nfc-radar benchy-scene ${reading ? 'is-reading' : ''}`} aria-hidden="true"><BenchyAnimation grounded={grounded}/></div>
    <p role="status">{reading ? 'Buscando etiqueta NFC…' : nfcEnabled === false ? 'NFC desactivado o no disponible' : nativeNfc ? 'Lectura detenida' : 'NFC disponible en la app Android'}</p>
    {reading && <p className="fine">Acerca la etiqueta a la parte trasera del móvil.</p>}
    {error && <p role="alert" className="error">{error}</p>}
    {nativeNfc && !reading && error && <button type="button" disabled={paused} onClick={() => void scan()}>Volver a intentar</button>}

  </div>;
}
