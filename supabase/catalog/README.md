# Catálogo verificado — 19/11/2026

## Carga completada en Supabase

El usuario confirma la carga el 19/11/2026. `01-reemplazar-pruebas-catalogo.sql` queda como registro de la importación inicial: **no volver a ejecutarlo en el proyecto actual**. Las ampliaciones futuras deben usar SQL incremental.

El script de reemplazo **borra todas las bobinas, etiquetas NFC, eventos, colores y perfiles existentes del único inventario**. Se preparó con autorización del usuario porque todos eran de prueba. Conserva cuentas, miembros y ubicaciones. La operación es atómica: ante error se revierte. Bloquea una segunda carga si encuentra los identificadores de este lote.

El lote contiene **270 perfiles / 292 colores**, sin bobinas físicas; todas las muestras empezaron pendientes. No se ha generado una nueva APK.

## Procedencia y criterio

3dfilamentprofiles.com rechazó la consulta automatizada con 403/429. El usuario autorizó fuentes oficiales Bambu Lab/Winkle. Los hexadecimales importados son valores escritos en tablas oficiales, nunca muestreados de fotos ni inferidos por nombres. La documentación de cada registro está en catalogo-verificado.json. No se presupone que el conjunto equivalga al listado completo de la web bloqueada.

- Se deduplican variantes con carrete/refill y pesos: son un mismo perfil. TPU 75A se distingue como 2.85 mm porque esa es la referencia publicada.
- PLA Glow usa el color diurno que especifica su tabla.
- Los efectos Marble, Galaxy, Sparkle, Wood y Metal se conservan en variante; el SVG representa el color base, no partículas o reflejos.
- Sólido/gradiente/multicolor y translucidez se guardan por perfil. PC Transparent y Clear Black se representan translúcidos.
- TPU 90A Blaze y Frozen son gradientes; Silk conserva multicolor simultáneo frente a gradiente según la ficha.
- El PDF de Pure pierde caracteres con un extractor: se contrastó con otro y se renderizó. Se corrige la errata oficial Absolute Balck a Absolute Black con la ficha del producto.
- Silk Multi-Color tiene una tabla rasterizada: se transcribieron visualmente los códigos impresos. Se mantiene el orden escrito, incluso cuando el orden visual de las muestras es distinto.
- PETG HF moderno redirige a Matte: se usó la tabla histórica oficial Shopify para HF, sin confundir familias.
- Los nombres ES proceden de la tienda española cuando pueden vincularse por código de fabricante. Algunos nombres comerciales siguen en inglés incluso allí. Cuando no se localiza traducción, se conserva el original, sin presentarlo como una traducción oficial.

## Cobertura

| Familia | Perfiles importados |
| --- | ---: |
| ABS Basic | 12 |
| ABS GF | 6 |
| ASA Basic | 6 |
| PA6 GF | 8 |
| PC Basic | 4 |
| PC FR | 3 |
| PETG Basic | 13 |
| PETG CF | 6 |
| PETG HF | 14 |
| PETG Matte | 8 |
| PETG Translucent | 8 |
| PLA Basic | 30 |
| PLA Basic Gradient | 8 |
| PLA CF | 7 |
| PLA Galaxy | 4 |
| PLA Glow | 5 |
| PLA Marble | 2 |
| PLA Matte | 25 |
| PLA Metal | 5 |
| PLA Palette | 5 |
| PLA Pure | 5 |
| PLA Silk Multi-Color | 10 |
| PLA Silk+ | 13 |
| PLA Sparkle | 6 |
| PLA Tough+ | 7 |
| PLA Translucent | 10 |
| PLA Wood | 6 |
| TPU 75A · 2.85 mm | 10 |
| TPU 85A | 5 |
| TPU 90A | 6 |
| TPU 95A HF | 6 |
| TPU for AMS | 7 |

## Pendientes excluidos de la query

No se insertan con colores supuestos. Tener un color llamado Black o White no demuestra un hexadecimal exacto.

