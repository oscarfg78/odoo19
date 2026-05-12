# Usamos la imagen oficial de Odoo 19
FROM odoo:19.0

USER root

# Instalamos dependencias adicionales del sistema si son necesarias
# git: útil para clonar repositorios de addons
# curl: para comprobaciones de salud o descargar recursos
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Creamos el directorio de logs y ajustamos permisos
RUN mkdir -p /var/log/odoo && chown -R odoo:odoo /var/log/odoo

# Volvemos al usuario odoo para seguridad
USER odoo
