import { test, expect } from '@playwright/test';
// Test-only bridge replacement. This verifies the UI; it does not validate radio hardware.
test('alta con dos etiquetas y consulta posterior por NFC', async ({ page }) => {
  await page.route('**/src/nfc.ts', route => route.fulfill({ contentType: 'application/javascript', body: `
    export const nativeNfc = true;
    let calls = 0;
    export async function scanUid() { return ['04AB0021', '04AB0022', '04AB0021'][calls++]; }
    export async function cancelNfc() {}
  ` }));
  await page.setViewportSize({ width: 390, height: 844 });
  await page.goto('/');
  await page.getByRole('button', { name: 'Entrar como Mi perfil' }).click();
  await page.getByRole('navigation').getByRole('button', { name: 'Escanear', exact: true }).click();
  await expect(page.getByRole('heading', { name: 'Etiqueta nueva' })).toBeVisible();
  await page.getByRole('button', { name: 'Crear bobina con esta etiqueta' }).click();
  await page.locator('.filament-options button').first().click();
  await page.getByRole('button', { name: 'Leer segunda etiqueta' }).click();
  await expect(page.locator('dialog')).toContainText('04AB0022');
  await page.getByRole('button', { name: 'Guardar bobina', exact: true }).click();
  await expect(page.locator('dialog')).toHaveCount(0);
  await page.getByRole('navigation').getByRole('button', { name: 'Escanear', exact: true }).click();
  await expect(page.getByRole('heading', { name: 'Ficha de bobina' })).toBeVisible();
  await expect(page.locator('.detail')).toContainText('04AB0021');
  await expect(page.locator('.detail')).toContainText('04AB0022');
  await page.reload();
  await page.getByRole('button', { name: 'Entrar como Mi perfil' }).click();
  await page.getByRole('navigation').getByRole('button', { name: 'Escanear', exact: true }).click();
  await expect(page.getByRole('heading', { name: 'Ficha de bobina' })).toBeVisible();
  await page.screenshot({ path: 'test-results/nfc-linked-spool.png', fullPage: true });
});

test('escaneo inicia lectura y cambiar a inventario la cancela', async ({ page }) => {
  await page.route('**/src/nfc.ts', route => route.fulfill({ contentType: 'application/javascript', body: `
    export const nativeNfc = true;
    let rejectRead;
    export function scanUid() { window.nfcStarted = true; return new Promise((_, reject) => { rejectRead = reject; }); }
    export async function cancelNfc() { window.nfcCancelled = true; rejectRead?.(new Error('Cancelada')); }
  ` }));
  await page.goto('/');
  await page.getByRole('button', { name: 'Entrar como Mi perfil' }).click();
  await page.getByRole('navigation').getByRole('button', { name: 'Escanear', exact: true }).click();
  await expect(page.locator('.nfc-radar')).toHaveClass(/is-reading/);
  await expect(page.getByRole('status')).toContainText('Buscando etiqueta NFC');
  await expect(page.getByRole('button', { name: 'Añadir manualmente' })).toHaveCount(0);
  await page.getByRole('navigation').getByRole('button', { name: 'Inventario', exact: true }).click();
  await page.getByRole('button', { name: 'Añadir bobina', exact: true }).click();
  await expect(page.locator('dialog')).toBeVisible();
  await expect.poll(() => page.evaluate(() => (window as unknown as { nfcCancelled: boolean }).nfcCancelled)).toBe(true);
  await expect(page.locator('.nfc-radar')).toHaveCount(0);
});
