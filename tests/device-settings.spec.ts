import { test, expect } from '@playwright/test';
test('configuración web identifica entorno y versión', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: 'Entrar como Mi perfil' }).click();
  await page.getByRole('navigation').getByRole('button', { name: 'Configuración' }).click();
  await expect(page.getByText('No disponible en navegador', { exact: true })).toBeVisible();
  await expect(page.getByText(/Spoolio .*Web de desarrollo/)).toBeVisible();
});
test('estado nativo simulado se actualiza y muestra versión instalada', async ({ page }) => {
  await page.route('**/src/deviceInfo.ts', route => route.fulfill({ contentType: 'application/javascript', body: `
    export const androidDevice = true;
    export async function getDeviceInfo() { return { supported: true, enabled: window.testNfcEnabled ?? false, version: '0.1.1-nfc', build: 2 }; }
  ` }));
  await page.goto('/');
  await page.getByRole('button', { name: 'Entrar como Mi perfil' }).click();
  await page.getByRole('navigation').getByRole('button', { name: 'Configuración' }).click();
  await expect(page.getByText('Desactivado', { exact: true })).toBeVisible();
  await expect(page.getByText('Spoolio 0.1.1-nfc · Compilación 2', { exact: true })).toBeVisible();
  await page.evaluate(() => { (window as unknown as { testNfcEnabled: boolean }).testNfcEnabled = true; });
  await page.getByRole('button', { name: 'Actualizar estado' }).click();
  await expect(page.getByText('Activado', { exact: true })).toBeVisible();
});
