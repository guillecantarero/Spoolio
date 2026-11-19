# Spoolio

Aplicación Android privada para gestionar el inventario compartido de filamento de impresión 3D de un grupo de amigos.

## Estado — 19/11/2026

**Código web listo para continuar desde casa; no se ha generado otra APK.** La última APK es 0.2.1 local. El código actual añade Supabase, cambio de contraseña, notificaciones flotantes, etiqueta de material más grande y selector de tema SVG en la cabecera de Configuración.

El proyecto remoto ya responde: `sp_health` devuelve `ok` y las consultas anónimas al inventario se rechazan. El usuario confirmó haber creado las cuentas de Guillermo, Juan y Óscar y aplicado sus accesos. Falta verificar con sus sesiones reales el recorrido compartido y el cambio de contraseña. La última consulta de Auth seguía permitiendo nuevos registros: revisar ese ajuste.

El usuario confirma que el catálogo real ya está cargado en Supabase: **270 perfiles, 292 colores y 17 perfiles pendientes**. Fuentes y cobertura en [supabase/catalog](supabase/catalog/README.md). No volver a ejecutar el SQL de reemplazo; las futuras ampliaciones deben ser incrementales.

Para seguir: **[Continuar desde casa](docs/CONTINUAR_EN_CASA.md)**. `.env.local`, APK y firma Android no se suben a Git.

### Última APK conservada

Entrega de pruebas **0.2.1**, Android `versionCode 4` (17/11/2026). APK en `artifacts/Spoolio-0.2.1-debug.apk` (también `artifacts/Spoolio-debug.apk`), excluida de Git. Compilación Android y firma verificadas; 29 pruebas unitarias y 11 E2E correctas. Pendiente de probar esta entrega físicamente en Pixel.

La APK 0.2.1 es una versión funcional de demostración local. Incluye las cinco secciones, catálogo multicolor, muestras, altas manuales, filtros, cambios de ubicación y retirada con historial. Incluye una versión Android de prueba con lectura nativa del UID NFC para crear, asociar y consultar bobinas. Véase [Prueba Android y NFC](docs/ANDROID_NFC.md).

**Por defecto se ejecuta la demo local, sin autenticación real ni sincronización.** El modo Supabase implementado se activa con configuración explícita y requiere configurar URL y clave pública en cada equipo; el proyecto actual ya tiene el esquema inicial según confirmación del usuario; véase [Supabase](docs/SUPABASE.md). Se selecciona un perfil de prueba (Mi perfil, Juan u Óscar). Fablab es una ubicación. Los datos se guardan en este navegador y origen mediante `localStorage`, en la clave separada `spoolio.demo.v1`. Las fechas son del dispositivo.

## Ejecutar

Con Node.js 22 o superior (requerido por Capacitor 8):

```powershell
cd Spoolio
npm ci
npm run dev
```

Abrir la dirección local mostrada por Vite, normalmente `http://127.0.0.1:5173`. Mantener esa terminal abierta. Usar siempre el mismo origen: `localhost` y `127.0.0.1` tienen almacenamientos separados. Esta vista permite desarrollar la interfaz de la futura app Android; la lectura NFC requiere instalar la APK Android.

```powershell
npm run build
npm test
$env:VITE_DATA_MODE='local'
$env:SPOOLIO_TEST_PORT='5198'
$env:CI='1'
npm run test:e2e -- --workers=1 --timeout=60000
Remove-Item Env:VITE_DATA_MODE, Env:SPOOLIO_TEST_PORT, Env:CI
```

Las pruebas de interfaz fuerzan modo local; el recorrido de Auth intercepta su propio servidor simulado. No usan cuentas ni datos reales. Usan Microsoft Edge instalado en Windows, y levantan el servidor local automáticamente. Compilación en `dist/`.

## Probar el recorrido de demostración local

1. Elegir «Mi perfil» en la pantalla de demostración.
2. Pulsar la bobina con + a la derecha del título de Inventario o Mis bobinas → «Crear un filamento nuevo». Guardar marca, material, nombre comercial, tipo y colores. El formulario vuelve al alta de unidad.
3. Elegir ubicación, montada/refill y cantidad aproximada. Guardar sin NFC.
4. Cambiar a Juan desde Configuración → «Cambiar perfil». Abrir la unidad, pulsar la bobina con el nombre de la ubicación y seleccionar Juan. Verificar Mis bobinas y el historial.
5. Cambiar ubicación desde su botón en la ficha; editar la unidad para cambiar perfil, formato o cantidad.
6. Retirarla como agotada. Ya no aparece en las vistas activas. El catálogo y la muestra se mantienen; el historial se consulta en Configuración → Unidades retiradas.
7. Recargar y comprobar que los datos persisten. En Configuración se puede exportar una copia JSON.

