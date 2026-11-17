import { Capacitor, registerPlugin } from '@capacitor/core';
export type DeviceInfo = { supported: boolean; enabled: boolean; version: string; build: number };
const device = registerPlugin<{ deviceInfo(): Promise<DeviceInfo> }>('SpoolioNfc');
export const androidDevice = Capacitor.getPlatform() === 'android';
export const getDeviceInfo = () => device.deviceInfo();
