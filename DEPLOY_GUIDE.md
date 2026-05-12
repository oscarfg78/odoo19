# Guía de Despliegue Profesional - Odoo 19

Esta guía detalla los pasos necesarios para configurar, personalizar y desplegar tu instancia de Odoo 19 de manera profesional.

## 1. Configuración Inicial (Antes del Deploy)

### Archivo `.env`
El archivo `.env` centraliza todas las variables de entorno. Es crucial que cambies los siguientes valores antes de desplegar en producción:

- `POSTGRES_PASSWORD`: Cambia `odoo_password_change_me` por una contraseña fuerte.
- `ODOO_ADMIN_PASSWORD`: Cambia `admin_password_change_me`. Esta es la "Master Password" para crear/borrar bases de datos en Odoo.
- `ODOO_PORT`: Puerto en el que Odoo será accesible (por defecto 8069).

### Archivo `config/odoo.conf`
Este archivo contiene la configuración fina de Odoo. 
- **Workers**: Hemos configurado `workers = 3`. Esto activa el modo multiproceso, necesario para un rendimiento óptimo. Si tienes un servidor con pocos recursos (menos de 2GB RAM), considera bajar este valor a `0` (modo single-process).
- **Addons Path**: Ya está configurado para buscar en las carpetas `addons/` y `extra-addons/` de tu proyecto.

## 2. Gestión de Módulos (Addons)

- **`addons/`**: Usa esta carpeta para tus módulos personalizados o desarrollos propios.
- **`extra-addons/`**: Usa esta carpeta para módulos descargados de la Odoo App Store o terceros.

Cualquier carpeta dentro de estas será detectada automáticamente por Odoo.

## 3. Despliegue

Para iniciar la instancia, ejecuta:

```bash
docker-compose up -d
```

Esto levantará:
- **web**: El servidor de Odoo.
- **db**: PostgreSQL 16 (optimizado).
- **redis**: Para gestión de sesiones y caché (opcional pero recomendado).

## 4. Verificación y Logs

Puedes monitorear el estado de la instancia con:

```bash
docker-compose ps
```

Para ver los registros en tiempo real:

```bash
docker-compose logs -f web
```

Los logs también se guardan persistentemente en la carpeta `./logs/odoo-server.log`.

## 5. Mantenimiento y Backups

- **Base de Datos**: Los datos de PostgreSQL persisten en un volumen de Docker llamado `odoo-db-data`.
- **Archivos**: Los documentos y adjuntos se guardan en el volumen `odoo-data`.
- **Backup**: Se recomienda usar herramientas como `docker-exec` para realizar dumps de la base de datos periódicamente.

---
**Nota de Seguridad**: Nunca subas el archivo `.env` a repositorios públicos si contiene contraseñas reales. Añade `.env` a tu `.gitignore`.
