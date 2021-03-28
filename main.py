
from flask import Flask
from flask import request
from request_helper import * 
import os

#BASE_URL = "http://34.107.139.209"
BASE_URL = 'http://zone-printer-service.zp.svc.clusterset.local:8080'
requestHelper = RequestHelper()

app = Flask(__name__)



@app.route('/health')
def hello_world():
    return 'Healthy'


@app.route('/callme', methods=['GET'])
def callme():
    print('Hello world')
    return requestHelper.getData(requestHelper.getNewBasicSession(), BASE_URL + '/ping').json()
    #return 'Hello world'



if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
