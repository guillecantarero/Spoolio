# Supabase: despliegue de Spoolio

Estado al 19/11/2026: usuario confirma esquema inicial y tres cuentas con membresía. Salud remota comprobada; operaciones autenticadas pendientes de validación. Estas instrucciones de creación son para instalaciones nuevas: no repetirlas en el proyecto existente.

## Proyecto gratuito

1. Crear el proyecto en tu cuenta, preferiblemente región europea. Guardar la contraseña de PostgreSQL en tu gestor de contraseñas.
2. Activar Data API y RLS por defecto; dejar desactivado el permiso automático de API para tablas nuevas. La migración concede permisos explícitos.
3. Ejecutar `supabase/migrations/202611190001_spoolio.sql` en SQL Editor. Conservar este archivo en Git. No repetir una migración ya aplicada.
4. En Authentication, desactivar nuevos registros públicos. Crear inicialmente la cuenta de Guillermo con correo y contraseña (confirmadas administrativamente para esta primera prueba). Para invitaciones y recuperación por correo configurar un SMTP propio; no dar por preparado el envío de emails del proyecto.
5. Copiar `supabase/bootstrap.example.sql` a un archivo local fuera de Git, verificar el correo de la cuenta inicial y ejecutarlo en SQL Editor. No crea cuentas: autoriza la cuenta ya creada y crea su ubicación y Fablab. Los correos example.com fueron solo marcadores y no deben usarse para cuentas reales. El usuario confirmó que ya creó Juan y Óscar con sus correos definitivos y ejecutó sus altas de membresía y ubicación. No volver a crearlos ni ejecutar este bootstrap en el proyecto actual. Se revierte entero si falta alguna cuenta.
6. Copiar `.env.example` a `.env.local`, poner `VITE_DATA_MODE=supabase`, URL del proyecto y clave **publishable** (o anon heredada). Nunca service_role, sb_secret ni contraseña SQL. Reiniciar Vite.
7. `npm run dev`. Entrar con una cuenta; crear un filamento y una bobina; consultar desde otra cuenta, trasladar y retirar. Las consultas se refrescan cada 15 segundos cuando la pestaña está visible y no se está editando, y al volver a la ventana. NFC obtiene datos recientes antes de identificar.
8. APK: requiere compilación con estas variables cuando el usuario la autorice. La APK 0.2.1 sigue siendo local.

## Integridad y permisos

Tablas separadas para inventarios, miembros, ubicaciones, catálogo, colores ordenados, unidades, UID e historial. RLS permite leer solo inventarios de los que eres miembro. Usuarios autenticados no pueden escribir tablas directamente; `sp_command` comprueba membresía, obtiene actor del JWT y guarda operación e historial en una transacción. No hay registro público en la app ni API de autoasignación de membresía.

Las bobinas usan versión optimista. El catálogo compara el perfil original con el actual antes de modificar/eliminar. No se escribe de forma optimista en la UI ni se encolan escrituras sin conexión. Se refresca después de guardar. UID único por inventario, incluidas unidades retiradas. Claves foráneas compuestas impiden mezclar datos de inventarios diferentes. El servidor fija las fechas.

La demo local se conserva separada. No se importan ejemplos ni datos del Pixel automáticamente. Exportar los datos antes de instalar una futura APK remota y acordar una importación explícita que mapee usuarios y ubicaciones preservando historial y UID.

## Monitor del otro mini PC

Consulta solo `sp_health` (fila pública con estado `ok`), sin credenciales de usuario ni privilegios de escritura. No accede al inventario. Tres ejecuciones diarias, con retraso aleatorio de hasta 30 minutos, bastan para una comprobación modesta; no genera escrituras ni consultas aleatorias a datos reales. No se garantiza que esta actividad evite la pausa gratuita de Supabase.

Requiere Node 22+. Prueba manual en Windows o Linux desde `scripts/monitor`, tras copiar `.env.example` a `.env` y completar URL y clave pública:

```sh
node --env-file=.env check-health.mjs
```

Para Linux con systemd:

```sh
sudo mkdir -p /opt/spoolio-monitor
sudo cp scripts/monitor/check-health.mjs /opt/spoolio-monitor/
sudo cp scripts/monitor/.env.example /etc/spoolio-monitor.env
sudo chmod 600 /etc/spoolio-monitor.env
sudoedit /etc/spoolio-monitor.env
sudo cp scripts/monitor/spoolio-monitor.service scripts/monitor/spoolio-monitor.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start spoolio-monitor.service
sudo systemctl enable --now spoolio-monitor.timer
sudo journalctl -u spoolio-monitor.service -n 20
systemctl list-timers spoolio-monitor.timer
```

Comprobar que Node esté en `/usr/bin/node` o ajustar ExecStart. En Windows usar Programador de tareas con la misma ejecución de Node y tres horarios diarios. Salida 0 significa consulta correcta; otra salida indica fallo, visible en los registros. No hay notificaciones externas configuradas.

## Copias y recuperación

El monitor **no es una copia de seguridad**. Antes de cargar datos reales, configurar exportaciones de PostgreSQL desde una máquina de confianza (credenciales solo locales) y almacenamiento cifrado fuera del equipo; incluir datos de Auth y esquema, verificar una restauración en un proyecto de prueba y documentar la retención. El plan gratuito no incorpora las copias automáticas del plan de pago. La copia JSON local de la app no sustituye una copia completa del servidor.

## Verificación

`npm test` ejecuta la migración en PostgreSQL embebido (PGlite) con roles anon/authenticated y prueba RLS, escritura denegada, altas, traslado, retirada, UID duplicado, conflicto de versión y reversión de transacciones. Esto no valida el servicio Auth, red, API real ni NFC físico: requieren el proyecto desplegado y cuentas reales.

Fuentes: https://supabase.com/docs/guides/database/postgres/row-level-security · https://supabase.com/docs/guides/database/functions · https://supabase.com/docs/guides/platform/free-project-pausing

## Sesión y configuración actual

URL recibida: https://pqumkpybdhzhyajuvdgg.supabase.co. Guardada en .env.local (ignorado por Git); clave pública recibida y guardada localmente; modo supabase activado en este PC. Comprobación remota: sp_health responde 200 con estado ok y la lectura anónima de sp_inventories se deniega (401/42501). Falta validar inicio de sesión y membresía con la cuenta real. Auth todavía anuncia disable_signup=false: desactivar registros públicos en el panel. La sesión remota se conserva automáticamente entre aperturas y se renueva mediante Supabase Auth. Configuración permite cerrarla. Se guardan tokens, no la contraseña; borrar los datos de la aplicación elimina la sesión local.




- Cambio de contraseña disponible en Configuración para cuentas remotas: actual + nueva + confirmación, mediante Auth updateUser con current_password. No requiere migración SQL. Pendiente de próxima APK y prueba con cuenta real.

Para el cambio de equipo, consultar [CONTINUAR_EN_CASA.md](CONTINUAR_EN_CASA.md). La importación del catálogo está preparada en [supabase/catalog](../supabase/catalog/README.md), cargada según confirmación del usuario el 19/11/2026. No repetir el SQL de reemplazo.
