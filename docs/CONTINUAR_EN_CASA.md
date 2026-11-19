# Continuar Spoolio desde casa — 19/11/2026

## Estado guardado

- Última APK: **0.2.1 / versionCode 4**, demostración local. Esta entrega actualiza código/documentación/Git; no crea ni sincroniza una APK nueva.
- Web actual: Supabase Auth persistente y repositorio compartido; cambio de contraseña con actual + nueva dos veces; notificaciones flotantes con cierre automático/manual; etiqueta de material ampliada; tema sol/luna en la cabecera de Configuración; reintento NFC solo tras fallo.
- El usuario confirma esquema inicial, cuentas reales de Guillermo/Juan/Óscar y sus accesos. Fablab sigue siendo una ubicación, no una cuenta.
- El usuario confirma que **el catálogo ya está cargado**. Lote: 270 perfiles, 292 colores; 17 perfiles incompletos excluidos y documentados en [el informe](../supabase/catalog/README.md). No volver a ejecutar el SQL de reemplazo: borraría bobinas, UID e historial. Las futuras ampliaciones deben ser incrementales.
- Verificado desde este PC: sp_health HTTP 200/ok; lectura anónima de inventarios denegada. No se han probado las contraseñas reales, operaciones entre cuentas ni una APK remota.
- La última comprobación de Auth mostró registros públicos habilitados. Revisar y desactivar Allow new users to sign up si aún sigue activo. No hace falta crear de nuevo a los tres usuarios.

## Preparar el PC

1. Abrir el repositorio existente, guardar cambios propios y ejecutar `git pull --ff-only`. Si no existe, clonar https://github.com/guillecantarero/Spoolio.git y abrir Spoolio.code-workspace.
2. Con Node 22+, ejecutar `npm ci`.
3. Recrear `.env.local` (se excluye de Git):

```dotenv
VITE_DATA_MODE=supabase
VITE_SUPABASE_URL=https://pqumkpybdhzhyajuvdgg.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=PEGA_LA_CLAVE_PUBLICA_DEL_PROYECTO
```

Obtener Publishable key en el panel Supabase → Settings → API Keys, o copiar de forma privada el `.env.local` del PC anterior. No usar secret, service_role ni la contraseña PostgreSQL. No publicar `.env.local`. Sin esta configuración el clon arranca en demo local y vuelve a mostrar ejemplos.

4. Ejecutar `npm run dev`; entrar con la cuenta real y comprobar el catálogo cargado. Se pueden cambiar las contraseñas genéricas en Configuración. No compartir contraseñas en el chat.
5. Verificar creación de una unidad real, cambio de ubicación e historial desde otra cuenta. La app refresca cada 15 s cuando está visible y no se está editando, y al volver a la ventana.

## Pruebas de desarrollo

```powershell
npm test
npm run build
$env:VITE_DATA_MODE='local'
$env:SPOOLIO_TEST_PORT='5198'
$env:CI='1'
npm run test:e2e -- --workers=1 --timeout=60000
Remove-Item Env:VITE_DATA_MODE, Env:SPOOLIO_TEST_PORT, Env:CI
node --test scripts/monitor/check-health.test.mjs
node scripts/catalog/verify-import.mjs
```

Las pruebas usan datos locales, Auth simulado o PostgreSQL embebido; **verify-import no se conecta a Supabase ni borra el catálogo real**. Edge instalado para E2E. Revisar que no quede VITE_DATA_MODE=local en la terminal utilizada después para compilar una APK remota.

## Cuando el usuario pida la siguiente APK

- Confirmar que `.env.local` activa Supabase, que se puede iniciar sesión y que el catálogo remoto es el correcto. No ejecutar las migraciones/alta inicial/reemplazo de catálogo otra vez.
- Conservar cualquier dato local del Pixel que se necesite antes de cambiar a remoto. No hay importación automática; la app remota consulta otro almacenamiento.
- Preparar JDK 21, SDK 36, Build Tools y la **misma firma debug** usada en este PC. La firma y APK no van por Git. Si falta la firma, recuperarla por un medio privado antes de generar una actualización; no desinstalar para sortear un error de firma.
- Incrementar versión en package.json/package-lock.json y versionName/versionCode Android al preparar la nueva entrega. Hoy permanecen 0.2.1 / 4.
- Ejecutar `scripts/android-debug.ps1` solo tras la petición de APK. Produce build web, sync y assembleDebug. Ver [Android/NFC](ANDROID_NFC.md).
- Verificar paquete, versión, certificado y assets. Probar en Pixel login persistente, cambio de contraseña, alta con dos NFC, consulta, traslado, retirada y NFC desactivado/reintento.

## Trabajo todavía pendiente

- Validación autenticada real entre usuarios y física de la próxima APK.
- Completar los 17 perfiles excluidos sin inventar HEX/acabados; algunos nombres comerciales permanecen en inglés si no se localizó traducción oficial.
- Configurar copias remotas y probar restauración.
- Instalar el monitor en el otro mini PC: está preparado, no desplegado, y no garantiza evitar pausas de Supabase Free.
- NUC, ESP32 y otras funciones futuras siguen fuera de esta entrega.
