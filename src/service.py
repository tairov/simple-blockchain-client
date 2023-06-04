"""
webservice for REST API
"""

from flask import Flask
from flask_httpauth import HTTPBasicAuth
from flask import jsonify
from dataprovider import DataProvider
from dotenv import dotenv_values
from werkzeug.middleware.dispatcher import DispatcherMiddleware
from prometheus_client import make_wsgi_app
from metrics import stats
import os
import logging


def create_app():
    app = Flask(__name__)
    return app


app = create_app()

auth = HTTPBasicAuth()

config = dotenv_values('.env')

# default environment is `dev`
ENVIRONMENT = os.getenv('FLASK_ENV', 'development')

DEBUG_MODE = ENVIRONMENT == 'development'

format = '[%(asctime)s] %(levelname)s %(message)s'
logging.basicConfig(format=format, level=logging.INFO,
                    datefmt="%H:%M:%S")


@app.route('/block/', methods=['GET'])
def get_block():
    logging.info(f"get_block request")
    stats.inc('requests')
    dp = DataProvider(config)

    try:
        result = dp.get_block_number()
    except Exception as ex:
        stats.inc('exceptions')
        return jsonify({'error_msg': str(ex)})

    response = jsonify({'number': result})
    return response


@app.route('/block_by_number/<number>', methods=['GET'])
def get_block_by_number(number):
    logging.info(f"get_block_by_number request for id {number}")
    stats.inc('requests')
    dp = DataProvider(config)

    try:
        result = dp.get_block_by_number(number)
    except Exception as ex:
        stats.inc('exceptions')
        return jsonify({'error_msg': str(ex)})

    response = jsonify(result)
    return response


@app.route('/health')
def health():
    return jsonify({'status': 'running'})


# Add prometheus wsgi middleware to route /metrics requests
app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {
    '/metrics': make_wsgi_app()
})
