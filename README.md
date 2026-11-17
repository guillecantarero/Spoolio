# Spoolio

Aplicación Android privada para gestionar el inventario compartido de filamento de impresión 3D de un grupo de amigos.

## Estado

Entrega de pruebas **0.2.0**, Android `versionCode 3` (17/11/2026). APK en `artifacts/Spoolio-0.2.0-debug.apk` (también `artifacts/Spoolio-debug.apk`), excluida de Git. Compilación Android y firma verificadas; 29 pruebas unitarias y 9 E2E correctas. Pendiente de probar esta entrega físicamente en Pixel.

Primera versión funcional de demostración local. Incluye las cinco secciones, catálogo multicolor, muestras, altas manuales, filtros, cambios de ubicación y retirada con historial. Incluye una versión Android de prueba con lectura nativa del UID NFC para crear, asociar y consultar bobinas. Véase [Prueba Android y NFC](docs/ANDROID_NFC.md).

**No hay autenticación real ni sincronización entre dispositivos.** Se selecciona un perfil de prueba (Mi perfil, Juan u Óscar). Fablab es una ubicación. Los datos se guardan en este navegador y origen mediante `localStorage`, en la clave separada `spoolio.demo.v1`. Las fechas son del dispositivo.

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
npm run test:e2e
```

Las pruebas de interfaz usan Microsoft Edge instalado en Windows, y levantan el servidor local automáticamente. Compilación en `dist/`.

## Probar el recorrido

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

El guardado requiere un navegador con Web Locks en un origen seguro como localhost. Si falla la persistencia no se presenta el cambio como guardado. Borrar los datos del navegador elimina esta demo; la exportación JSON permite conservar una copia, pero todavía no existe importador.

La demo no constituye una barrera de seguridad: todos los perfiles locales son seleccionables. Los permisos reales, RLS, fecha de servidor, validación de operaciones y autenticación se implementarán en el backend. La validación local no los sustituye. Las ediciones de catálogo entre pestañas no tienen todavía control de versión; el control de conflictos se aplica a unidades y movimientos.

Pendientes: conexión Supabase/servidor, migraciones SQL y cuentas reales. El usuario confirmó NFC funcional en el Pixel en la versión anterior; hay que validar esta APK 0.2.0 en el teléfono. Android usa Capacitor 8 y un complemento local limitado a leer UID; no escribe ni descifra etiquetas.

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


## Entrega 0.2.0 y continuidad desde casa

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
3. Comprobar en Configuración: **0.2.0 · Compilación 3**.
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

### Próximo paso: base de datos (todavía no implementada)

La decisión vigente es **Supabase (PostgreSQL + Auth)** provisional, migrable más adelante al NUC. Si se prefiere alojarlo directamente en el NUC, concretar ese cambio antes de crear infraestructura. No hay proyecto Supabase configurado en el código, cliente instalado, migraciones SQL ni variables de entorno consumidas; la APK 0.2.0 NO se conectará automáticamente al crear una base de datos.

Orden recomendado para la siguiente sesión:

1. Confirmar destino y acceso al proyecto. Configurar URL y clave pública/publishable en variables locales; nunca incluir `service_role`, contraseñas o claves privadas en el cliente ni Git.
2. Crear migraciones versionadas para inventario, perfiles/cuentas, miembros, ubicaciones, filamentos, colores ordenados, bobinas, UID y eventos. Usar el modelo y relaciones de `docs/REQUISITOS.md` como referencia.
3. Incorporar Auth con correo/contraseña y miembros autorizados (los tres usuarios). Fablab es ubicación, no usuario. Políticas RLS por inventario; probar acceso permitido y rechazado.
4. UID único normalizado por inventario, incluso para bobinas retiradas. Toda unidad pertenece a un perfil del catálogo; las ubicaciones no significan propiedad. Traslados/ediciones/retirada y eventos deben ser transaccionales, con fecha del servidor y control de concurrencia.
5. Refactorizar `Repository.read()` (actualmente síncrono) y la carga de `src/main.tsx` para acceso asíncrono. Sustituir `LocalDemoRepository` por adaptador remoto sin simular sincronización. Añadir estados de carga/error; mostrar guardado solo tras confirmación del servidor.
6. Definir con el usuario si se importan las unidades locales del Pixel; exportarlas antes. No subir automáticamente ejemplos visuales ni sustituir datos reales. Preservar colores, idiomas, muestras, formato, niveles de cantidad, UID e historial.
7. Probar entre dos cuentas/dispositivos y ante cambios simultáneos. Después generar otra APK cuando se solicite y validar en Pixel.

Consultar `AGENTS.md`, `docs/REQUISITOS.md`, `docs/VALIDACION.md` y `docs/ANDROID_NFC.md` antes de continuar. No implementar ESP32, compras, estadísticas ni reciclado de etiquetas en esta etapa.
