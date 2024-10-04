#! /bin/sh

if [ ! -d "migrations" ]; then
  echo "Initialising database migrations..."
  flask db init
  flask db migrate -m "Initial migration"
fi

flask db upgrade

exec gunicorn --bind 0.0.0.0:5000 wsgi:app