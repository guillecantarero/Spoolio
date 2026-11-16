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
