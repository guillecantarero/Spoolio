# Representación SVG y ejemplos locales

## Diseño

`src/BobinaIcono.tsx` adapta directamente el SVG aprobado, sin imágenes raster ni bibliotecas nuevas. Conserva la geometría y el orden de capas. Cada instancia genera sus propios identificadores con `useId`.

El relleno es uniforme o un degradado con colores equidistantes. El damero de 16 unidades se recorta con la misma silueta y exclusión del agujero que el archivo original. Solo el relleno de color usa opacidad 0,65 cuando es translúcido. Los laterales permanecen opacos. Los colores vacíos o inválidos tienen respaldo gris.

El antiguo componente `Swatch` ahora delega en este SVG; no mantiene una segunda representación de bobinas. Inventario/Mis bobinas comparten los modos cuadrícula (tres columnas) y lista. La preferencia se guarda en `spoolio.inventoryView`.

## Compatibilidad de datos

Se mantiene la lista ordenada `colors` y el campo `mounted`. Se añade `Filament.translucent`, obligatorio en los tipos y validado como booleano. Al leer datos locales antiguos se asigna `false` cuando falta el campo; la siguiente escritura persiste la migración junto con el resto de la instantánea. No se pierde ningún color ni nombre.

No hay base de datos externa ni migración SQL pendiente de ejecutar ahora. Al incorporar PostgreSQL, el campo equivalente será booleano no nulo con valor predeterminado false.

### Nombres bilingües y propiedades visuales

El campo `name` guarda el nombre español y `nameEn` su traducción inglesa, opcional para compatibilidad. No son dos perfiles distintos. La preferencia `spoolio.nameLanguage` selecciona cuál mostrar (español por defecto); si no existe traducción se usa el nombre disponible. La búsqueda indexa ambos nombres y normaliza mayúsculas, acentos y espacios. Marca, material y variante comercial no se traducen automáticamente.

Los perfiles locales antiguos conservan su nombre y reciben `nameEn: ''`. Solo los ejemplos conocidos sin cambios de nombre reciben traducciones preparadas. La adaptación se realiza al leer y se persiste con la siguiente escritura. No se requiere SQL ahora; el futuro esquema podrá usar `nombre_es` y `nombre_en`, con preferencia de idioma en el perfil de usuario si se desea sincronizarla entre dispositivos.

La apariencia se controla con `colors`, `distribution` y `translucent`, independientemente de los nombres. Un perfil puede ser unicolor translúcido, multicolor opaco o multicolor translúcido. El formato montada/refill sigue siendo propio de la unidad física. Una futura tabla de familias podrá facilitar valores iniciales (por ejemplo PLA Translucent → translúcido), sin inferencias frágiles a partir del nombre ni cambios automáticos a unidades existentes.

Actualmente la característica óptica implementada es opaco/translúcido, con damero y opacidad visual fija. No hay un tercer estado óptico «transparente» ni simulación física de transparencia: cualquier distinción adicional requerirá definir su representación.

## Ejemplos temporales

Al entrar en un perfil, se incorporan una sola vez seis perfiles y treinta unidades de prueba: diez para cada persona, incluyendo las ocho combinaciones y extremos blanco/negro. Los datos ya existentes se conservan. Las nuevas filas llevan `demoSet: visual-svg-v1`; el marcador `visualDemoInitialized` impide duplicarlas o recrearlas después de limpiarlas.

Configuración → **Eliminar ejemplos visuales** elimina solo las unidades etiquetadas y sus eventos. Los perfiles de prueba se conservan si una unidad creada por el usuario todavía los utiliza. El resto de unidades y su historial permanecen intactos. No se usan UID reales ni simulación NFC.

Fuentes para la inspiración:

- [Tabla oficial PLA Basic](https://store.bblcdn.eu/s8/default/903b60b06ac142e9b1b49ad53cfa4c82/Bambu_PLA_Basic_Hex_Code.pdf): Orange `#FF6A13`, Jade White `#FFFFFF`, Black `#000000`.
- [PETG Translucent en la tienda Bambu Lab](https://bambulab-eu.myshopify.com/products/petg-translucent): familia y nombre Translucent Orange. El hexadecimal usado en esta demo es orientativo.
- El ejemplo Silk Multicolor es ilustrativo, con los colores del diseño adjunto, no una reproducción certificada del producto. **Aurora multicolor translúcido es ficticio**, con marca «Demo visual».

Las imágenes son indicadores visuales, no una predicción del color impreso o una medición de transmisión de luz.
