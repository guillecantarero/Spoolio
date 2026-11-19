# Registro de validación de Spoolio

## Estado actual — 19/11/2026

- `npm test`: **31 pruebas correctas en 6 archivos**, incluidas reglas del dominio, NFC, representación y esquema/permisos PostgreSQL embebido.
- `npm run test:e2e -- --workers=1 --timeout=60000`: **14 recorridos correctos** en Edge, con `VITE_DATA_MODE=local`, `SPOOLIO_TEST_PORT=5198` y `CI=1`. Auth se simula en su recorrido; no se usan contraseñas reales ni se modifica Supabase.
- `npm run build`: correcto. Aviso no bloqueante de Vite por un paquete JavaScript mayor de 500 kB; no se ha medido el rendimiento en el Pixel con este código.
- `node --test scripts/monitor/check-health.test.mjs`: **3 pruebas correctas**. Monitor preparado, todavía sin instalar en el mini PC.
- `node scripts/catalog/verify-import.mjs`: correcto en PostgreSQL embebido. Comprueba reversión ante datos inválidos, importación de 270 perfiles/292 colores, conservación de miembros/ubicaciones y rechazo de una segunda ejecución. No conecta con el proyecto real.
- Comprobación remota realizada: `sp_health` responde HTTP 200 con `ok`; la lectura de inventarios sin sesión es denegada (HTTP 401/42501). La última consulta de Auth mostró `disable_signup=false`; pendiente revisar/desactivar nuevos registros.
- El usuario confirma esquema inicial, las tres cuentas con sus accesos y **catálogo cargado en Supabase**. Esta confirmación no sustituye una prueba autenticada desde la app. No volver a ejecutar el reemplazo destructivo; futuras ampliaciones incrementales.
- Catálogo: 270 perfiles incluidos y 17 excluidos por datos pendientes; fuentes y límites en [el informe de importación](../supabase/catalog/README.md). No se han inventado los HEX faltantes.
- Pendientes: login y cambio de contraseña con cuenta real, operaciones entre usuarios/dispositivos, copias remotas y lectura NFC física con la próxima APK.
- No se ha generado ni sincronizado una APK ni incrementado la versión en esta entrega. La última sigue siendo **0.2.1 / versionCode 4**, en modo local. Continuación documentada en [CONTINUAR_EN_CASA.md](CONTINUAR_EN_CASA.md).

Las secciones siguientes conservan el histórico: sus pendientes corresponden a la fecha de cada revisión.

## Primera demo local — histórico

Fecha: 16 de noviembre de 2026.

## Nombres bilingües

- Compilación correcta y 21 pruebas unitarias correctas, incluidas búsqueda español/inglés sin acentos, respaldo cuando falta traducción y preservación de nombres personalizados antiguos.
- Los recorridos de navegador incluyen selección de inglés, búsqueda del mismo filamento en ambos idiomas y persistencia de la preferencia tras recargar.

## Representación SVG de bobinas

- `npm run build`: correcto.
- `npm test`: **19 pruebas correctas**, incluidas ocho combinaciones de formato/color/translucidez, respaldo de colores, IDs únicos y referencias, opacidad aplicada solo al relleno, migración de registros antiguos e instalación/limpieza segura del lote temporal.
- `npm run test:e2e`: **dos recorridos correctos** en Edge. Se mantiene el recorrido manual anterior y se añade el de ejemplos, cuadrícula de tres columnas, lista persistente, edición con previsualización, recarga con colores/translucidez conservados, cambio de tema y limpieza sin reaparición de ejemplos.
- Capturas revisadas de cuadrícula y lista en móvil y de temas claro/oscuro; comprobación de ancho a 320 px y captura de escritorio a 1440 px. Damero visible en los filamentos, laterales opacos y agujero sólido según el SVG aprobado.
- El lote incluye blanco y negro. Las pruebas de componente cubren colores inválidos y ausentes sin introducir esos valores en el catálogo real.
- Sigue pendiente la prueba física Android/NFC. No hay cambios SQL que ejecutar: la migración de `translucent` se realiza en el adaptador local; el futuro backend debe incorporar el campo booleano con default false.

## Revisión de navegación y apariencia

- Compilación y recorrido completo de interfaz correctos después del rediseño.
- Comprobados en Edge: oscuro por defecto, cambio a claro en Configuración, persistencia tras recargar y acceso mediante el botón central Escanear.
- Revisadas capturas de la barra inferior a 390 y 320 px; no hay desbordamiento horizontal. Los botones mantienen nombres accesibles, incluido Escanear aunque no tenga texto visible.
- El tema afecta a formularios, ventanas de edición, catálogo, ficha, historial y pantalla de acceso demo. Validación en navegador; no en Android físico.

## Ejecutado

