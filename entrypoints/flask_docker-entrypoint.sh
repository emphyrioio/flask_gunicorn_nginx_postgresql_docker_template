#! /bin/sh

if [ ! -d "migrations" ]; then
  echo "Initialising database migrations..."
  flask db init
  flask db migrate -m "Initial migration"
fi

flask db upgrade

if [ "$FLASK_ENV" = "production" ]; then
  echo "Running in production mode"
  exec gunicorn --bind 0.0.0.0:5000 wsgi:app
else
  echo "Running in development mode"
  exec flask run --host=0.0.0.0 --port=5000
fi