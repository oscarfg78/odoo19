# Guía de Despliegue Profesional - Odoo 19

Esta guía detalla los pasos para desplegar Odoo 19 tanto en un entorno local (Docker Compose) como en la nube (**Railway**).

## 1. Despliegue en Railway (Recomendado para Producción)

Para una mayor estabilidad y eficiencia en Railway, sigue estas recomendaciones:

### A. Base de Datos Gestionada
En lugar de correr PostgreSQL en un contenedor, utiliza el servicio de **PostgreSQL de Railway**.
1. En Railway, haz clic en `+ New` -> `Database` -> `PostgreSQL`.
2. Railway generará variables como `PGHOST`, `PGUSER`, `PGPASSWORD`. Nuestro script `entrypoint.sh` detectará estas variables automáticamente.

### B. Volúmenes Persistentes (Crítico)
Odoo guarda archivos (imágenes, documentos) en el sistema de archivos. Para no perderlos al reiniciar:
1. En Railway, selecciona tu servicio de Odoo.
2. Ve a la pestaña **Settings** -> **Volumes** -> **Add Volume**.
3. Monta el volumen en la ruta: `/var/lib/odoo`.

### C. Variables de Entorno en Railway
Configura las siguientes variables en la pestaña **Variables** de tu servicio Odoo en Railway:
- `ODOO_PASSWORD`: Tu "Master Password" para gestionar bases de datos.
- `PORT`: (Asignada automáticamente por Railway).
- `HOST`, `USER`, `PASSWORD`, `PORT`: (Si no usas el Postgres de Railway, define aquí los datos de tu DB externa).

---

## 2. Configuración Local (Docker Compose)

### Archivo `.env`
Centraliza los valores locales. Cambia `POSTGRES_PASSWORD` y `ODOO_ADMIN_PASSWORD` antes de iniciar.

### Archivo `config/odoo.conf`
- **Workers**: Configurado en `2` por defecto. Si tienes poca RAM (<1GB), cámbialo a `0`.
- **Addons Path**: Configurado para buscar en `addons/` y `extra-addons/`.

---

## 3. Gestión de Módulos (Addons)

- **`addons/`**: Módulos personalizados (tus desarrollos).
- **`extra-addons/`**: Módulos de terceros o de la Odoo Store.

Ambas carpetas se sincronizan automáticamente con el contenedor.

---

## 4. Comandos de Despliegue

### Local
```bash
docker-compose up -d
```

### Logs
Para ver qué está pasando en tiempo real:
```bash
# Local
docker-compose logs -f web

# Railway
# Usa la pestaña "Logs" en el dashboard de Railway.
```

---

## 5. Mantenimiento y Seguridad

- **Proxy Mode**: Está habilitado por defecto (`proxy_mode = True`), lo cual es necesario para que el SSL de Railway funcione correctamente.
- **Backups**: Si usas el Postgres gestionado de Railway, los backups son automáticos. Si usas Docker local, asegúrate de respaldar el volumen `odoo-db-data`.
- **Seguridad**: Asegúrate de que `.env` esté en tu `.gitignore`.
