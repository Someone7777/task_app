#!/bin/sh

# Exit immediately if any of the following command exits 
# with a non-zero status
set -e

# Postgres checking
until psql $DATABASE_URL -c '\l'; do
    >&2 echo "Postgres is unavailable - sleeping"
    sleep 20
done
>&2 echo "Postgres is up - continuing"

# Create log directory
touch /var/log/task_app/app.log
chmod 777 /var/log/task_app/app.log

# Create backup directory
mkdir -p /var/backup
chmod 777 /var/backup

# Call collectstatic
python manage.py collectstatic --noinput

# Execute database migrations
if  python manage.py migrate --check; then
    echo Migrations applied
else
    echo Applying migrations
    python manage.py migrate --noinput
fi

# Create superuser
if  python manage.py createsuperuser --no-input; then
    echo Superuser created
else
    echo Superuser already created, skipping
fi

# App commands
# TODO

cat << "EOF"

 _____         _     ___  ____________ 
|_   _|       | |   / _ \ | ___ \ ___ \
  | | __ _ ___| | _/ /_\ \| |_/ / |_/ /
  | |/ _` / __| |/ /  _  ||  __/|  __/ 
  | | (_| \__ \   <| | | || |   | |    
  \_/\__,_|___/_|\_\_| |_/\_|   \_|                                                                                                        p)      p)     


EOF

APP_USER_UID=`id -u $APP_USER`
exec uwsgi --uid=$APP_USER_UID --http-auto-chunked --http-keepalive --ini app.uwsgi.ini "$@"