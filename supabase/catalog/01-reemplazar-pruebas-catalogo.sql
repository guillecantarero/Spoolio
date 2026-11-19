-- Spoolio · catálogo verificado 2026-11-19
-- EJECUTAR UNA SOLA VEZ en Supabase SQL Editor como administrador.
-- BORRA TODO el catálogo, bobinas, UID NFC e historial del único inventario.
-- Autorizado por el usuario: todos los datos actuales son de prueba.
-- CONSERVA cuentas Auth, miembros, ubicaciones, inventario, funciones y políticas.
-- Carga 270 perfiles; NO crea bobinas. Muestras inicialmente pendientes.
-- Fuentes y exclusiones: supabase/catalog/README.md y catalogo-verificado.json.
-- No ejecutar sobre inventarios con datos reales. Ante cualquier error: ROLLBACK;
BEGIN;
CREATE TEMP TABLE spoolio_catalog_import ON COMMIT DROP AS
SELECT * FROM jsonb_to_recordset($catalog$
[
  {
    "id": "b6c42470-b9f6-5129-a436-8a8125b1d174",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "GF",
    "name": "Blanco",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "5fa0b0db-9a69-5461-8fb8-25915b6611eb",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "GF",
    "name": "Gris",
    "nameEn": "Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#C6C6C6"
    ]
  },
  {
    "id": "6b8bc7c3-569a-5b63-aa8d-bf220f6dd594",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "GF",
    "name": "Naranja",
    "nameEn": "Orange",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F48438"
    ]
  },
  {
    "id": "e49cf7e1-8ef2-5b79-973c-85d692c5d97e",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "GF",
    "name": "Rojo",
    "nameEn": "Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#E83100"
    ]
  },
  {
    "id": "9245864c-2021-503b-9096-fc315a7d06f1",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "GF",
    "name": "Azul",
    "nameEn": "Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#0C3B95"
    ]
  },
  {
    "id": "90b67c21-4c4d-582c-b9c6-05c4dadd328c",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "GF",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "b13b4a61-3093-56e1-930b-fbbd6c599bb8",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "Basic",
    "name": "Blanco",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "cb4c164c-9713-5727-a77b-fc65cc4a5a25",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "Basic",
    "name": "Bambu Green",
    "nameEn": "Bambu Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#00AE42"
    ]
  },
  {
    "id": "3c7af25d-eca0-5a0b-8d52-44127d621a77",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "Basic",
    "name": "Oliva",
    "nameEn": "Olive",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#789D4A"
    ]
  },
  {
    "id": "6c0b2b4e-82f1-5d6a-8401-a144914e4855",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "Basic",
    "name": "Azure",
    "nameEn": "Azure",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#489FDF"
    ]
  },
  {
    "id": "ec4a11ec-1e37-51ad-8f62-d1114ab717b9",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "Basic",
    "name": "Azul Marino",
    "nameEn": "Navy Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#0C2340"
    ]
  },
  {
    "id": "4937c299-ab3d-52e5-9830-83c3e91d114e",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "Basic",
    "name": "Azul",
    "nameEn": "Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#0A2CA5"
    ]
  },
  {
    "id": "9df84b44-f037-56cb-bf0a-37cc42ae2aea",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "Basic",
    "name": "Tangerine Yellow",
    "nameEn": "Tangerine Yellow",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFC72C"
    ]
  },
  {
    "id": "2d9b263d-4ee2-5d12-8e6f-a4bc53f1c8fb",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "Basic",
    "name": "Naranja",
    "nameEn": "Orange",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FF6A13"
    ]
  },
  {
    "id": "d58c8d3f-cbb6-521e-89b1-8f9ac306c1a9",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "Basic",
    "name": "Rojo",
    "nameEn": "Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#D32941"
    ]
  },
  {
    "id": "5579c604-d0d3-5a8b-a280-9654c4298532",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "Basic",
    "name": "Purple",
    "nameEn": "Purple",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#AF1685"
    ]
  },
  {
    "id": "c6e6ea96-cfce-5495-804f-c86e165cf890",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "Basic",
    "name": "Plata",
    "nameEn": "Silver",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#87909A"
    ]
  },
  {
    "id": "efb6a9af-5bfc-58c7-9edc-a2d3da64e8b5",
    "brand": "Bambu Lab",
    "material": "ABS",
    "variant": "Basic",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "a0fee602-9041-5404-bcaf-38b08e6e9606",
    "brand": "Bambu Lab",
    "material": "ASA",
    "variant": "Basic",
    "name": "Blanco",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFAF2"
    ]
  },
  {
    "id": "cffabbb2-057a-5121-92b6-1d039dd603b5",
    "brand": "Bambu Lab",
    "material": "ASA",
    "variant": "Basic",
    "name": "Gris",
    "nameEn": "Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#8A949E"
    ]
  },
  {
    "id": "cb408811-8717-5ac6-a665-9db4350c496f",
    "brand": "Bambu Lab",
    "material": "ASA",
    "variant": "Basic",
    "name": "Rojo",
    "nameEn": "Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#E02928"
    ]
  },
  {
    "id": "8483c51b-ac0c-5d39-a7da-76fe193602ac",
    "brand": "Bambu Lab",
    "material": "ASA",
    "variant": "Basic",
    "name": "Verde",
    "nameEn": "Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#00A6A0"
    ]
  },
  {
    "id": "8753a98a-a110-5570-a0ce-b18df504e49f",
    "brand": "Bambu Lab",
    "material": "ASA",
    "variant": "Basic",
    "name": "Azul",
    "nameEn": "Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#2140B4"
    ]
  },
  {
    "id": "737f8d41-f92d-52fe-ad19-07383b0cccbf",
    "brand": "Bambu Lab",
    "material": "ASA",
    "variant": "Basic",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "de97581f-f8cf-5e67-8769-513f3fccb353",
    "brand": "Bambu Lab",
    "material": "PA6",
    "variant": "GF",
    "name": "Blanco",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#EAEAE4"
    ]
  },
  {
    "id": "80a20da7-5709-5223-b381-1a34a7588dc9",
    "brand": "Bambu Lab",
    "material": "PA6",
    "variant": "GF",
    "name": "Azul",
    "nameEn": "Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#75AED8"
    ]
  },
  {
    "id": "57966711-c96b-53c3-a7f4-31d3e79a85e5",
    "brand": "Bambu Lab",
    "material": "PA6",
    "variant": "GF",
    "name": "Naranja",
    "nameEn": "Orange",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FF4800"
    ]
  },
  {
    "id": "e69c7a3d-3501-598c-8d5d-0dd209b00f8c",
    "brand": "Bambu Lab",
    "material": "PA6",
    "variant": "GF",
    "name": "Marrón",
    "nameEn": "Brown",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#5B492F"
    ]
  },
  {
    "id": "80b63e7c-f52e-5c2a-99cc-f57695f7e5b7",
    "brand": "Bambu Lab",
    "material": "PA6",
    "variant": "GF",
    "name": "Amarillo",
    "nameEn": "Yellow",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFCE00"
    ]
  },
  {
    "id": "c0b7d89a-14e4-52dc-a496-c9ec0f8a2672",
    "brand": "Bambu Lab",
    "material": "PA6",
    "variant": "GF",
    "name": "Lima",
    "nameEn": "Lime",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#C5ED48"
    ]
  },
  {
    "id": "7aad5963-e97f-5edf-86e8-0648bcf18737",
    "brand": "Bambu Lab",
    "material": "PA6",
    "variant": "GF",
    "name": "Gris",
    "nameEn": "Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#353533"
    ]
  },
  {
    "id": "2598571a-783f-557f-8b11-f5730a65916c",
    "brand": "Bambu Lab",
    "material": "PA6",
    "variant": "GF",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "1040fa87-f331-536f-a700-79d0a25d9a24",
    "brand": "Bambu Lab",
    "material": "PC",
    "variant": "Basic",
    "name": "Blanco",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "337cb501-569f-5b7d-a4dd-8eabafdee942",
    "brand": "Bambu Lab",
    "material": "PC",
    "variant": "Basic",
    "name": "Translúcido",
    "nameEn": "Transparent€",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "eb994480-6144-54f7-b92f-a8f713b03d33",
    "brand": "Bambu Lab",
    "material": "PC",
    "variant": "Basic",
    "name": "Negro transparente",
    "nameEn": "Clear Black",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#686865"
    ]
  },
  {
    "id": "83b39058-2eea-5929-ab9d-05388eb91c03",
    "brand": "Bambu Lab",
    "material": "PC",
    "variant": "Basic",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "65f6995f-d448-5f7f-8fb4-b38addc9541b",
    "brand": "Bambu Lab",
    "material": "PC",
    "variant": "FR",
    "name": "Blanco",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "104edd24-3ff2-5b29-b1f2-2972edfb10da",
    "brand": "Bambu Lab",
    "material": "PC",
    "variant": "FR",
    "name": "Gris",
    "nameEn": "Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#A8A8AA"
    ]
  },
  {
    "id": "f6e4f1e9-b140-5257-b715-93bbb7660023",
    "brand": "Bambu Lab",
    "material": "PC",
    "variant": "FR",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "de64cc84-ee1d-59fd-8c0d-f5770b59b90e",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Basic",
    "name": "Rojo",
    "nameEn": "Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#D6001C"
    ]
  },
  {
    "id": "69e0cca5-e319-58d0-b15b-4d201070e70e",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Basic",
    "name": "Naranja",
    "nameEn": "Orange",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FF671F"
    ]
  },
  {
    "id": "f3e28649-fb89-587f-8a9d-c4d6f4bc158d",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Basic",
    "name": "Amarillo",
    "nameEn": "Yellow",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FCE300"
    ]
  },
  {
    "id": "d9b696a5-f0c7-51c4-961d-85af8bdb67fb",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Basic",
    "name": "Azul Reflex",
    "nameEn": "Reflex Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#001489"
    ]
  },
  {
    "id": "0d4964d5-6f03-54e2-8e60-4fdf97e1522f",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Basic",
    "name": "Azul marino",
    "nameEn": "Navy Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#0086D6"
    ]
  },
  {
    "id": "13b1ec64-9050-5e58-8b02-ea92d370503f",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Basic",
    "name": "Azul Brumoso",
    "nameEn": "Misty Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#688197"
    ]
  },
  {
    "id": "64805f6d-60a4-5a73-8cd0-b251d00a1d53",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Basic",
    "name": "Verde",
    "nameEn": "Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#009639"
    ]
  },
  {
    "id": "e5fb8fe9-250f-5edc-b52e-2b70516dbbbe",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Basic",
    "name": "Verde Pino",
    "nameEn": "Pine Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#034638"
    ]
  },
  {
    "id": "3fc2d85b-aab6-5915-a324-e371bb911ccf",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Basic",
    "name": "Marrón oscuro",
    "nameEn": "Dark Brown",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#4F2C1D"
    ]
  },
  {
    "id": "9ec758ed-fd26-5d29-8dfa-4e2d43c63ed9",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Basic",
    "name": "Beige oscuro",
    "nameEn": "Dark Beige",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#DBC8B6"
    ]
  },
  {
    "id": "5728f2f8-0908-541a-b0ac-922f212b3a90",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Basic",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "157202f3-2df6-5f39-9929-5f0ceadfc26f",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Basic",
    "name": "Gris",
    "nameEn": "Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#7F7E83"
    ]
  },
  {
    "id": "4e6bfbab-9129-5482-ad35-3ad4842a944f",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Basic",
    "name": "Blanco",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "310f7a05-abb3-527f-a9ef-e3a7192f5e13",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "CF",
    "name": "Rojo ladrillo",
    "nameEn": "Brick Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#9F332A"
    ]
  },
  {
    "id": "df492bb5-1da6-5c29-8b12-077d8ccdf9e2",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "CF",
    "name": "Violeta púrpura",
    "nameEn": "Violet Purple",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#583061"
    ]
  },
  {
    "id": "f7e0dadf-9e40-56cd-9867-bb0f480d4a20",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "CF",
    "name": "Azul índigo",
    "nameEn": "Indigo Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#324585"
    ]
  },
  {
    "id": "d37dd1ca-b385-511c-a7fb-06e8d8e311a7",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "CF",
    "name": "Verde malaquita",
    "nameEn": "Malachite Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#16B08E"
    ]
  },
  {
    "id": "757c221f-b357-5dc0-9a14-c2ebf887eb88",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "CF",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "8abc573f-381e-5d2f-9bd7-7923fa75f216",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "CF",
    "name": "Gris Titán",
    "nameEn": "Titan Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#565656"
    ]
  },
  {
    "id": "b86331ee-10a3-5cfc-bb9c-767b7936cc06",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Matte",
    "name": "Black",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "50e97ac6-afb8-5b58-868e-66a91e0fc6dc",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Matte",
    "name": "White",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "bc37e74c-8955-5383-bd21-12330b45a1f5",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Matte",
    "name": "Pink",
    "nameEn": "Pink",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FABBCB"
    ]
  },
  {
    "id": "93b88b13-e470-5ed6-ae17-dbd60862cc5e",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Matte",
    "name": "Violet",
    "nameEn": "Violet",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#A7A4E0"
    ]
  },
  {
    "id": "db9ad401-66d2-5660-baef-14f8635b5431",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Matte",
    "name": "Baby Blue",
    "nameEn": "Baby Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#B9D9EB"
    ]
  },
  {
    "id": "ceb96a27-d945-58bf-a15f-75037c0e2d12",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Matte",
    "name": "Avocado Green",
    "nameEn": "Avocado Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#BCE194"
    ]
  },
  {
    "id": "50fd3913-8c18-57d2-8dd7-3e57945eb24f",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Matte",
    "name": "Lime",
    "nameEn": "Lime",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#C0DF16"
    ]
  },
  {
    "id": "1fc9c55e-9384-52e8-a9f7-90e5ed0aaf4b",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Matte",
    "name": "Gray",
    "nameEn": "Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#7F7E83"
    ]
  },
  {
    "id": "949b0645-e26b-502a-bec4-2c40d33abf39",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Translucent",
    "name": "Rosa",
    "nameEn": "Translucent Pink",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#F9C1BD"
    ]
  },
  {
    "id": "8149e1d4-301d-5823-bd83-dd5fd7016f23",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Translucent",
    "name": "Morado",
    "nameEn": "Translucent Purple",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#D6ABFF"
    ]
  },
  {
    "id": "4925f614-ade1-53ef-ae02-4081d1164812",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Translucent",
    "name": "Naranja",
    "nameEn": "Translucent Orange",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#FF911A"
    ]
  },
  {
    "id": "7155d558-8afb-58a5-88cd-58581bbc6529",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Translucent",
    "name": "Marrón",
    "nameEn": "Translucent Brown",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#C9A381"
    ]
  },
  {
    "id": "b9d9fb5e-799c-5871-8bcd-a96c8b0f7b34",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Translucent",
    "name": "Verde azulado",
    "nameEn": "Translucent Teal",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#77EDD7"
    ]
  },
  {
    "id": "baf3c1d7-4f0a-578a-968a-8159bc6879d7",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Translucent",
    "name": "Luz Azul",
    "nameEn": "Translucent Light Blue",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#61B0FF"
    ]
  },
  {
    "id": "d3ad75f4-84d4-5a46-a0ca-b83e83183c1a",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Translucent",
    "name": "Oliva",
    "nameEn": "Translucent Olive",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#748C45"
    ]
  },
  {
    "id": "c3027d3a-dad6-5f59-b29f-4dfc04180a49",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "Translucent",
    "name": "Gris",
    "nameEn": "Translucent Gray",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#8E8E8E"
    ]
  },
  {
    "id": "f966bcdd-8b9f-5eb4-b3eb-326dcb4b7a31",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Blanco jade",
    "nameEn": "Jade White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "ff918771-786a-5da0-8ec7-2dded8b1637d",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Beis",
    "nameEn": "Beige",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F7E6DE"
    ]
  },
  {
    "id": "377a362f-fa43-55b7-ad99-5bf9a67c84a2",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Gris claro",
    "nameEn": "Light Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#D1D3D5"
    ]
  },
  {
    "id": "626c142e-3416-5ef7-a40e-ea79b9449353",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Plateado",
    "nameEn": "Silver",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#A6A9AA"
    ]
  },
  {
    "id": "cd5a97bb-6781-5f21-b092-0683fec79af3",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Gris",
    "nameEn": "Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#8E9089"
    ]
  },
  {
    "id": "338e96d6-1347-5a46-9b01-0bc09f6cfd15",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Magenta",
    "nameEn": "Magenta",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#EC008C"
    ]
  },
  {
    "id": "5f411cde-fbd9-5313-aa98-33708982fcd6",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Rosa",
    "nameEn": "Pink",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F55A74"
    ]
  },
  {
    "id": "48fe495c-818d-5626-a9ac-dc36df4060c9",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Rosa fucsia",
    "nameEn": "Hot Pink",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F5547C"
    ]
  },
  {
    "id": "bd311d2c-b472-518e-b335-a57b27b561b5",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Naranja",
    "nameEn": "Orange",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FF6A13"
    ]
  },
  {
    "id": "72a81a5e-1fbc-558d-bb24-e28ef5578ea7",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Naranja calabaza",
    "nameEn": "Pumpkin Orange",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FF9016"
    ]
  },
  {
    "id": "ba843bd2-cbc8-526d-b83e-3d6f2b89ee53",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Dorado",
    "nameEn": "Gold",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#E4BD68"
    ]
  },
  {
    "id": "96e1fa0a-324f-5c2c-8b6b-d169a6c7f11b",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Amarillo girasol",
    "nameEn": "Sunflower Yellow",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FEC600"
    ]
  },
  {
    "id": "f6415f4c-e065-5730-978f-c49ee3553d80",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Amarillo",
    "nameEn": "Yellow",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F4EE2A"
    ]
  },
  {
    "id": "39b0fa1c-3b4b-5d9f-8a94-659d04132742",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Verde brillante",
    "nameEn": "Bright Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#BECF00"
    ]
  },
  {
    "id": "5565b5cf-74a7-51d2-bb4b-e457e39c55cd",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Verde bambú",
    "nameEn": "Bambu Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#00AE42"
    ]
  },
  {
    "id": "5f64bc8a-5b1d-5cdc-8ff9-95ccf2782805",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Verde muérdago",
    "nameEn": "Mistletoe Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#3F8E43"
    ]
  },
  {
    "id": "4c05971f-1cf0-5864-948d-3267d4f713ab",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Bronce",
    "nameEn": "Bronze",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#847D48"
    ]
  },
  {
    "id": "8f721671-a2d0-590c-a155-0569d35eda05",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Marrón cacao",
    "nameEn": "Cocoa Brown",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#6F5034"
    ]
  },
  {
    "id": "441f28b4-ed90-54c5-bf08-428e559486ba",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Marrón",
    "nameEn": "Brown",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#9D432C"
    ]
  },
  {
    "id": "3bbafacb-925f-511b-b045-242e3e0fb4f6",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Rojo granate",
    "nameEn": "Maroon Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#9D2235"
    ]
  },
  {
    "id": "4d1931a5-38cc-5eea-923c-626340aa0f60",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Rojo",
    "nameEn": "Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#C12E1F"
    ]
  },
  {
    "id": "b9a40cb2-5020-5241-b7b8-f93578662d6b",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Turquesa",
    "nameEn": "Turquoise",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#00B1B7"
    ]
  },
  {
    "id": "c2b54558-df0a-5641-9bff-4d4941124afb",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Cian",
    "nameEn": "Cyan",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#0086D6"
    ]
  },
  {
    "id": "6a47562c-ed21-55d5-8202-35e59acfaec8",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Azul",
    "nameEn": "Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#0A2989"
    ]
  },
  {
    "id": "4033a220-7a7e-55b3-9209-b4b2ca5c8483",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Azul cobalto",
    "nameEn": "Cobalt Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#0056B8"
    ]
  },
  {
    "id": "6e02bd9c-29c4-5c4b-9981-0b64980a9815",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Púrpura",
    "nameEn": "Purple",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#5E43B7"
    ]
  },
  {
    "id": "1a9ab653-8ace-53a6-bc06-b3735a4e46f1",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Púrpura índigo",
    "nameEn": "Indigo Purple",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#482960"
    ]
  },
  {
    "id": "7a4b13f4-63a1-500c-bc65-ced4a5541ebb",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Azul Gris",
    "nameEn": "Blue Grey",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#5B6579"
    ]
  },
  {
    "id": "c88d9431-a24f-52c9-b283-d1a618c5df23",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Gris oscuro",
    "nameEn": "Dark Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#545454"
    ]
  },
  {
    "id": "9b639a91-06fc-568c-a520-a2aa7ab9b65d",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "90c90173-f555-5771-87d8-98c622295e51",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic Gradient",
    "name": "Susurro ártico",
    "nameEn": "Arctic Whisper",
    "distribution": "gradiente",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF",
      "#9CDBD9"
    ]
  },
  {
    "id": "f9de1861-0939-5d26-b48a-3f0c97e531f1",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic Gradient",
    "name": "Del océano a la pradera",
    "nameEn": "Ocean to Meadow",
    "distribution": "gradiente",
    "translucent": false,
    "sample": false,
    "colors": [
      "#54FF9B",
      "#307FE2"
    ]
  },
  {
    "id": "a972e946-3c5c-5246-af6b-fe34d7e6d657",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic Gradient",
    "name": "Nube de algodón de azúcar",
    "nameEn": "Cotton Candy Cloud",
    "distribution": "gradiente",
    "translucent": false,
    "sample": false,
    "colors": [
      "#E7C1D5",
      "#8EC9E9"
    ]
  },
  {
    "id": "f1e6fde3-1249-5b44-820d-f58dd229e6d0",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic Gradient",
    "name": "Chicle de arándano",
    "nameEn": "Blueberry Bubblegum",
    "distribution": "gradiente",
    "translucent": false,
    "sample": false,
    "colors": [
      "#6FCAEF",
      "#8573DD"
    ]
  },
  {
    "id": "a64d1bc0-d962-52d1-aabd-9beaaf55edf6",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic Gradient",
    "name": "Lima menta",
    "nameEn": "Mint Lime",
    "distribution": "gradiente",
    "translucent": false,
    "sample": false,
    "colors": [
      "#4EC939",
      "#B6FF43"
    ]
  },
  {
    "id": "b960bae7-3aff-541c-a921-709bed264121",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic Gradient",
    "name": "Brisa solar",
    "nameEn": "Solar Breeze",
    "distribution": "gradiente",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF",
      "#E94B3C"
    ]
  },
  {
    "id": "6b3fee3c-9d46-586c-acae-c4b80941ad4d",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic Gradient",
    "name": "Rosa cítrico",
    "nameEn": "Pink Citrus",
    "distribution": "gradiente",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F78F77",
      "#E4505A"
    ]
  },
  {
    "id": "de2ea023-f230-5c12-af27-7be7e95c01f1",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Basic Gradient",
    "name": "Resplandor del crepúsculo",
    "nameEn": "Dusk Glare",
    "distribution": "gradiente",
    "translucent": false,
    "sample": false,
    "colors": [
      "#ED9558",
      "#CE4406"
    ]
  },
  {
    "id": "6725139a-ccdb-52ca-b1f9-1c3c841158d1",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "CF",
    "name": "Rojo burdeos",
    "nameEn": "Burgundy Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#951E23"
    ]
  },
  {
    "id": "2136708d-1149-54d3-b951-5e55158f8032",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "CF",
    "name": "Púrpura iris",
    "nameEn": "Iris Purple",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#69398E"
    ]
  },
  {
    "id": "d8847362-afbc-5f31-870e-1b57e1d19beb",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "CF",
    "name": "Verde matcha",
    "nameEn": "Matcha Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#5C9748"
    ]
  },
  {
    "id": "82379043-6978-592c-adac-2fa4fe748fa3",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "CF",
    "name": "Azul vaquero",
    "nameEn": "Jeans Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#6E88BC"
    ]
  },
  {
    "id": "26b23248-d334-56b9-9373-705744b64327",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "CF",
    "name": "Azul real",
    "nameEn": "Royal Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#2842AD"
    ]
  },
  {
    "id": "185752f0-8ac0-52e2-a369-9e8479e65d06",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "CF",
    "name": "Gris lava",
    "nameEn": "Lava Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#4D5054"
    ]
  },
  {
    "id": "98cacbab-76fb-5708-a26c-052f772ff29a",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "CF",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "38de70d1-d968-5711-a97b-d517117f9cca",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Galaxy",
    "name": "Marrón",
    "nameEn": "Brown",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#684A43"
    ]
  },
  {
    "id": "5a760ec9-0d56-5c3f-a8cc-a6b2a86e62b2",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Galaxy",
    "name": "Verde",
    "nameEn": "Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#3B665E"
    ]
  },
  {
    "id": "6d970569-b005-58f4-8888-a9792f222cf6",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Galaxy",
    "name": "Nebulosa",
    "nameEn": "Nebulae",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#424379"
    ]
  },
  {
    "id": "ef4e1c19-cffd-5c6b-a4b9-1b469fb13178",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Galaxy",
    "name": "Púrpura",
    "nameEn": "Purple",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#594177"
    ]
  },
  {
    "id": "723e6f6a-48cb-54be-a135-f9093ee6c9f9",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Glow",
    "name": "Verde brillante",
    "nameEn": "Glow Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#A1FFAC"
    ]
  },
  {
    "id": "28fea029-898f-5345-80a2-2705ccfa380b",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Glow",
    "name": "Amarillo brillante",
    "nameEn": "Glow Yellow",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F8FF80"
    ]
  },
  {
    "id": "368e9f5d-2fcf-56ba-bddc-c80628e21dcf",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Glow",
    "name": "Rosa brillante",
    "nameEn": "Glow Pink",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F17B8F"
    ]
  },
  {
    "id": "65329f47-f1f1-5697-9d5c-3ed014a13561",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Glow",
    "name": "Azul brillante",
    "nameEn": "Glow Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#7AC0E9"
    ]
  },
  {
    "id": "7e26c8db-c8f7-50cf-b64d-5867ec9f82c9",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Glow",
    "name": "Naranja brillante",
    "nameEn": "Glow Orange",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FF9D5B"
    ]
  },
  {
    "id": "d13cd099-8c98-5fcc-942f-d615ef353f8a",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Marble",
    "name": "Mármol blanco",
    "nameEn": "White Marble",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F7F3F0"
    ]
  },
  {
    "id": "91c3942d-5dbd-54e8-b8ef-2a2f325a9c72",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Marble",
    "name": "Granate rojo",
    "nameEn": "Red Granite",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#AD4E38"
    ]
  },
  {
    "id": "ec8f5b5b-9c62-5907-b052-7a986a84623e",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Blanco Marfil",
    "nameEn": "Ivory White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "7cedadd9-5680-558b-bca8-506818e6071b",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Blanco Hueso",
    "nameEn": "Bone White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#CBC6B8"
    ]
  },
  {
    "id": "e4bca6d2-9720-5ca2-a452-9ba2172022d2",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Bronceado desierto",
    "nameEn": "Desert Tan",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#E8DBB7"
    ]
  },
  {
    "id": "d71a99a5-4ccb-5388-8a55-2ff753b3dbf1",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Marrón Latte",
    "nameEn": "Latte Brown",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#D3B7A7"
    ]
  },
  {
    "id": "ba7908e5-0127-5349-832b-3f4b00c98dbb",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Caramelo",
    "nameEn": "Caramel",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#AE835B"
    ]
  },
  {
    "id": "370e00a0-f2a1-5ce1-a9de-ad3039909369",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Terracota",
    "nameEn": "Terracotta",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#B15533"
    ]
  },
  {
    "id": "68109370-1774-54c2-bb63-0b4ccead1cd6",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Marrón oscuro",
    "nameEn": "Dark Brown",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#7D6556"
    ]
  },
  {
    "id": "4d492753-5f23-564e-b707-8745e835a754",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Chocolate oscuro",
    "nameEn": "Dark Chocolate",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#4D3324"
    ]
  },
  {
    "id": "cb7ced15-47b2-572e-96a0-e6e0ec4f30f1",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Morado lila",
    "nameEn": "Lilac Purple",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#AE96D4"
    ]
  },
  {
    "id": "2e948d80-032d-59fd-9d66-18a3236c13f6",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Rosa Sakura",
    "nameEn": "Sakura Pink",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#E8AFCF"
    ]
  },
  {
    "id": "80a7536b-228e-540d-8ba9-5a468149c14c",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Naranja Mandarina",
    "nameEn": "Mandarin Orange",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F99963"
    ]
  },
  {
    "id": "37dbb438-4462-5d45-84cd-2fe768aad275",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Amarillo Limón",
    "nameEn": "Lemon Yellow",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F7D959"
    ]
  },
  {
    "id": "fafe8d91-d7ac-54c9-bbf0-df39c6c11bcd",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Ciruela",
    "nameEn": "Plum",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#950051"
    ]
  },
  {
    "id": "e1c54c42-edf6-5368-9c6b-61a347ba7275",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Rojo Escarlata",
    "nameEn": "Scarlet Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#DE4343"
    ]
  },
  {
    "id": "139dc32c-0a7a-501d-907e-37c59a1f340f",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Rojo oscuro",
    "nameEn": "Dark Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#BB3D43"
    ]
  },
  {
    "id": "7d17a149-1047-5a84-8606-ae8d7c7b2c38",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Verde oscuro",
    "nameEn": "Dark Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#68724D"
    ]
  },
  {
    "id": "52ca7f87-ccd2-5826-bb12-0a940c68c954",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Verde hierba",
    "nameEn": "Grass Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#61C680"
    ]
  },
  {
    "id": "cbf6eda4-1186-51ac-86e0-d2e8bccba75a",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Verde Manzana",
    "nameEn": "Apple Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#C2E189"
    ]
  },
  {
    "id": "379b8f60-ab02-5562-81ca-82ceae8e9bcd",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Azul Hielo",
    "nameEn": "Ice Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#A3D8E1"
    ]
  },
  {
    "id": "b91658a7-16f3-544c-9442-c670c01d0952",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Azul cielo",
    "nameEn": "Sky Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#56B7E6"
    ]
  },
  {
    "id": "bb0082f5-6e96-5e68-bcd1-5ca09f0612b3",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Azul Marino",
    "nameEn": "Marine Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#0078BF"
    ]
  },
  {
    "id": "a61c843b-ac89-5310-8c2c-52d502bf95dd",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Azul oscuro",
    "nameEn": "Dark Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#042F56"
    ]
  },
  {
    "id": "947e1216-e202-5b6d-bfca-74540ad818f7",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Gris ceniza",
    "nameEn": "Ash Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#9B9EA0"
    ]
  },
  {
    "id": "3e807b9f-22fc-5c6a-ac8b-eeddd66286ed",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Gris Nardo",
    "nameEn": "Nardo Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#757575"
    ]
  },
  {
    "id": "e0967c00-411a-5e79-9ebf-1425e8718deb",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Matte",
    "name": "Carbón",
    "nameEn": "Charcoal",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "c0a1654e-1ecd-54d0-88c3-1538557afda0",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Palette",
    "name": "Magenta",
    "nameEn": "Magenta",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#E24585"
    ]
  },
  {
    "id": "9d5b8ce4-ba59-57f0-b7ea-2da19ea70eaa",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Palette",
    "name": "Cian",
    "nameEn": "Cyan",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#0090DA"
    ]
  },
  {
    "id": "1ba4b33a-b8ea-555b-8406-db4557405364",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Palette",
    "name": "Amarillo",
    "nameEn": "Yellow",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FCE300"
    ]
  },
  {
    "id": "cbb5806c-b0d8-5642-bf2f-fd81d36791c9",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Palette",
    "name": "Clave",
    "nameEn": "Key",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "cd08d59a-3ece-5dde-862d-ee6cd017665a",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Palette",
    "name": "Blanco",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "bd6d9360-0827-56f9-a5c5-b385ff351779",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Metal",
    "name": "Dorado iridio metalizado",
    "nameEn": "Iridium Gold Metallic",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#B39B84"
    ]
  },
  {
    "id": "60c2baf3-791d-5dff-aced-6670ed92ea5a",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Metal",
    "name": "Marrón cobre metalizado",
    "nameEn": "Copper Brown Metallic",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#AA6443"
    ]
  },
  {
    "id": "050526e6-737f-52ca-bfd7-b043232cbd93",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Metal",
    "name": "Verde óxido metálico",
    "nameEn": "Oxide Green Metallic",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#1D7C6A"
    ]
  },
  {
    "id": "3ec3ae25-3a3c-5d03-af76-3cb1d3c47a01",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Metal",
    "name": "Azul cobalto metalizado",
    "nameEn": "Cobalt Blue Metallic",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#39699E"
    ]
  },
  {
    "id": "b6be76e8-88b7-5a2b-8249-b0bf0fd08ec6",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Metal",
    "name": "Gris hierro metalizado",
    "nameEn": "Iron Gray Metallic",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#43403D"
    ]
  },
  {
    "id": "fb010099-28b4-5bd5-a1dd-b73152c51864",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Pure",
    "name": "Blanco puro",
    "nameEn": "Pure White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "d423a200-c9b9-52fb-aa08-d2768fad8624",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Pure",
    "name": "Negro Absoluto",
    "nameEn": "Absolute Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "3a7b5ecf-9427-5d04-a159-2d106652b965",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Pure",
    "name": "Azul bebé",
    "nameEn": "Baby Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#A4DBE8"
    ]
  },
  {
    "id": "7f6c64ab-e9a1-5c09-9010-edc8318a2254",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Pure",
    "name": "Rosa lechoso",
    "nameEn": "Milky Pink",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F7CED7"
    ]
  },
  {
    "id": "b29bc06c-f360-5f65-a085-ea693f99c8e1",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Pure",
    "name": "Albaricoque",
    "nameEn": "Apricot",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFB673"
    ]
  },
  {
    "id": "6889b194-6ac2-50b5-8982-d999882bc8fa",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk+",
    "name": "Blanco",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "c06f386b-04de-526a-8996-83d3fbae7ad5",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk+",
    "name": "Plateado",
    "nameEn": "Silver",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#C8C8C8"
    ]
  },
  {
    "id": "f1fbad85-e19b-5684-81c3-eabe14205ffb",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk+",
    "name": "Champán",
    "nameEn": "Champagne",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F3CFB2"
    ]
  },
  {
    "id": "14cf5493-4920-5fb8-99d1-e6da98af4b70",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk+",
    "name": "Rosa",
    "nameEn": "Pink",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F7ADA6"
    ]
  },
  {
    "id": "7d24e39c-ff66-5c0d-ae2d-c598c15f41e7",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk+",
    "name": "Oro rosa",
    "nameEn": "Rose Gold",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#BA9594"
    ]
  },
  {
    "id": "5e708140-f7f4-50c9-b612-3fd4ebd4482e",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk+",
    "name": "Rojo caramelo",
    "nameEn": "Candy Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#D02727"
    ]
  },
  {
    "id": "856369d2-34c3-5624-ab1d-641388830b08",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk+",
    "name": "Dorado",
    "nameEn": "Gold",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F4A925"
    ]
  },
  {
    "id": "d62806f2-5a15-530d-ae4c-142c00d29286",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk+",
    "name": "Menta",
    "nameEn": "Mint",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#96DCB9"
    ]
  },
  {
    "id": "62bdd23f-95a5-5eca-8406-b27d9413d4ee",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk+",
    "name": "Verde caramelo",
    "nameEn": "Candy Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#018814"
    ]
  },
  {
    "id": "b4b0e5a7-6dcf-521a-9875-dfb02d9f1a7d",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk+",
    "name": "Azul bebé",
    "nameEn": "Baby Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#A8C6EE"
    ]
  },
  {
    "id": "5ef9ae85-1d2a-5ccb-8d36-7182b2db3944",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk+",
    "name": "Azul",
    "nameEn": "Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#008BDA"
    ]
  },
  {
    "id": "79c3c40b-3d4f-56b9-ba1c-dd989b784ece",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk+",
    "name": "Púrpura",
    "nameEn": "Purple",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#8671CB"
    ]
  },
  {
    "id": "60115c44-8708-5dfc-9a01-0c9e7844566a",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk+",
    "name": "Gris titán",
    "nameEn": "Titan Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#5F6367"
    ]
  },
  {
    "id": "d8329766-3e42-504a-9ac0-a1ddbb008a00",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Sparkle",
    "name": "Dorado clásico brillante",
    "nameEn": "Classic Gold Sparkle",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#CEA629"
    ]
  },
  {
    "id": "8aac3b3f-527e-5136-995d-0a877ed803c6",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Sparkle",
    "name": "Gris pizarra brillante",
    "nameEn": "Slate Gray Sparkle",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#8E9089"
    ]
  },
  {
    "id": "1c19ce9b-76e2-55ae-b8fa-2b15cce256f7",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Sparkle",
    "name": "Rojo carmesí brillante",
    "nameEn": "Crimson Red Sparkle",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#792B36"
    ]
  },
  {
    "id": "95a0d6a9-14ae-52ca-8588-bcee6c343ddb",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Sparkle",
    "name": "Púrpura real brillante",
    "nameEn": "Royal Purple Sparkle",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#483D8B"
    ]
  },
  {
    "id": "12a36244-481c-5279-a874-ca2f971ebf68",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Sparkle",
    "name": "Verde alpino brillante",
    "nameEn": "Alpine Green Sparkle",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#3F5443"
    ]
  },
  {
    "id": "20b1419b-b8f5-5b8a-806d-254edc7d0b21",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Sparkle",
    "name": "Negro ónix brillante",
    "nameEn": "Onyx Black Sparkle",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#2D2B28"
    ]
  },
  {
    "id": "affda2e0-8275-5070-9df9-d622b184cb58",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Tough+",
    "name": "Blanco",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "b67b7587-d9f8-5efd-af65-d14cd7f70d59",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Tough+",
    "name": "Gris",
    "nameEn": "Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#AFB1AE"
    ]
  },
  {
    "id": "bc91f08a-0c32-57fa-ac37-68b535be4536",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Tough+",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "5f6fa8c8-4b93-5b1e-a64e-4136f56fdc20",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Tough+",
    "name": "Plateado",
    "nameEn": "Silver",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#959698"
    ]
  },
  {
    "id": "2ac11eb7-be9b-5416-b2f0-b53354382796",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Tough+",
    "name": "Amarillo",
    "nameEn": "Yellow",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F4D53F"
    ]
  },
  {
    "id": "693be457-c660-5357-a413-093f735040e1",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Tough+",
    "name": "Cian",
    "nameEn": "Cyan",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#009BD8"
    ]
  },
  {
    "id": "9ff951b2-6073-5106-8f30-94390ec3ab6a",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Tough+",
    "name": "Naranja",
    "nameEn": "Orange",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#DC3A27"
    ]
  },
  {
    "id": "8e5f1d34-29e1-539f-ba25-c13dab52b723",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Translucent",
    "name": "Verde azulado",
    "nameEn": "Teal",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#009FA1"
    ]
  },
  {
    "id": "3f647485-c39c-50b9-8314-7442f8f457fd",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Translucent",
    "name": "Jade claro",
    "nameEn": "Light Jade",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#96D8AF"
    ]
  },
  {
    "id": "aa2c19db-de6c-50c1-b623-d0066603e0f6",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Translucent",
    "name": "Azul",
    "nameEn": "Blue",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#0047BB"
    ]
  },
  {
    "id": "f29bc594-8de0-5369-9cf8-a73299be5458",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Translucent",
    "name": "Amarillo suave",
    "nameEn": "Mellow Yellow",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#F5DBAB"
    ]
  },
  {
    "id": "2ed38c9f-82ac-5351-b13e-27c1906fae17",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Translucent",
    "name": "Púrpura",
    "nameEn": "Purple",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#8344B0"
    ]
  },
  {
    "id": "2f8b7193-bab7-52f3-85e2-136eebce7c51",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Translucent",
    "name": "Rosa cereza",
    "nameEn": "Cherry Pink",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#F5B6CD"
    ]
  },
  {
    "id": "e136d842-dd74-5287-8c28-47fd334ab2d9",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Translucent",
    "name": "Naranja",
    "nameEn": "Orange",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#F74E02"
    ]
  },
  {
    "id": "8d207612-cc45-5e1c-9d7b-c63154ebae5e",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Translucent",
    "name": "Azul hielo",
    "nameEn": "Ice Blue",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#B8CDE9"
    ]
  },
  {
    "id": "2321325b-b243-5328-900f-cb37e2801e64",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Translucent",
    "name": "Rojo",
    "nameEn": "Red",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#B50011"
    ]
  },
  {
    "id": "eddfb3f8-e9b6-5245-b981-149f438613fa",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Translucent",
    "name": "Lavanda",
    "nameEn": "Lavender",
    "distribution": "unicolor",
    "translucent": true,
    "sample": false,
    "colors": [
      "#B8ACD6"
    ]
  },
  {
    "id": "9efb1878-c410-51b6-bb6b-30ac1aaaee97",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "75A · 2.85 mm",
    "name": "Rojo",
    "nameEn": "Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#E4002B"
    ]
  },
  {
    "id": "703168c4-92c6-5248-8fe9-0fc26d1d626c",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "75A · 2.85 mm",
    "name": "Rosa",
    "nameEn": "Pink",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FABBCB"
    ]
  },
  {
    "id": "29b79442-3faa-5b02-8b5d-a7eedaf2f921",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "75A · 2.85 mm",
    "name": "Morado",
    "nameEn": "Purple",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#AD96DC"
    ]
  },
  {
    "id": "6cb39ea2-e9f5-57c0-ab8f-3b65db446d86",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "75A · 2.85 mm",
    "name": "Naranja Mandarina",
    "nameEn": "Mandarin Orange",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFA06A"
    ]
  },
  {
    "id": "205304c3-363e-58c9-8700-bbcee87d0a96",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "75A · 2.85 mm",
    "name": "Verde hierba",
    "nameEn": "Grass Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#7CCC6C"
    ]
  },
  {
    "id": "d52fc627-3006-583d-82a7-8c6ff8bf1f12",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "75A · 2.85 mm",
    "name": "Verde oscuro",
    "nameEn": "Dark Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#617354"
    ]
  },
  {
    "id": "75445243-d0ad-5756-9f8f-73be0e7608a9",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "75A · 2.85 mm",
    "name": "Marfil oscuro",
    "nameEn": "Dark Ivory",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F1E6B2"
    ]
  },
  {
    "id": "e2710b7b-62fc-52c4-a0b6-336d240b0444",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "75A · 2.85 mm",
    "name": "Amarillo Limón",
    "nameEn": "Lemon Yellow",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FBDB65"
    ]
  },
  {
    "id": "3bc89d3b-8777-5773-b5ec-7900a75dacf6",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "75A · 2.85 mm",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "f40ec0e5-1d00-5a25-8132-d29e7ec9cfde",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "75A · 2.85 mm",
    "name": "Cian",
    "nameEn": "Cyan",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#00A3E1"
    ]
  },
  {
    "id": "0e3a46e6-42b8-5fe2-8a2c-b9eeaecdea47",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "90A",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "53c0085f-8c01-5fdf-b1c6-a93b21bd63f8",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "90A",
    "name": "Blanco",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFEE"
    ]
  },
  {
    "id": "a958d570-d5d7-56e2-8223-10c50f44de10",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "90A",
    "name": "Marrón Cacao",
    "nameEn": "Cocoa Brown",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#5C4738"
    ]
  },
  {
    "id": "ca238b5a-3c06-57b6-9a89-aa975d90d16a",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "90A",
    "name": "Quicksilver",
    "nameEn": "Quicksilver",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#9EA2A2"
    ]
  },
  {
    "id": "136145cf-0b17-5766-8bd6-70b200584561",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "90A",
    "name": "Blaze",
    "nameEn": "Blaze",
    "distribution": "gradiente",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F1AAA8",
      "#D21B3C"
    ]
  },
  {
    "id": "397eabc3-92f4-52bc-aaeb-43193aa12288",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "90A",
    "name": "Congelado",
    "nameEn": "Frozen",
    "distribution": "gradiente",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF",
      "#40B6E4"
    ]
  },
  {
    "id": "0dc20ae1-6830-56a9-a535-e3484ac5da66",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "85A",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "7b815f04-db58-5872-9efc-9f2fa2385158",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "85A",
    "name": "Luz Cian",
    "nameEn": "Light Cyan",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#C3E2D6"
    ]
  },
  {
    "id": "a22987ac-b4cc-5c59-82de-a60eea88248c",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "85A",
    "name": "Naranja neón",
    "nameEn": "Neon Orange",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F68B1B"
    ]
  },
  {
    "id": "8f532aec-e77e-5da9-aa3d-99b8a690686d",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "85A",
    "name": "Beige Rosado/Carne",
    "nameEn": "Rose Beige (Flesh)",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F3CFB2"
    ]
  },
  {
    "id": "7cacea71-abc8-5b1b-bf78-bdb6a8530017",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "85A",
    "name": "Verde lima",
    "nameEn": "Lime Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#CDEA80"
    ]
  },
  {
    "id": "da473ba9-8a87-5908-9f17-ad2f84e77d78",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Wood",
    "name": "Roble blanco",
    "nameEn": "White Oak",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#D6CCA3"
    ]
  },
  {
    "id": "68ac7b91-b072-5495-8b02-8f6faad5893b",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Wood",
    "name": "Amarillo ocre",
    "nameEn": "Ochre Yellow",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#C98935"
    ]
  },
  {
    "id": "94bb3ed4-60e4-52b2-9a45-1862fe0039d0",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Wood",
    "name": "Marrón arcilla",
    "nameEn": "Clay Brown",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#995F11"
    ]
  },
  {
    "id": "40f41f69-a8a3-5398-a2c8-67fda2291bd6",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Wood",
    "name": "Abedul clásico",
    "nameEn": "Classic Birch",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#918669"
    ]
  },
  {
    "id": "871cad8a-1d7f-55be-b309-afd5e6bd55ee",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Wood",
    "name": "Palo de rosa",
    "nameEn": "Rosewood",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#4C241C"
    ]
  },
  {
    "id": "68b75654-b262-5e67-a16f-92f9c8ce3897",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Wood",
    "name": "Nogal negro",
    "nameEn": "Black Walnut",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#4F3F24"
    ]
  },
  {
    "id": "aa338af5-9ef1-5b14-9d47-a3b33d1df3f2",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "95A HF",
    "name": "Blanco",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "14af7644-58bb-5ffc-bae9-b3d45d94a14a",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "95A HF",
    "name": "Gris",
    "nameEn": "Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#898D8D"
    ]
  },
  {
    "id": "f47379bb-df1c-5cbb-b9ca-314304bc5776",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "95A HF",
    "name": "Amarillo",
    "nameEn": "Yellow",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F3E600"
    ]
  },
  {
    "id": "00fa8364-0414-506b-82df-60b2ba25912d",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "95A HF",
    "name": "Azul",
    "nameEn": "Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#0072CE"
    ]
  },
  {
    "id": "121eae07-bc63-5472-b0ef-b069668dd988",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "95A HF",
    "name": "Rojo",
    "nameEn": "Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#C8102E"
    ]
  },
  {
    "id": "381984cd-a6b4-5ddf-8360-bf8832a8b78a",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "95A HF",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#101820"
    ]
  },
  {
    "id": "ee20935f-90f5-519c-be01-21c1e0419796",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "for AMS",
    "name": "Blanco",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "5e97147b-4c49-541b-b5d9-85610d48d2f8",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "for AMS",
    "name": "Gris",
    "nameEn": "Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#939393"
    ]
  },
  {
    "id": "be495e92-c115-50ff-8936-3cb3eabbb769",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "for AMS",
    "name": "Amarillo",
    "nameEn": "Yellow",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F9EF41"
    ]
  },
  {
    "id": "5c668b18-8f1e-565f-92a6-a13a85873993",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "for AMS",
    "name": "Verde neón",
    "nameEn": "Neon Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#90FF1A"
    ]
  },
  {
    "id": "eb8cca52-242e-563a-9b6e-cdc625016b4b",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "for AMS",
    "name": "Rojo",
    "nameEn": "Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#ED0000"
    ]
  },
  {
    "id": "b1c391ce-2298-5358-a692-2281e9447857",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "for AMS",
    "name": "Azul",
    "nameEn": "Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#5898DD"
    ]
  },
  {
    "id": "8b3c34c8-01cd-5ff4-957c-5d364af6d7a2",
    "brand": "Bambu Lab",
    "material": "TPU",
    "variant": "for AMS",
    "name": "Negro",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "6b0dbaba-1f5d-5400-a920-2f4eb80a16db",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk Multi-Color",
    "name": "Magenta Místico",
    "nameEn": "Mystic Magenta",
    "distribution": "multicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#720062",
      "#3A913F"
    ]
  },
  {
    "id": "68d656bb-aca8-5eb8-8834-40fe3cae8b08",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk Multi-Color",
    "name": "Phantom Blue",
    "nameEn": "Phantom Blue",
    "distribution": "multicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#00629B",
      "#000000"
    ]
  },
  {
    "id": "46fb8aa3-b8a0-5052-82ce-b889a60fed6c",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk Multi-Color",
    "name": "Eclipse de terciopelo",
    "nameEn": "Velvet Eclipse",
    "distribution": "multicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000",
      "#A34342"
    ]
  },
  {
    "id": "b5594dd5-d967-585a-923d-b6683126181c",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk Multi-Color",
    "name": "Resplandor de medianoche",
    "nameEn": "Midnight Blaze",
    "distribution": "multicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#0047BB",
      "#7D1B49"
    ]
  },
  {
    "id": "66d0d31d-04fa-5474-9d73-804d96254c76",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk Multi-Color",
    "name": "Rosa dorado",
    "nameEn": "Gilded Rose",
    "distribution": "multicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FF9425",
      "#FCA2BF"
    ]
  },
  {
    "id": "91f379b3-a4de-511f-bef7-b3ff9c4c1c00",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk Multi-Color",
    "name": "Azul Hawái",
    "nameEn": "Blue Hawaii",
    "distribution": "multicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#60A4E8",
      "#4CE4A0"
    ]
  },
  {
    "id": "8b019cd8-49d0-50de-bfde-641fde6788b0",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk Multi-Color",
    "name": "Ciudad de neón",
    "nameEn": "Neon City",
    "distribution": "multicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#0047BB",
      "#BB22A3"
    ]
  },
  {
    "id": "06dd9607-3e3d-5473-9237-05ba828d4911",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk Multi-Color",
    "name": "Púrpura Aurora",
    "nameEn": "Aurora Purple",
    "distribution": "gradiente",
    "translucent": false,
    "sample": false,
    "colors": [
      "#7F3696",
      "#006EC9"
    ]
  },
  {
    "id": "7d4a4a77-974e-5d95-890e-0dafa891fd14",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk Multi-Color",
    "name": "Playa del Sur",
    "nameEn": "South Beach",
    "distribution": "gradiente",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F772A4",
      "#00918B"
    ]
  },
  {
    "id": "00b90f57-bcfd-533a-976d-ef9255090fdb",
    "brand": "Bambu Lab",
    "material": "PLA",
    "variant": "Silk Multi-Color",
    "name": "Resplandor del Amanecer",
    "nameEn": "Dawn Radiance",
    "distribution": "gradiente",
    "translucent": false,
    "sample": false,
    "colors": [
      "#EC984C",
      "#6CD4BC",
      "#A66EB9",
      "#D87694"
    ]
  },
  {
    "id": "21b2a052-1021-5a92-8d65-1d5fd35fcc46",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "HF",
    "name": "Yellow",
    "nameEn": "Yellow",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFD00B"
    ]
  },
  {
    "id": "86bc6c53-7336-58ef-a925-e88505bb9e37",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "HF",
    "name": "Orange",
    "nameEn": "Orange",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F75403"
    ]
  },
  {
    "id": "d5fa6ca4-a95f-5b7e-8a25-628b8c9183ad",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "HF",
    "name": "Green",
    "nameEn": "Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#00AE42"
    ]
  },
  {
    "id": "05f62295-946c-5cb5-b82a-1c6d14211702",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "HF",
    "name": "Red",
    "nameEn": "Red",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#EB3A3A"
    ]
  },
  {
    "id": "41409caf-e88e-5c62-8cb0-3d32f640d9e5",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "HF",
    "name": "Blue",
    "nameEn": "Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#002E96"
    ]
  },
  {
    "id": "e2e39ed7-8c6a-598e-bd29-34e0a70e87d5",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "HF",
    "name": "Black",
    "nameEn": "Black",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#000000"
    ]
  },
  {
    "id": "c8c99f0d-bee2-575d-ae92-ccff6ef37414",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "HF",
    "name": "White",
    "nameEn": "White",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#FFFFFF"
    ]
  },
  {
    "id": "48411fef-fca4-5164-99ee-09a52d043570",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "HF",
    "name": "Cream",
    "nameEn": "Cream",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#F9DFB9"
    ]
  },
  {
    "id": "a43da224-f25d-581a-aef5-1b18242964b8",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "HF",
    "name": "Lime Green",
    "nameEn": "Lime Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#6EE53C"
    ]
  },
  {
    "id": "54866453-d0c7-5386-a8b8-04b9526a9751",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "HF",
    "name": "Forest Green",
    "nameEn": "Forest Green",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#39541A"
    ]
  },
  {
    "id": "bb122191-d87a-5784-b19c-ab49143b3eb5",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "HF",
    "name": "Lake Blue",
    "nameEn": "Lake Blue",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#1F79E5"
    ]
  },
  {
    "id": "096a5a27-fd9e-5154-8bb7-46971527688f",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "HF",
    "name": "Peanut Brown",
    "nameEn": "Peanut Brown",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#875718"
    ]
  },
  {
    "id": "86e91e2b-6103-5667-b006-f1cdbb27b0cd",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "HF",
    "name": "Gray",
    "nameEn": "Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#ADB1B2"
    ]
  },
  {
    "id": "1195233a-de03-57fe-9d3e-34389cc1a16d",
    "brand": "Bambu Lab",
    "material": "PETG",
    "variant": "HF",
    "name": "Dark Gray",
    "nameEn": "Dark Gray",
    "distribution": "unicolor",
    "translucent": false,
    "sample": false,
    "colors": [
      "#515151"
    ]
  }
]
$catalog$::jsonb) AS x(id uuid,brand text,material text,variant text,name text,"nameEn" text,distribution text,translucent boolean,sample boolean,colors jsonb);
DO $$
DECLARE inv uuid;
BEGIN
 IF (SELECT count(*) FROM public.sp_inventories) <> 1 THEN
  RAISE EXCEPTION 'Se esperaba exactamente un inventario. No se ha borrado nada.';
 END IF;
 SELECT id INTO inv FROM public.sp_inventories FOR UPDATE;
 IF EXISTS(SELECT 1 FROM public.sp_filaments f JOIN spoolio_catalog_import x ON f.id=x.id WHERE f."inventoryId"=inv) THEN
  RAISE EXCEPTION 'Este catálogo ya se ha importado total o parcialmente. Se impide repetir el borrado.';
 END IF;
 IF (SELECT count(*) FROM spoolio_catalog_import) <> 270 THEN RAISE EXCEPTION 'Carga incompleta'; END IF;
 DELETE FROM public.sp_events WHERE "inventoryId"=inv;
 DELETE FROM public.sp_nfc WHERE "inventoryId"=inv;
 DELETE FROM public.sp_spools WHERE "inventoryId"=inv;
 DELETE FROM public.sp_colors WHERE "inventoryId"=inv;
 DELETE FROM public.sp_filaments WHERE "inventoryId"=inv;
 INSERT INTO public.sp_filaments("inventoryId",id,brand,material,variant,name,"nameEn",distribution,translucent,sample)
 SELECT inv,id,brand,material,variant,name,"nameEn",distribution,translucent,sample FROM spoolio_catalog_import;
 INSERT INTO public.sp_colors("inventoryId","filamentId",position,hex,name)
 SELECT inv,x.id,(c.ordinality-1)::integer,c.hex,''
 FROM spoolio_catalog_import x CROSS JOIN LATERAL jsonb_array_elements_text(x.colors) WITH ORDINALITY AS c(hex,ordinality);
 IF (SELECT count(*) FROM public.sp_filaments WHERE "inventoryId"=inv) <> 270 THEN RAISE EXCEPTION 'Recuento final incorrecto'; END IF;
END $$;
SELECT brand,material,variant,count(*) AS perfiles FROM public.sp_filaments GROUP BY brand,material,variant ORDER BY brand,material,variant;
COMMIT;
