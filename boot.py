from flask import Flask
from flask import request, Response
app = Flask(__name__)
import json

@app.route('/healthy', methods=['GET', 'POST'])
def healthyRun():
    if request.method == "GET":
       parameterInfo = "healthy success"
       client = request.remote_addr
       return Response(json.dumps({"code": 200, "data": parameterInfo,"clientIp":client}), mimetype='application/json')
    else:
       parameterInfo = "请求不支持,请检查"
       return Response(json.dumps({"code": 500, "data": parameterInfo}), mimetype='application/json')
if __name__ == '__main__':
    app.run(
        host="0.0.0.0",
        port=8080,
        debug=True
    )
