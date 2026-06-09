#!/bin/bash

# --- Railway Database Mapping ---
# Railway provides PGHOST, PGUSER, etc. Odoo expects HOST, USER, etc.
export HOST=${HOST:-$PGHOST}
export USER=${USER:-$PGUSER}
export PASSWORD=${PASSWORD:-$PGPASSWORD}
export DB_PORT=${DB_PORT:-$PGPORT}
# Validate required environment variables
required_vars=("HOST" "USER" "PASSWORD" "DB_PORT" "PORT")
for var in "${required_vars[@]}"; do
  if [ -z "$(eval echo \$$var)" ]; then
    echo "Error: $var environment variable not set. Railway must provide it."
    exit 1
  fi
done

# --- Railway Default User Workaround ---
# Odoo blocks the 'postgres' user for security reasons.
# Railway's default Postgres plugin uses 'postgres'.
# We will automatically create an 'odoo' role if 'postgres' is detected.
if [ "$USER" = "postgres" ]; then
    echo "Detected 'postgres' database user. Odoo blocks this for security."
    echo "Attempting to create an 'odoo' role in the database..."
    export PGPASSWORD=$PASSWORD
    # Run SQL command to create the role if it doesn't exist.
    # The default database in Railway Postgres is 'railway'.
    psql -h "$HOST" -p "$DB_PORT" -U "postgres" -d "railway" -c "DO \$\$ BEGIN IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'odoo') THEN CREATE ROLE odoo LOGIN SUPERUSER CREATEDB PASSWORD '$PASSWORD'; END IF; END \$\$;"
    
    # Switch Odoo to use the newly created role
    export USER="odoo"
    echo "Successfully switched Odoo database user to 'odoo'."
fi

# --- Port Handling ---
# Railway provides a dynamic $PORT. Odoo needs to know this.
HTTP_PORT=${PORT:-8069}

echo "Starting Odoo 19 on port $HTTP_PORT..."
echo "Database Host: $HOST"

# Start Odoo
# We pass the port via command line to ensure it overrides any config file
exec odoo -c /etc/odoo/odoo.conf --http-port=$HTTP_PORT "$@"
