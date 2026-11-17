# Prueba Android y NFC

Entrega actual: **0.2.0**, código de versión **3**.

## Alcance

APK de prueba local: selecciona un perfil demo; no hay autenticación real ni
sincronización. Los datos viven en el almacenamiento de esta instalación Android,
separado del navegador del PC. No desinstales ni borres datos para actualizar si
quieres conservarlos. Una actualización debe usar el mismo identificador y firma.

Se lee únicamente `Tag.getId()` con Android Reader Mode y `FLAG_READER_SKIP_NDEF_CHECK`.
No se escribe la etiqueta, no se descifra y no se lee su memoria. Marca, material y
color se eligen en el catálogo: no se extraen automáticamente de Bambu.

## Instalación sin USB

1. Pasa `Spoolio-debug.apk` al Pixel por el medio que prefieras (Drive, transferencia local, etc.).
2. Abre el archivo en el móvil y permite instalar aplicaciones desde esa fuente si Android lo solicita.
3. Abre Spoolio y selecciona tu perfil. Activa NFC en los ajustes del Pixel.

Es una compilación debug para pruebas personales, no una versión de distribución.

## Recorrido de prueba física

1. Pulsa el botón central (la lectura empieza automáticamente) y acerca un lateral de la bobina a la zona NFC del Pixel.
2. Si es nueva, pulsa **Crear bobina con esta etiqueta**. Selecciona el filamento, ubicación,
   formato y cantidad. Puedes crear un perfil si no existe; se conserva el UID leído.
3. Pulsa el botón de circuito NFC con + (**Leer segunda etiqueta**) y acerca el otro lateral. Si falla, continúa sin ella.
   También puedes hacer un alta manual desde la bobina con + de Inventario/Mis bobinas, con cero etiquetas y añadirlas después desde la ficha.
4. Guarda. Vuelve a **Escanear**: cualquiera de las etiquetas asociadas debe abrir la ficha.
5. Cierra y abre la app y vuelve a escanear para comprobar persistencia.
6. Prueba una etiqueta desconocida de una bobina ya registrada: elige **Asociar a una bobina existente**.
   No crees otra unidad para la segunda etiqueta.
7. Comprueba NFC desactivado, cancelar lectura y no detectar una etiqueta durante 30 segundos.
8. Retira una unidad de prueba y escanea: debe mostrar su ficha retirada y conservar sus etiquetas.

La lectura requiere la app abierta y pulsar Escanear. No se implementa apertura
automática en segundo plano. Una lectura no cambia ubicación ni otros datos.

## Compilar desde otro equipo

Requisitos: Node.js 22+, JDK 21 y Android SDK (plataforma 36 y build-tools 35.0.0; Gradle lo instala si falta).
Android Studio puede instalar y gestionar el SDK. Configura `JAVA_HOME` y el SDK en
`android/local.properties` (archivo local excluido de Git).

```powershell
npm ci
npm run android:sync
cd android
.\gradlew.bat :app:assembleDebug --max-workers=1 --no-daemon --no-watch-fs
```

Resultado: `android/app/build/outputs/apk/debug/app-debug.apk`.
`npm run android:open` abre el proyecto en Android Studio si está instalado.

En Windows, `powershell -File scripts/android-debug.ps1` prepara, compila y copia la APK a `artifacts/Spoolio-debug.apk`, deteniéndose si falla algún paso.

Las herramientas portátiles de este PC están en `.android-tools/`, excluidas de Git.
La firma debug se conserva localmente; no subas claves al repositorio. Para generar
actualizaciones instalables desde otro PC será necesario reutilizar esa firma de
forma privada o configurar una firma de pruebas estable.

## Verificación y límites

Las pruebas de dominio verifican UID, duplicados, vínculo posterior, versión e historial.
`tests/nfc-flow.spec.ts` sustituye el lector **solo en las pruebas** para comprobar alta,
dos etiquetas, ficha y persistencia. No demuestra que el hardware NFC funcione.
El usuario confirmó que la lectura NFC funciona en el Pixel el 17/11/2026. Los casos adicionales de cancelación, incidencias y retirada deben verificarse según el recorrido anterior.

Referencias: [Capacitor Android](https://capacitorjs.com/docs/android),
[complementos Android](https://capacitorjs.com/docs/plugins/android),
[Android NfcAdapter](https://developer.android.com/reference/android/nfc/NfcAdapter).