Al entrar en un perfil, esta etapa añade una sola vez **ejemplos visuales temporales**: seis perfiles y treinta unidades (diez por persona), para revisar las ocho combinaciones de bobina/refill, un color/multicolor y opaco/translúcido, además de blanco y negro. Están inspirados en familias de Bambu Lab, con colores orientativos y una combinación multicolor translúcida explícitamente ficticia. Configuración → **Eliminar ejemplos visuales** permite limpiarlos sin borrar tus unidades. No se usan UID reales. Véase [Representación de bobinas](docs/REPRESENTACION_BOBINAS.md).

## Arquitectura y límites

- `src/domain.ts`: modelo tipado y operaciones con validación, movimientos y retirada lógica.
- `src/repository.ts`: contrato de repositorio y adaptador local. Guarda la unidad y sus eventos como una única instantánea; usa Web Locks para serializar operaciones entre pestañas del mismo origen y versión de unidad para detectar ediciones obsoletas.
- `src/visualExamples.ts`: lote temporal identificable y eliminable. `src/demo.ts` conserva datos mínimos usados por pruebas de dominio.
- `src/BobinaIcono.tsx`: representación SVG aprobada, con degradados y translucidez.
- Inventario y Mis bobinas permiten alternar entre cuadrícula de tres columnas y lista; la preferencia se conserva.
- `src/main.tsx` y `src/style.css`: interfaz adaptable, formularios y navegación.
- `src/domain.test.ts` y `tests/manual-flow.spec.ts`: pruebas de reglas, persistencia e interfaz.

El guardado de la demo local requiere un navegador con Web Locks en un origen seguro como localhost. Si falla la persistencia no se presenta el cambio como guardado. Borrar los datos del navegador elimina esta demo; la exportación JSON permite conservar una copia, pero todavía no existe importador.

La demo no constituye una barrera de seguridad: todos los perfiles locales son seleccionables. El modo Supabase incluye permisos RLS, fecha de servidor, validación transaccional y autenticación; la validación de operaciones autenticadas en el proyecto real sigue pendiente. Las pruebas locales no la sustituyen. En modo local las ediciones de catálogo no tienen control de versión; en modo remoto se comparan con el perfil original antes de guardar. Las unidades usan versión en ambos modos.

Pendientes: verificar acceso autenticado y operaciones entre cuentas, configurar copias remotas; el usuario confirma el catálogo cargado. El usuario confirmó NFC funcional en el Pixel en la versión anterior; hay que validar esta APK 0.2.1 en el teléfono. Android usa Capacitor 8 y un complemento local limitado a leer UID; no escribe ni descifra etiquetas.

