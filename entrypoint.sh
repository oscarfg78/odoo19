#!/bin/bash

# --- Railway Database Mapping ---
# Railway provides PGHOST, PGUSER, etc. Odoo expects HOST, USER, etc.
export HOST=${HOST:-$PGHOST}
export USER=${USER:-$PGUSER}
export PASSWORD=${PASSWORD:-$PGPASSWORD}
export DB_PORT=${DB_PORT:-$PGPORT}

# --- Port Handling ---
# Railway provides a dynamic $PORT. Odoo needs to know this.
HTTP_PORT=${PORT:-8069}

echo "Starting Odoo 19 on port $HTTP_PORT..."
echo "Database Host: $HOST"

# Start Odoo
# We pass the port via command line to ensure it overrides any config file
exec odoo -c /etc/odoo/odoo.conf --http-port=$HTTP_PORT "$@"
