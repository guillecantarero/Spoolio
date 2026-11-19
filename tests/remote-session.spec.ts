import { test, expect } from '@playwright/test';
import { applyCommand, emptyState, type Command } from '../src/domain';

test('sesión remota: permisos, carga, guardado confirmado y cierre', async ({ page }) => {
  const actor='20000000-0000-0000-0000-000000000001';
  let member=false; let failWrite=false; let passwordRequests=0;
  let state={...emptyState(),visualDemoInitialized:true,users:[{id:actor,name:'Juan'}],places:[{id:'30000000-0000-0000-0000-000000000001',name:'Juan',userId:actor}]};
  await page.route('**/src/supabaseRepository.ts',async route=>{
    const response=await route.fetch();
    const body=(await response.text())
      .replace(/const url = [^\n]+/, 'const url = "https://spoolio-test.supabase.co";')
      .replace(/const key = [^\n]+/, 'const key = "sb_publishable_test";')
      .replace(/const remoteMode = [^\n]+/, 'const remoteMode = true;');
    await route.fulfill({response,body});
  });
  await page.route('https://spoolio-test.supabase.co/**',async route=>{
    const url=new URL(route.request().url());
    if(url.pathname.endsWith('/token')) {
      const jwt=['eyJhbGciOiJIUzI1NiJ9',Buffer.from(JSON.stringify({sub:actor,exp:Math.floor(Date.now()/1000)+3600})).toString('base64url'),'test'].join('.');
      return route.fulfill({json:{access_token:jwt,token_type:'bearer',refresh_token:'test-refresh',expires_in:3600,user:{id:actor,aud:'authenticated',role:'authenticated',email:'juan@example.com',app_metadata:{},user_metadata:{},created_at:new Date().toISOString()}}});
    }
    if(url.pathname.endsWith('/user') && route.request().method() === 'PUT') {
      passwordRequests++;
      const data=route.request().postDataJSON();
      expect(data.password).toBe('new-password-only');
      if(data.current_password !== 'test-password-only') return route.fulfill({status:400,headers:{'x-supabase-api-version':'2024-01-01'},json:{error_code:'invalid_credentials',code:'invalid_credentials',msg:'Invalid credentials'}});
      return route.fulfill({json:{id:actor,aud:'authenticated',role:'authenticated',email:'juan@example.com',app_metadata:{},user_metadata:{}}});
    }
    if(url.pathname.endsWith('/sp_inventories')) return route.fulfill({json:member?[{id:'10000000-0000-0000-0000-000000000001'}]:[]});
    if(url.pathname.endsWith('/sp_snapshot')) return route.fulfill({json:state});
    if(url.pathname.endsWith('/sp_command')) {
      if(failWrite) return route.fulfill({status:503,json:{message:'Servidor no disponible'}});
      const {p_command}=route.request().postDataJSON() as {p_command:Command};
      state=applyCommand(state,p_command,actor) as typeof state;
      return route.fulfill({json:state});
    }
    return route.fulfill({status:204});
  });
  await page.goto('/');
  await expect(page.getByRole('heading',{name:'Iniciar sesión'})).toBeVisible();
  await page.getByLabel('Correo',{exact:true}).fill('juan@example.com');
  await page.getByLabel('Contraseña',{exact:true}).fill('test-password-only');
  await page.getByRole('button',{name:'Entrar',exact:true}).click();
  await expect(page.getByRole('alert')).toContainText('asociada a un inventario');
  member=true;
  await page.getByRole('button',{name:'Reintentar conexión'}).click();
  await expect(page.getByRole('heading',{name:'Inventario',exact:true})).toBeVisible();
  await expect(page.locator('.spool-card')).toHaveCount(0);
  await page.getByRole('navigation').getByRole('button',{name:'Catálogo',exact:true}).click();
  await page.getByRole('button',{name:'Añadir filamento',exact:true}).click();
  await page.getByLabel('Marca',{exact:true}).fill('Prueba');
  await page.getByLabel('Material',{exact:true}).fill('PLA');
  await page.getByLabel('Nombre en español').fill('Azul remoto');
  failWrite=true;
  await page.getByRole('button',{name:'Guardar filamento'}).click();
  await expect(page.getByRole('dialog')).toBeVisible();
  await expect(page.getByRole('alert')).toContainText('Servidor no disponible');
  expect(state.filaments).toHaveLength(0);
  failWrite=false;
  await page.getByRole('button',{name:'Guardar filamento'}).click();
  await expect(page.getByRole('dialog')).toHaveCount(0);
  await expect(page.getByRole('heading',{name:'Azul remoto'})).toBeVisible();
  await page.reload();
  await expect(page.getByRole('heading',{name:'Inventario',exact:true})).toBeVisible();
  await page.getByRole('navigation').getByRole('button',{name:'Configuración'}).click();
  await expect(page.getByRole('heading',{name:'Datos locales'})).toHaveCount(0);
  await page.getByLabel('Contraseña actual',{exact:true}).fill('wrong-password');
  await page.getByLabel('Nueva contraseña',{exact:true}).fill('new-password-only');
  await page.getByLabel('Repetir nueva contraseña',{exact:true}).fill('different-password');
  await page.getByRole('button',{name:'Guardar contraseña'}).click();
  await expect(page.getByRole('alert')).toContainText('no coinciden');
  expect(passwordRequests).toBe(0);
  await page.getByLabel('Repetir nueva contraseña',{exact:true}).fill('new-password-only');
  await page.getByRole('button',{name:'Guardar contraseña'}).click();
  await expect(page.getByRole('alert')).toContainText('actual no es correcta');
  await page.getByLabel('Contraseña actual',{exact:true}).fill('test-password-only');
  await page.getByRole('button',{name:'Guardar contraseña'}).click();
  await expect(page.locator('.save-toast').getByRole('status')).toHaveText('Contraseña actualizada.');
  await expect(page.getByLabel('Contraseña actual',{exact:true})).toHaveValue('');
  await expect(page.getByLabel('Nueva contraseña',{exact:true})).toHaveValue('');
  await expect(page.getByLabel('Repetir nueva contraseña',{exact:true})).toHaveValue('');
  expect(passwordRequests).toBe(2);
  await page.getByRole('button',{name:'Cerrar sesión'}).click();
  await expect(page.getByRole('heading',{name:'Iniciar sesión'})).toBeVisible();
});
