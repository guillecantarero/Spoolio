import { useEffect, useState } from 'react';
import { androidDevice, getDeviceInfo, type DeviceInfo } from './deviceInfo';
import packageInfo from '../package.json';

export function DeviceSettings() {
  const android = androidDevice;
  const [info, setInfo] = useState<DeviceInfo | null>(null);
  const [error, setError] = useState(false);
  const [refresh, setRefresh] = useState(0);
  useEffect(() => {
    if (!android) return;
    let active = true;
    async function update() {
      try { const result = await getDeviceInfo(); if (active) { setInfo(result); setError(false); } }
      catch { if (active) { setError(true); setInfo(null); } }
    }
    void update();
    const visible = () => { if (document.visibilityState === 'visible') void update(); };
    window.addEventListener('focus', update);
    document.addEventListener('visibilitychange', visible);
    return () => { active = false; window.removeEventListener('focus', update); document.removeEventListener('visibilitychange', visible); };
  }, [android, refresh]);
  const status = !android ? 'No disponible en navegador' : error ? 'No se pudo consultar' : !info ? 'Consultando…' : !info.supported ? 'Dispositivo sin NFC' : info.enabled ? 'Activado' : 'Desactivado';
  return <>
    <section className="panel device-settings"><h2>NFC</h2><p role="status"><span className={`device-status-dot ${info?.enabled ? 'enabled' : ''}`} aria-hidden="true"/>{status}</p>
      {!android && <p className="fine">El estado del NFC se consulta desde la app Android.</p>}
      {info?.supported && !info.enabled && <p className="fine">Actívalo en los ajustes del teléfono. El estado se actualizará al volver.</p>}
      {android && <button onClick={() => setRefresh(n => n + 1)}>Actualizar estado</button>}
    </section>
    <section className="panel"><h2>Versión de la app</h2><p>{android ? info ? `Spoolio ${info.version} · Compilación ${info.build}` : error ? 'Versión no disponible' : 'Consultando…' : `Spoolio ${packageInfo.version} · Web de desarrollo`}</p></section>
  </>;
}
