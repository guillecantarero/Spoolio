import { test, expect } from '@playwright/test';

test('guardados flotantes: cierre manual, automático y sin desplazar contenido', async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 });
  await page.goto('/');
  await page.getByRole('button', { name: 'Entrar como Mi perfil' }).click();
  await page.locator('.spool-card').first().click();
  if (await page.getByRole('button', { name: 'Cerrar notificación' }).count()) await page.getByRole('button', { name: 'Cerrar notificación' }).click();
  const before = await page.locator('.detail').boundingBox();
  await page.getByRole('button', { name: 'Editar bobina', exact: true }).click();
  await page.getByRole('button', { name: 'Guardar bobina', exact: true }).click();
  await expect(page.locator('.save-toast')).toContainText('Bobina guardada.');
  await expect(page.locator('.save-toast')).toHaveCSS('position', 'fixed');
  const after = await page.locator('.detail').boundingBox();
  expect(after?.y).toBe(before?.y);
  await page.screenshot({ path: 'test-results/save-toast-mobile.png', fullPage: true });
  await page.getByRole('button', { name: 'Cerrar notificación' }).click();
  await expect(page.locator('.save-toast')).toHaveCount(0);
  await page.getByRole('navigation').getByRole('button', { name: 'Catálogo', exact: true }).click();
  await page.getByRole('button', { name: 'Editar', exact: true }).first().click();
  await page.getByRole('button', { name: 'Guardar filamento' }).click();
  await expect(page.locator('.save-toast')).toContainText('Filamento guardado.');
  await expect(page.locator('.save-toast')).toHaveCount(0, { timeout: 7000 });
});
