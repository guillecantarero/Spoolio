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


## Punto de continuidad — 17/11/2026

- El usuario autorizó explícitamente generar la APK actual 0.2.1 (versionCode 4), con el cambio de ubicación por pulsación corta/larga y sin aviso de guardado. Esta autorización corresponde a esta entrega; posteriores APK requieren una nueva petición.
- Benchy en perspectiva sin contorno, blanco/gris, flotación suave; estado encallado ligado al NFC real. No restituir botones de simulación. El puente NFC solo se simula en pruebas.
- El commit 315176e conserva la versión anterior de estantería. No restaurarla por defecto.
- La app sigue en modo local con selección de perfiles; no hay backend ni Auth implementados. El usuario prevé preparar la base de datos desde casa si esta APK funciona. No interpretar esa intención como permiso para desplegar infraestructura ahora.
- README contiene la ruta de continuación: Supabase provisional/PostgreSQL/Auth, migraciones, RLS de miembros y operaciones transaccionales. Confirmar si cambia a NUC antes de implementar.
- Antes de migrar, acordar importación de datos reales del móvil, exportarlos y evitar cargar los ejemplos como inventario real. No alterar UID, historial ni semántica de ubicación.
- `src/repository.ts` tiene lectura síncrona/local; su sustitución necesita refactor asíncrono de UI, no solo cambiar una URL. `src/domain.ts` contiene reglas de catálogo/unidad/NFC.
- `src/NfcRadar.tsx` controla el ciclo de lectura; `src/BenchyAnimation.tsx` dibuja la animación; `src/deviceInfo.ts` y `DeviceSettings.tsx` consultan estado/versión del plugin Android.
- Plugin: `android/app/src/main/java/com/guillecantarero/spoolio/SpoolioNfcPlugin.java`. Cambios de este archivo deben compilarse y probarse en APK; el navegador no valida Java ni radio NFC.
- Verificar con `npm test`, `npm run build` y `npm run test:e2e -- --workers=1 --timeout=60000`. El puerto de Playwright admite SPOOLIO_TEST_PORT. En Windows, pruebas con Edge instalado.
- Compilar Android con `scripts/android-debug.ps1`: build web, sync y assembleDebug. Requiere Node 22+, JDK21, SDK36. No versionar herramientas, APK, local.properties ni claves. Reutilizar firma debug para actualizar sin perder la instalación.
- Los datos del móvil, los del navegador y los del otro PC son independientes. No prometer sincronización por Git. La APK y la clave deben transferirse aparte del código.
- NFC funcionó físicamente en una versión anterior; distinguir esa confirmación de la validación física de 0.2.1. Consultar docs/VALIDACION.md para resultados reales de esta entrega.

- Incluido en APK 0.2.1: ubicación en ficha con pulsación corta para desplegar botones de personas/Fablab y guardar al elegir; pulsación larga (600 ms) para mover al usuario conectado. Conserva historial, sin movimiento duplicado si ya está allí. Guardado sin aviso de éxito y apertura táctil corregida.

- Próxima versión (código web posterior a APK 0.2.1): Escanear no muestra Cancelar lectura ni otros botones mientras busca una etiqueta. Solo aparece Volver a intentar si la lectura falla (NFC apagado, error o tiempo agotado). Salir cancela internamente. La APK 0.2.1 no incluye este cambio; no generar otra hasta petición explícita.
