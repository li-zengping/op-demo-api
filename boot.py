from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/healthy')
def healthy():
    is_healthy = True
    response_data = {'status': 'healthy' if is_healthy else 'unhealthy'}
    return jsonify(response_data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

