# Validación de la primera demo local

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