| Marca / familia | Color | Falta | Fuente |
| --- | --- | --- | --- |
| Bambu Lab TPU 90A | Grape Jelly | Confirmar translucidez por color: la ficha describe varios acabados sin identificarlos inequívocamente en texto. | [Ficha](https://store.bblcdn.com/s1/default/7e2c8bbbf2ff4c6996778bbb577bae13/Bambu_TPU_90A_Hex_Code_Table.pdf) |
| Bambu Lab TPU 90A | Crystal Blue | Confirmar translucidez por color: la ficha describe varios acabados sin identificarlos inequívocamente en texto. | [Ficha](https://store.bblcdn.com/s1/default/7e2c8bbbf2ff4c6996778bbb577bae13/Bambu_TPU_90A_Hex_Code_Table.pdf) |
| Bambu Lab PETG Translucent | Clear | No emparejado con tabla HEX; revisar antes de importar. | [Ficha](https://eu.store.bambulab.com/products/petg-translucent) |
| Bambu Lab ASA Aero | White | Código HEX de este producto no localizado en fuentes oficiales consultadas. No se deduce del nombre del color. | [Ficha](https://eu.store.bambulab.com/products/asa-aero) |
| Bambu Lab ASA CF | Black | Código HEX de este producto no localizado en fuentes oficiales consultadas. No se deduce del nombre del color. | [Ficha](https://eu.store.bambulab.com/products/asa-cf) |
| Bambu Lab PA6 CF | Black | Código HEX de este producto no localizado en fuentes oficiales consultadas. No se deduce del nombre del color. | [Ficha](https://eu.store.bambulab.com/products/pa6-cf) |
| Bambu Lab PAHT CF | Black | Código HEX de este producto no localizado en fuentes oficiales consultadas. No se deduce del nombre del color. | [Ficha](https://eu.store.bambulab.com/products/paht-cf) |
| Bambu Lab PET CF | Black | Código HEX de este producto no localizado en fuentes oficiales consultadas. No se deduce del nombre del color. | [Ficha](https://eu.store.bambulab.com/products/pet-cf) |
| Bambu Lab PPS CF | Black | Código HEX de este producto no localizado en fuentes oficiales consultadas. No se deduce del nombre del color. | [Ficha](https://eu.store.bambulab.com/products/pps-cf) |
| Bambu Lab PPA CF | Black | Código HEX de este producto no localizado en fuentes oficiales consultadas. No se deduce del nombre del color. | [Ficha](https://eu.store.bambulab.com/products/ppa-cf) |
| Winkle PLA HD Texture | Arena | Código HEX no publicado en la ficha consultada; solo imágenes de textura. | [Ficha](https://winkle.shop/filamento-impresora-3d/pla/filamento-pla-hd/pla-hd-texture/) |
| Winkle PLA HD Texture | Mármol | Código HEX no publicado en la ficha consultada; solo imágenes de textura. | [Ficha](https://winkle.shop/filamento-impresora-3d/pla/filamento-pla-hd/pla-hd-texture/) |
| Winkle PLA HD Texture | Ladrillo | Código HEX no publicado en la ficha consultada; solo imágenes de textura. | [Ficha](https://winkle.shop/filamento-impresora-3d/pla/filamento-pla-hd/pla-hd-texture/) |
| Winkle PLA HD Texture | Mármol Amarillo | Código HEX no publicado en la ficha consultada; solo imágenes de textura. | [Ficha](https://winkle.shop/filamento-impresora-3d/pla/filamento-pla-hd/pla-hd-texture/) |
| Winkle PLA HD Texture | Granito Azul | Código HEX no publicado en la ficha consultada; solo imágenes de textura. | [Ficha](https://winkle.shop/filamento-impresora-3d/pla/filamento-pla-hd/pla-hd-texture/) |
| Winkle PLA HD Texture | Cuarzo | Código HEX no publicado en la ficha consultada; solo imágenes de textura. | [Ficha](https://winkle.shop/filamento-impresora-3d/pla/filamento-pla-hd/pla-hd-texture/) |
| Winkle PLA HD Texture | Cemento | Código HEX no publicado en la ficha consultada; solo imágenes de textura. | [Ficha](https://winkle.shop/filamento-impresora-3d/pla/filamento-pla-hd/pla-hd-texture/) |

## Nombres sin traducción ES localizada

Estos perfiles conservan el nombre EN en ambos campos. Se pueden traducir después sin alterar su hexadecimal.

- ABS Basic: Purple
- PETG HF: Yellow
- PETG HF: Orange
- PETG HF: Green
- PETG HF: Red
- PETG HF: Blue
- PETG HF: Black
- PETG HF: White
- PETG HF: Cream
- PETG HF: Lime Green
- PETG HF: Forest Green
- PETG HF: Lake Blue
- PETG HF: Peanut Brown
- PETG HF: Gray
- PETG HF: Dark Gray

## Fuentes de color

Cada enlace está asociado a sus filas en el JSON. Consultadas el 19/11/2026.

- [Tabla 1](https://bambulab-eu.myshopify.com/products/petg-hf)
- [Tabla 2](https://cdn.shopify.com/s/files/1/0584/7236/6216/files/Bambu_PLA_Matte_Hex_Code.pdf)
- [Tabla 3](https://store.bblcdn.com/s1/default/3d989ddc07694c378496784834947125/Bambu_PLA_Tough_Hex_Code_Table.pdf)
- [Tabla 4](https://store.bblcdn.com/s1/default/7e2c8bbbf2ff4c6996778bbb577bae13/Bambu_TPU_90A_Hex_Code_Table.pdf)
- [Tabla 5](https://store.bblcdn.com/s1/default/7e3a5dec148b468d862d96593d01d624/PLA_Silk_Mutil-color_Hex_Code_Table.pdf)
- [Tabla 6](https://store.bblcdn.com/s7/default/1084369ef84345bbaa5d704a492954e0/Bambu_PLA_Basic_Hex_Code.pdf)
- [Tabla 7](https://store.bblcdn.com/s7/default/21e9ad53c97a46dd9bd58e5dd1bc93ac/PLA_Basic_Gradient_Hex_Code_Table.pdf)
- [Tabla 8](https://store.bblcdn.com/s7/default/2a16583d2dc6404ea2ebcdf192441852/PLA_Sparkle_Hex_Code_Table.pdf)
- [Tabla 9](https://store.bblcdn.com/s7/default/2b5c536e5f824b6d80484c3bcfdfbb17/PETG-CF_Hex_Code_Table.pdf)
- [Tabla 10](https://store.bblcdn.com/s7/default/312a35d5cdce4fc5a76692955b493a82/PLA_Wood_Hex_Code_Table.pdf)
- [Tabla 11](https://store.bblcdn.com/s7/default/59bf6c3e0af14df380b9c69c40b02772/PA6-GF_Hex_Code_Table.pdf)
- [Tabla 12](https://store.bblcdn.com/s7/default/5c46875459bc4a27986707f49560a961/PETG_Translucent_Hex_Code_Table.pdf)
- [Tabla 13](https://store.bblcdn.com/s7/default/5e89111c48cb487f88b561ef16aa9175/PLA_Metal_Hex_Code_Table.pdf)
- [Tabla 14](https://store.bblcdn.com/s7/default/6ca923cd4e3242448324c63505e91dad/PLA_Translucent_Hex_Code_Table.pdf)
- [Tabla 15](https://store.bblcdn.com/s7/default/6ec4738ccb144e8880cfec81a4cb6665/TPU_95A_HF_Hex_Code_Table.pdf)
- [Tabla 16](https://store.bblcdn.com/s7/default/7260019fb4b243ce9b1963d51fc24e83/PETG_Basic_Hex_Code_Table.pdf)
- [Tabla 17](https://store.bblcdn.com/s7/default/7d0175cb776b415e94eec1a8c7ffbf54/ABS-GF_Hex_Code_Table.pdf)
- [Tabla 18](https://store.bblcdn.com/s7/default/89394d4bbaff4f519bf5b9c3e7c7fcac/PLA_Marble_Hex_Code_Table.pdf)
- [Tabla 19](https://store.bblcdn.com/s7/default/8a89cc11c9ce4421a9593f9ee9580982/Bambu_PLA_Palette_Hex_Code.pdf)
- [Tabla 20](https://store.bblcdn.com/s7/default/8aaeedf46e504db4afa2fc13cfbfae0a/PLA_Silk_Upgrade_Hex_Code_Table.pdf)
- [Tabla 21](https://store.bblcdn.com/s7/default/8b59c35ced5c4b848affd97e0664e12c/ASA_Hex_Code_Table.pdf)
- [Tabla 22](https://store.bblcdn.com/s7/default/98df744e02e04d8599956b4fe8b19ff4/PLA-CF_Hex_Code_Table.pdf)
- [Tabla 23](https://store.bblcdn.com/s7/default/9b109944ad61471eb35d46e6263a28ff/Bambu_PETG_Matte_Hex_Code_Table.pdf)
- [Tabla 24](https://store.bblcdn.com/s7/default/9fc931c1464542df9c5fc5d9f6f9bf4b/PC_FR_Hex_Code_Table.pdf)
- [Tabla 25](https://store.bblcdn.com/s7/default/a1146f73c7cd41d3ad746819620096ac/Bambu_TPU_75A-hex_code.pdf)
- [Tabla 26](https://store.bblcdn.com/s7/default/a7d9f82d874c453cbbc1bb0efb82dd42/Bambu_ABS_Hex_Code_(1).pdf)
- [Tabla 27](https://store.bblcdn.com/s7/default/ac3ca83e470c4e39873463ae1f8ac7bb/TPU_for_AMS_Hex_Code_Table.pdf)
- [Tabla 28](https://store.bblcdn.com/s7/default/bbc0a351ffca4503968910ba98cae27d/PLA_Glow_Hex_Code_Table.pdf)
- [Tabla 29](https://store.bblcdn.com/s7/default/c910d98d275f470ba1a3eb5639d7c81f/Bambu_TPU_85A_Hex_Code.pdf)
- [Tabla 30](https://store.bblcdn.com/s7/default/cb680ec8a366477b9379e2fe1eba98e9/Bambu_PLA_Pure_Hex_Code.pdf)
- [Tabla 31](https://store.bblcdn.com/s7/default/dcb05d280a474fb095adfee359c13574/PLA_Galaxy_Hex_Code_Table.pdf)
- [Tabla 32](https://store.bblcdn.com/s7/default/e6a6c5416fc440d88639172ff9e546ac/PC_Hex_Code_Table.pdf)

## Validación ejecutada

`node scripts/catalog/verify-import.mjs`: aplica la migración real en PGlite, crea datos de prueba con bobina/UID/historial y ejecuta esta misma query. Verifica eliminación, preservación de cuentas/ubicaciones, los 270 perfiles y orden exacto de colores mediante sp_snapshot, reversión de un fallo tras el borrado y rechazo de la segunda ejecución. No sustituye la comprobación del usuario en su proyecto remoto.

Regenerar SQL sin cambiar datos: `node scripts/catalog/generate-import.mjs`. No reutilizar la query de reemplazo para futuras ampliaciones: deben ser inserciones incrementales.