- `npm run build`: TypeScript y compilación Vite correctos.
- `npm test`: 8 pruebas correctas sobre relaciones obligatorias, validación de actor/ubicación, movimientos, ausencia de duplicados, conflicto de versión, retirada e historial, colores, fallos de almacenamiento y datos ilegibles.
- `npm run test:e2e`: 1 recorrido completo correcto en Microsoft Edge. Crea un perfil multicolor con muestra, registra un refill en Fablab, recarga, entra como Juan, recoge la unidad, verifica Mis bobinas, retira la unidad y comprueba catálogo e historial.
- Vista móvil de 390 px comprobada sin desbordamiento horizontal. Capturas móvil y escritorio revisadas visualmente.
- Instalación de dependencias: npm informó de cero vulnerabilidades en ese momento.

La primera ejecución de build/tests en el entorno restringido falló por bloqueo de subprocesos (`EPERM`); se completaron al ejecutarlos con los permisos necesarios. El primer intento de interfaz falló por un selector de prueba de un campo; se corrigió para usar su rol accesible y el recorrido pasó.

## No probado / no implementado

- Autenticación real, permisos de servidor, RLS y sincronización entre dispositivos.
- Migraciones PostgreSQL y funciones transaccionales del backend.
- Lectura o asociación NFC, APK, emulador Android y Pixel físico.
- Importación de copias JSON o migración automática de datos demo al futuro servidor.

Las comprobaciones de actor en el modelo local son validaciones funcionales, no pruebas de seguridad de producción. El cambio entre perfiles es una simulación explícita, no una autenticación.


## 17 de noviembre de 2026 — Android y NFC

- Build web correcto con Capacitor 8.6.2 y lector UID local.
- 28 pruebas unitarias correctas, incluidas cinco pruebas de reglas NFC.
- Recorridos de interfaz manual y visual correctos. Recorrido NFC con puente simulado
  correcto tras corregir la ficha: alta con dos etiquetas, consulta y persistencia.
- Captura revisada de la ficha móvil con los dos UID.
- Se excluyen herramientas y compilación Android del observador de Vite para evitar
  bloquear el servidor de desarrollo. Playwright admite SPOOLIO_TEST_PORT.
- Pendiente: lectura física en Pixel. Las pruebas de interfaz no validan el hardware.
- APK debug compilada correctamente con Gradle 8.14.3, JDK 21 y SDK 36.
  El bloqueo temporal de la caché de Windows se resolvió al reintentar con un trabajador,
  sin daemon y sin observación del sistema de archivos; no se cambió la versión de Gradle.
- Firma APK v2 verificada con apksigner. Assets de la APK comparados byte a byte con dist;
  complemento SpoolioNfcPlugin presente en DEX. Archivo entregable: artifacts/Spoolio-debug.apk.

- El usuario confirma lectura NFC correcta en el Pixel (17/11/2026). Nueva revisión de ficha con acciones SVG y selector para todas las ubicaciones.

- Revisión 0.1.1-nfc (versionCode 2): 28 pruebas unitarias y tres recorridos E2E correctos. Verificada visualmente la ficha con los tres botones. APK compilada, firma válida y assets comparados con dist.

- Editor web revisado: búsqueda bilingüe del catálogo, cambio de perfil con historial, ubicación conservada al editar, botón SVG carrete/refill y deslizador de cuatro niveles. Build web, 29 pruebas unitarias y cuatro recorridos E2E correctos; captura móvil revisada. No se generó ni sincronizó una APK para estos cambios.

- Selector del editor como lista visual siempre visible: hélices del catálogo, tres filas y desplazamiento, búsqueda bilingüe y selección resaltada. Compilación web y cuatro recorridos E2E correctos; captura móvil del editor revisada. Sin generar ni sincronizar APK.

- Símbolos superpuestos de añadir, editar y retirar con fondo CSS transparente. Compilación web correcta; sin cambios en la APK.

- Escaneo automático al pulsar la navegación central, radar animado durante lectura, cancelación al abrir alta manual y opción de reintento. Build web y cinco pruebas E2E correctas (NFC mediante puente simulado; hardware pendiente de próxima APK).

- Catálogo: acciones SVG con hélice y lápiz/+, indicador de muestra no editable desde tarjeta y cambio guardado desde el editor. Compilación web y cinco recorridos E2E correctos tras ajustar el selector del test para distinguir indicador y casilla. No se generó APK.

- Editor de catálogo: botones con hélice para sólido/gradiente y translucidez independiente, selección resaltada y previsualización actualizada. Compilación web y cinco recorridos E2E correctos. Sin generar ni sincronizar APK.

- Alta manual trasladada a Mis bobinas e Inventario mediante bobina con + en la cabecera. Eliminada de Escanear. Compilación y cinco recorridos E2E correctos, incluida cancelación de lectura al cambiar de pestaña. Sin generar APK.

- Configuración: estado NFC y versión, con refresco manual y al volver al primer plano. Build web y dos pruebas E2E correctas (web y puente Android simulado con cambio desactivado/activado). Consulta nativa implementada en fuente Java; compilación y prueba física pendientes de la próxima APK autorizada. No se sincronizó ni generó APK.

