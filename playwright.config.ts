import { defineConfig } from '@playwright/test';
const port = process.env.SPOOLIO_TEST_PORT ?? '5173';
const baseURL = `http://127.0.0.1:${port}`;
export default defineConfig({
  testDir: './tests',
  use: { baseURL, browserName: 'chromium', channel: 'msedge' },
  webServer: { command: `npm run dev -- --port ${port} --strictPort`, url: baseURL, timeout: 120000, reuseExistingServer: !process.env.CI },
});