Las herramientas se eligieron consultando la [guía oficial de Vite](https://vite.dev/guide/) y la [integración de Capacitor](https://capacitorjs.com/docs/getting-started). El lockfile fija las versiones instaladas para reproducir esta etapa.

## Abrir el proyecto

Abrir `Spoolio.code-workspace` con Visual Studio Code mediante **Archivo → Abrir área de trabajo desde archivo**.

## Documentación

- [Requisitos y decisiones](docs/REQUISITOS.md): fuente de referencia para desarrollar y ampliar el alcance.
- [Instrucciones de trabajo](AGENTS.md): reglas para mantener la implementación alineada con los requisitos.

## Estructura inicial

```text
Spoolio/
  Spoolio.code-workspace
  AGENTS.md
  README.md
  docs/
    REQUISITOS.md
```

Además de la documentación, el proyecto contiene `src/`, `tests/`, la configuración de TypeScript y Playwright y el lockfile de npm.

## Trabajar desde dos equipos con Git

Clona el repositorio de GitHub en el otro equipo y abre `Spoolio.code-workspace`.
Instala las dependencias con `npm ci` y ejecuta `npm run dev`.

Antes de empezar una sesión, con los cambios anteriores guardados:

```powershell
git pull --ff-only
```

Al terminar:

```powershell
git add .
git commit -m "Describe el cambio realizado"
git push
```

Sube los cambios antes de cambiar de equipo. Si `git pull --ff-only` indica
que las ramas han divergido, revisa los cambios antes de integrarlos; no uses
un push forzado para resolverlo.

Git guarda el código, los requisitos, las referencias visuales y las pruebas.
Los datos de la demo permanecen en el navegador de cada equipo y no se
sincronizan mediante GitHub. Tampoco se incluyen dependencias, compilaciones,
resultados de pruebas ni archivos `.env`.


## Entrega 0.2.1 y continuidad desde casa

### Qué incluye

- Alta manual en las cabeceras de Mis bobinas e Inventario; alta desde catálogo con bobina +.
- Catálogo con hélices, edición mediante lápiz, muestra visual y cambio de muestra dentro del editor.
- Nombres español/inglés, búsqueda en ambos; sólido/gradiente y translucidez independiente mediante botones SVG.
- Editor de bobinas con lista buscable de tres filas, formato carrete/refill y cantidad por niveles de color.
- Escaneo automático al pulsar el botón central, UID de ambas etiquetas, asociación y consulta; sin leer memoria ni escribir etiquetas.
- Benchy blanco en perspectiva con flotación suave; encallado cuando Android indica NFC apagado o no compatible. Sin botones de simulación.
- Configuración con estado NFC real y versión instalada; refresco al volver a la app.
- Modo claro/oscuro, ubicaciones y retirada lógica con historial. Todo sigue siendo local.

La versión anterior con estantería está guardada en el commit `315176e`. La versión actual usa un solo SVG animado. No se ha medido una mejora de tiempo de carga.

### Actualizar el Pixel

1. Exportar una copia JSON desde Configuración antes de instalar.
2. Transferir `artifacts/Spoolio-debug.apk` al móvil e instalar **encima** de la app existente, sin desinstalar ni borrar datos.
3. Comprobar en Configuración: **0.2.1 · Compilación 4**.
4. Probar crear bobina manual, leer ambas etiquetas, volver a escanear, editar, mover y retirar una unidad de prueba.
5. Apagar NFC, entrar en Escanear y comprobar Benchy encallado; activarlo, volver y pulsar «Volver a escanear» si la lectura se detuvo.
6. Cerrar/reabrir y comprobar que conserva unidades y etiquetas. La importación JSON todavía no está implementada.

La firma debe coincidir para conservar la instalación. No desinstalar ante un error de firma: conservar la APK y recuperar la clave debug de este PC por un medio privado. Las claves no van a GitHub. El repositorio no transporta los datos locales ni la APK.

### Abrir en el equipo de casa

```powershell
git clone https://github.com/guillecantarero/Spoolio.git
cd Spoolio
npm ci
npm run dev
```

Si ya está clonado, guardar primero los cambios locales y usar `git pull --ff-only`. Abrir `Spoolio.code-workspace`. Requiere Node 22+; para pruebas E2E, Microsoft Edge en Windows. Si el puerto está ocupado:

```powershell
$env:SPOOLIO_TEST_PORT='5197'
npm run test:e2e -- --workers=1 --timeout=60000
```

Para Android: JDK 21, SDK 36, herramientas de compilación 35/36 y la firma de pruebas existente. Ver [Android y NFC](docs/ANDROID_NFC.md). `.android-tools`, `android/local.properties`, cachés, APK y claves son locales y no se clonan. `scripts/android-debug.ps1` usa las herramientas portátiles si existen; en otro equipo configurar JAVA_HOME y el SDK. No es necesario Android para desarrollar la interfaz web.

### Supabase gratuito: continuidad

El esquema inicial y las cuentas ya fueron configurados por el usuario. La API pública de estado responde y el inventario deniega acceso anónimo. **No repetir la migración inicial ni el bootstrap.** En casa hay que configurar `.env.local` y validar login, permisos y operaciones compartidas con las cuentas reales. El monitor está preparado, pero no instalado en el mini PC.

Seguir [docs/SUPABASE.md](docs/SUPABASE.md). Sin variables la app mantiene la demo local; `.env.example` documenta cómo activar el modo remoto. No hay importación automática del Pixel ni de ejemplos. La APK 0.2.1 no se modifica.

En modo remoto el servidor valida membresía y versiones y guarda historial en la misma transacción. La interfaz refresca periódicamente mientras no está editando. El monitor del otro PC consulta solo una fila de estado pública y no garantiza evitar las pausas del plan gratuito. Las copias y una restauración de prueba deben configurarse antes de cargar inventario real.

Consultar `AGENTS.md`, `docs/REQUISITOS.md`, `docs/VALIDACION.md` y `docs/ANDROID_NFC.md` antes de continuar. No implementar ESP32, compras, estadísticas ni reciclado de etiquetas en esta etapa.

- Incluido en APK 0.2.1: ubicación en ficha con pulsación corta para desplegar botones de personas/Fablab y guardar al elegir; pulsación larga (600 ms) para mover al usuario conectado. Conserva historial, sin movimiento duplicado si ya está allí. Guardado sin aviso de éxito y apertura táctil corregida.

- Próxima versión (código web posterior a APK 0.2.1): Escanear no muestra Cancelar lectura ni otros botones mientras busca una etiqueta. Solo aparece Volver a intentar si la lectura falla (NFC apagado, error o tiempo agotado). Salir cancela internamente. La APK 0.2.1 no incluye este cambio; no generar otra hasta petición explícita.

- Cambio de contraseña disponible en Configuración para cuentas remotas: actual + nueva + confirmación, mediante Auth updateUser con current_password. No requiere migración SQL. Pendiente de próxima APK y prueba con cuenta real.

- Catálogo real preparado en `supabase/catalog/01-reemplazar-pruebas-catalogo.sql`: 270 perfiles verificados, 17 pendientes documentados. Usuario autoriza borrar todos los datos actuales de prueba (catálogo/bobinas/NFC/historial), conservando cuentas y ubicaciones. El usuario confirma la carga remota del catálogo el 19/11/2026. No volver a usar el reemplazo después de cargar datos reales. Fuentes, cobertura y validación en `supabase/catalog/README.md`.
