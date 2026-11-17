import { test, expect } from '@playwright/test';
test('Benchy sustituye a estantes y respeta movimiento reducido', async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 });
  await page.goto('/');
  await page.getByRole('button', { name: 'Entrar como Mi perfil' }).click();
  await page.getByRole('navigation').getByRole('button', { name: 'Escanear', exact: true }).click();
  await expect(page.locator('.benchy-animation')).toBeVisible();
  await expect(page.locator('.scan-shelves')).toHaveCount(0);
  await expect(page.locator('.nfc-radar .nav-icon')).toHaveCount(0);
  await page.screenshot({ path: 'test-results/scan-benchy-mobile.png', fullPage: true });
  await expect(page.getByText('Prueba visual temporal')).toHaveCount(0);
  await page.emulateMedia({ reducedMotion: 'reduce' });
  await expect(page.locator('.benchy-boat')).toHaveCSS('animation-name', 'none');
  for (const size of [{ width: 390, height: 844 }, { width: 1440, height: 1000 }, { width: 844, height: 390 }]) {
    await page.setViewportSize(size);
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true);
  }
});

test('NFC apagado muestra Benchy encallado y se actualiza al volver', async ({ page }) => {
  await page.route('**/src/deviceInfo.ts', route => route.fulfill({ contentType: 'application/javascript', body: `
    export const androidDevice = true;
    export async function getDeviceInfo() { return { supported: true, enabled: window.testNfcEnabled ?? false, version: 'test', build: 1 }; }
  ` }));
  await page.goto('/');
  await page.getByRole('button', { name: 'Entrar como Mi perfil' }).click();
  await page.getByRole('navigation').getByRole('button', { name: 'Escanear', exact: true }).click();
  await expect(page.locator('.benchy-animation')).toHaveClass(/is-grounded/);
  await expect(page.getByRole('status')).toContainText('NFC desactivado');
  await page.screenshot({ path: 'test-results/scan-benchy-grounded.png', fullPage: true });
  await page.evaluate(() => { (window as unknown as { testNfcEnabled: boolean }).testNfcEnabled = true; window.dispatchEvent(new Event('focus')); });
  await expect(page.locator('.benchy-animation')).toHaveClass(/is-sailing/);
});
