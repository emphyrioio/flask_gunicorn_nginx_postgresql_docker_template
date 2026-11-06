# flask_gunicorn_nginx_postgresql_docker_template
A Docker template for a Flask application with Gunicorn, Nginx and PostgreSQL.

# Recommanded version of Docker
Docker 27.x

# Database credentials
Copy the example and set a real password (`environment/db.env` is not versioned):

    cp environment/db.env.example environment/db.env

# Build and run with dev profile
docker compose --project-name myflaskapp --profile dev watch

docker compose --project-name myflaskapp --profile prod watch

# Wipe
docker rm -f $(docker ps -a -q) && docker system prune -a -f --volumes && sudo rm -rf data/postgres

# TODO
