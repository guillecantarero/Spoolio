# Instrucciones para trabajar en Spoolio

- Antes de implementar o cambiar comportamiento, leer `docs/REQUISITOS.md`.
- Ese documento distingue requisitos confirmados, propuestas y cuestiones pendientes. No convertir una propuesta en un requisito confirmado sin acuerdo con el usuario.
- Las nuevas decisiones explícitas del usuario prevalecen sobre la documentación anterior. Actualizar el documento y su registro de cambios para mantenerlos alineados.
- Mantener identificadores estables de requisitos para poder referenciarlos durante el desarrollo.
- No interpretar ubicación como propiedad: las bobinas no tienen dueño ni responsable; tienen una ubicación actual.
- No confundir un perfil de filamento del catálogo con una unidad física del inventario.
- Implementar por recorridos funcionales pequeños y documentar cómo ejecutarlos y verificarlos.
- Distinguir pruebas ejecutadas de pruebas pendientes, especialmente las que requieren Android y un teléfono NFC físico.
- No incluir secretos ni claves privilegiadas en el repositorio o el cliente.
- No ampliar el alcance a funcionalidades futuras sin que el usuario lo solicite.

- Trabajar en la versión PC/web. No generar, actualizar ni sincronizar otra APK hasta que el usuario lo solicite explícitamente; agrupar primero los cambios de interfaz.


## Punto de continuidad — 19/11/2026

- El usuario autorizó explícitamente generar la APK actual 0.2.1 (versionCode 4), con el cambio de ubicación por pulsación corta/larga y sin aviso de guardado. Esta autorización corresponde a esta entrega; posteriores APK requieren una nueva petición.
- Benchy en perspectiva sin contorno, blanco/gris, flotación suave; estado encallado ligado al NFC real. No restituir botones de simulación. El puente NFC solo se simula en pruebas.
- El commit 315176e conserva la versión anterior de estantería. No restaurarla por defecto.
- El 19/11/2026 el usuario autoriza Supabase gratuito y confirma el esquema inicial, su cuenta y las de Juan/Óscar con sus accesos. Hay migración SQL, Auth y adaptador remoto implementados; salud remota comprobada, validación autenticada pendiente. La APK 0.2.1 sigue siendo local. No crear infraestructura NUC ahora.
- README contiene la ruta de continuación: Supabase provisional/PostgreSQL/Auth, migraciones, RLS de miembros y operaciones transaccionales. Confirmar si cambia a NUC antes de implementar.
- Antes de migrar, acordar importación de datos reales del móvil, exportarlos y evitar cargar los ejemplos como inventario real. No alterar UID, historial ni semántica de ubicación.
- `Repository.read` admite lectura asíncrona. `RemoteSession.tsx` gestiona Auth y carga; `supabaseRepository.ts` usa RPC transaccional y `main.tsx` refresca mientras no edita. `VITE_DATA_MODE=supabase` activa remoto; por defecto demo local, sin importación automática. Consultar docs/SUPABASE.md.
- `src/NfcRadar.tsx` controla el ciclo de lectura; `src/BenchyAnimation.tsx` dibuja la animación; `src/deviceInfo.ts` y `DeviceSettings.tsx` consultan estado/versión del plugin Android.
- Plugin: `android/app/src/main/java/com/guillecantarero/spoolio/SpoolioNfcPlugin.java`. Cambios de este archivo deben compilarse y probarse en APK; el navegador no valida Java ni radio NFC.
- Verificar con `npm test`, `npm run build` y `npm run test:e2e -- --workers=1 --timeout=60000`. El puerto de Playwright admite SPOOLIO_TEST_PORT. En Windows, pruebas con Edge instalado.
- Compilar Android con `scripts/android-debug.ps1`: build web, sync y assembleDebug. Requiere Node 22+, JDK21, SDK36. No versionar herramientas, APK, local.properties ni claves. Reutilizar firma debug para actualizar sin perder la instalación.
- En la demo local y la APK 0.2.1, los datos del móvil, navegador y otro PC son independientes. El modo Supabase comparte el inventario entre cuentas autorizadas; Git solo sincroniza código. La APK y la clave de firma deben transferirse aparte del código.
- NFC funcionó físicamente en una versión anterior; distinguir esa confirmación de la validación física de 0.2.1. Consultar docs/VALIDACION.md para resultados reales de esta entrega.

- Incluido en APK 0.2.1: ubicación en ficha con pulsación corta para desplegar botones de personas/Fablab y guardar al elegir; pulsación larga (600 ms) para mover al usuario conectado. Conserva historial, sin movimiento duplicado si ya está allí. Guardado sin aviso de éxito y apertura táctil corregida.

- Próxima versión (código web posterior a APK 0.2.1): Escanear no muestra Cancelar lectura ni otros botones mientras busca una etiqueta. Solo aparece Volver a intentar si la lectura falla (NFC apagado, error o tiempo agotado). Salir cancela internamente. La APK 0.2.1 no incluye este cambio; no generar otra hasta petición explícita.

- Monitor para otro mini PC en scripts/monitor: consulta sp_health sin leer datos personales ni escribir. Clave pública, nunca service_role. Tres horarios con retraso aleatorio. No garantiza evitar pausas ni incluye notificación externa.

- Conexión remota comprobada: sp_health OK; inventarios inaccesibles sin sesión. .env.local activa Supabase en este PC. Pendiente prueba autenticada del usuario y desactivar registros públicos (disable_signup=false en última consulta).


- Cambio de contraseña disponible en Configuración para cuentas remotas: actual + nueva + confirmación, mediante Auth updateUser con current_password. No requiere migración SQL. Pendiente de próxima APK y prueba con cuenta real.

- Catálogo inicial en `supabase/catalog/01-reemplazar-pruebas-catalogo.sql`: 270 perfiles verificados, 17 pendientes documentados. El usuario autorizó reemplazar los datos de prueba de aquel momento (catálogo/bobinas/NFC/historial), conservando cuentas y ubicaciones, y confirmó la carga remota el 19/11/2026. Esa autorización no cubre datos posteriores. No volver a ejecutar el reemplazo destructivo; futuras altas mediante SQL incremental. Fuentes, cobertura y validación en `supabase/catalog/README.md`.

- Continuidad desde casa: seguir docs/CONTINUAR_EN_CASA.md. El usuario pedirá la siguiente APK desde allí; la petición actual solo autoriza documentación, commit y push. No incrementar versión ni ejecutar android:sync/build ahora.
- `.env.local` contiene la configuración de este PC y no viaja por Git; recrearla en casa con URL y clave pública. La clave de firma debug existente también debe trasladarse de forma privada para actualizar el Pixel sin desinstalar.
- Cambios web pendientes de APK: Auth/sincronización, cambio de contraseña, avisos flotantes (5 s + cierre manual), material del catálogo más alto, selector de tema sol/luna junto al título de Configuración y reintento NFC solo tras fallo.
- Para E2E fijar VITE_DATA_MODE=local, SPOOLIO_TEST_PORT libre y CI=1 para no reutilizar un servidor remoto abierto. La prueba remote-session intercepta Supabase; no usa credenciales ni modifica la base real.
