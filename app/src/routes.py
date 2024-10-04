from flask import Flask
from src.views import home


def register_routes(app: Flask) -> None:
    app.add_url_rule('/', 'home', home.home)
