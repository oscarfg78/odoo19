# Usamos la imagen oficial de Odoo 19
FROM odoo:19.0

# Cambiamos a root para ajustar permisos si es necesario
USER root

# Instalamos dependencias adicionales de Python o del sistema si las necesitas
# RUN apt-get update && apt-get install -y python3-dev

# Volvemos al usuario odoo
USER odoo
