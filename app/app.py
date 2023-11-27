from flask import Flask, jsonify, request
import time
import json
import logging

app = Flask(__name__)

# Setup logging
logging.basicConfig(level=logging.INFO)

@app.route('/hello_world', methods=['GET'])
def hello_world():
    log_request()
    return jsonify(message='Hello World!'), 200

@app.route('/current_time', methods=['GET'])
def current_time():
    name = request.args.get('name', 'World')
    log_request()
    return jsonify(timestamp=int(time.time()), message=f'Hello {name}'), 200

@app.route('/healthcheck', methods=['GET'])
def healthcheck():
    log_request()
    return jsonify(message='Service is healthy'), 200

def log_request():
    log_data = {
        'method': request.method,
        'path': request.path,
        'query_parameters': dict(request.args),
        'timestamp': int(time.time())
    }
    app.logger.info(json.dumps(log_data))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80)
