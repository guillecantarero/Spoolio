import { Capacitor, registerPlugin } from '@capacitor/core';
import { normalizeUid } from './domain';
interface UidReader { scan(): Promise<{ uid: string }>; cancel(): Promise<void> }
const reader = registerPlugin<UidReader>('SpoolioNfc');
export const nativeNfc = Capacitor.getPlatform() === 'android';
export async function scanUid(): Promise<string> {
  if (!nativeNfc) throw new Error('La lectura NFC requiere la APK Android. No está disponible en el navegador.');
  return normalizeUid((await reader.scan()).uid);
}
export async function cancelNfc(): Promise<void> { if (nativeNfc) await reader.cancel(); }
