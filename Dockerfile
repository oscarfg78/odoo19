# Usamos la imagen oficial de Odoo 19
FROM odoo:19.0

USER root

# Instalamos dependencias adicionales del sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Creamos directorios necesarios y ajustamos permisos
RUN mkdir -p /var/log/odoo /mnt/extra-addons/addons /mnt/extra-addons/extra-addons \
    && chown -R odoo:odoo /var/log/odoo /mnt/extra-addons /var/lib/odoo

# Copiamos el script de entrada y la configuración
COPY ./entrypoint.sh /entrypoint.sh
COPY ./config/odoo.conf /etc/odoo/odoo.conf

RUN chmod +x /entrypoint.sh \
    && chown odoo:odoo /entrypoint.sh /etc/odoo/odoo.conf

# Volvemos al usuario odoo
USER odoo

# Definimos el script de entrada
ENTRYPOINT ["/entrypoint.sh"]