- Estantería decorativa en Escanear: perfiles aleatorios del catálogo, adaptación mediante ResizeObserver y ocultación si no caben filas. Build y tres pruebas E2E correctas, incluyendo móvil, escritorio y horizontal; captura móvil revisada y compensado el margen interno del SVG para apoyar las bobinas en los estantes. Sin APK.

- Variante Benchy: versión previa guardada en commit local 315176e. SVG único con balanceo y ondas mediante CSS, estantería fuera del render y movimiento reducido respetado. Build web y tres pruebas E2E correctas (incluye NFC simulado); captura móvil revisada. No se midió una mejora de tiempo de carga ni se generó APK.

- Benchy revisado según referencia: perspectiva de tres cuartos, volúmenes blancos/grises y ausencia de contorno. Compilación y prueba visual responsive/movimiento reducido correctas; captura móvil inspeccionada. Se conserva el balanceo CSS y no se genera APK.

- Benchy: flotación y balanceo independientes de baja amplitud, estado encallado inmóvil ligado al NFC y controles temporales de simulación visual/restauración. Build y cuatro pruebas E2E correctas, incluida consulta simulada de NFC apagado; captura encallada revisada. Prueba física pendiente de próxima APK autorizada.


## Entrega 0.2.0 — 17/11/2026

- Retirados todos los controles temporales del Benchy. NFC apagado/activo se consulta del dispositivo; la animación no altera la lectura.
- 29 pruebas unitarias y 9 recorridos E2E correctos. Compilación web correcta.
- Android compilado correctamente (JDK21, SDK36, Gradle8.14.3). Avisos no bloqueantes de flatDir, formato XML del SDK y API Android obsoleta.
- APK `com.guillecantarero.spoolio`, versión 0.2.0, versionCode 3, minSdk24/targetSdk36.
- Firma APK v2 válida y certificado idéntico al de 0.1.1-nfc. Assets comparados byte a byte con dist; plugin NFC y consulta deviceInfo presentes en DEX.
- APK: `artifacts/Spoolio-0.2.0-debug.apk` y alias `artifacts/Spoolio-debug.apk`.
- SHA256: `3c4ea663754da9ea6ceed2f64aca099642fd7e50bd25e4b1e8072d4cebbadb57`.
- Respaldo anterior conservado en `artifacts/Spoolio-0.1.1-nfc-backup.apk` (local, excluido de Git).
- README y AGENTS actualizados con estado, instalación, traspaso a otro PC y próximos pasos del backend. No hay conexión remota ni migraciones implementadas.
- Pendiente: instalar esta entrega sobre la anterior y verificar físicamente NFC, datos conservados y cambio activado/desactivado en Pixel. La confirmación física previa no sustituye esta prueba.


## Entrega 0.2.1 — 17/11/2026

- APK Android compilada: versión 0.2.1, versionCode 4. Incluye ubicación con pulsación corta/larga, apertura táctil corregida y guardado sin aviso de éxito.
- 29 pruebas unitarias y 11 E2E correctas; build web y Android correctos.
- Assets de APK comparados byte a byte con dist.
- APK: `artifacts/Spoolio-0.2.1-debug.apk`, alias `artifacts/Spoolio-debug.apk`.
- SHA256: `7b4db6aec2228199fb7484cb2974bdf19d80ddbecd2dbf295a406764b13edde8`.
- Se conserva APK 0.2.0 como respaldo. Pendiente de instalación y prueba física en Pixel.

## Cambios web posteriores a 0.2.1 — 17/11/2026

- Escanear sin botón de cancelar durante lectura; Volver a intentar solo tras error. Cancelación interna al salir conservada.
- Build correcto, 29 pruebas unitarias y 12 E2E correctas; nuevo recorrido con puente NFC simulado: fallo por NFC apagado, reintento y ausencia de botones durante lectura.
- No se sincronizó ni generó otra APK. Pendiente de la próxima entrega Android y validación física.

## Preparación Supabase — revisión inicial del 19/11/2026

- Integración de Auth y repositorio asíncrono compilada. Demo local y sus 13 recorridos E2E correctos. Un recorrido adicional con Supabase simulado verifica login, falta de membresía, reintento, persistencia de sesión, guardado fallido sin falso éxito y cierre de sesión.
- Migración ejecutada en PostgreSQL embebido con roles; pruebas de permisos, historial, conflictos, UID e integridad transaccional. Monitor: tres pruebas correctas de lectura mínima, rechazo de secretos y detección de fallos.
- En esa revisión estaban pendientes la migración remota, cuentas y catálogo. El usuario confirmó después esquema, accesos y carga del catálogo; véase el estado actual al principio. Siguen pendientes la prueba autenticada real, el recorrido entre dispositivos, copias automáticas y avisos externos del monitor. No se generó una APK.
