from flask import Flask
from src.config.config import Config


def create_app() -> Flask:
    app = Flask(__name__)
    app.config.from_object(Config)

    from src.config.extensions import db, migrate

    db.init_app(app)
    migrate.init_app(app, db)

    from src.routes import register_routes

    register_routes(app)

    return app
