import { test, expect } from '@playwright/test';
test('estantes se adaptan al espacio de escaneo sin tapar navegación', async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 });
  await page.goto('/');
  await page.getByRole('button', { name: 'Entrar como Mi perfil' }).click();
  await page.getByRole('navigation').getByRole('button', { name: 'Escanear', exact: true }).click();
  await expect(page.locator('.scan-shelf').first()).toBeVisible();
  await page.screenshot({ path: 'test-results/scan-shelves-mobile.png', fullPage: true });
  for (const size of [{ width: 390, height: 844 }, { width: 1440, height: 1000 }, { width: 844, height: 390 }]) {
    await page.setViewportSize(size);
    await expect.poll(async () => page.locator('.scan-shelf').evaluateAll(rows => rows.every(row => row.getBoundingClientRect().bottom <= document.querySelector('nav')!.getBoundingClientRect().top))).toBe(true);
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true);
  }
});
