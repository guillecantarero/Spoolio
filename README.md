# Spoolio

Aplicación Android privada para gestionar el inventario compartido de filamento de impresión 3D de un grupo de amigos.

## Estado

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
2. Pulsar el botón octogonal central → «Añadir manualmente» → «Crear un filamento nuevo». Guardar marca, material, nombre comercial, tipo y colores. El formulario vuelve al alta de unidad.
3. Elegir ubicación, montada/refill y cantidad aproximada. Guardar sin NFC.
4. Cambiar a Juan desde Configuración → «Cambiar perfil». Abrir la unidad, pulsar la bobina con el nombre de la ubicación y seleccionar Juan. Verificar Mis bobinas y el historial.
5. Editar la unidad para moverla a Fablab o cambiar formato/cantidad.
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

Pendientes: conexión Supabase/servidor, migraciones SQL, cuentas reales y validación física de NFC en el Pixel. Android usa Capacitor 8 y un complemento local limitado a leer UID; no escribe ni descifra etiquetas.

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
