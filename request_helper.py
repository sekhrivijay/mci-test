import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry

import logging
logging.basicConfig(level=logging.INFO)
HTTP_TIMEOUT=30



class RequestHelper():
    def __init__(self):
        self.retries = Retry(
            total = 3, 
            read = 3, 
            connect = 5, 
            backoff_factor = 1, 
            status_forcelist = [400, 403, 408, 409, 411, 417, 422, 429, 500, 502, 503, 504],
            method_whitelist = ["HEAD", "GET", "PUT", "DELETE", "OPTIONS", "TRACE", "POST"])
        self.adapter = HTTPAdapter(max_retries = self.retries)

    def getNewBasicSession(self):
        session = requests.Session()
        return session


    def getNewSession(self):
        session = requests.Session()
        session.mount("https://", self.adapter)
        session.mount("http://", self.adapter)
        return session


    def postData(self, session, uri, headers=None, data=None):
        logging.info ('posting ' + self.maskUri(uri) + ' headers ' +  str(headers) +  ' data' + str(data))
        return session.post(uri , timeout=HTTP_TIMEOUT, headers=headers, json = data)

    def putData(self, session, uri, headers=None, data=None):
        logging.info ('putting ' + self.maskUri(uri) + ' headers ' +  str(headers) +  ' data' + str(data))
        return session.put(uri , timeout=HTTP_TIMEOUT, headers=headers, json = data)

    def getData(self, session, uri, headers=None):
        logging.info ('getting ' + self.maskUri(uri) + ' headers ' +  str(headers))
        return session.get(uri , timeout=HTTP_TIMEOUT, headers=headers)

    def deleteData(self, session, uri, headers=None, data=None):
        logging.info ('deleting ' + self.maskUri(uri) + ' headers ' +  str(headers) +  ' data' + str(data))
        return session.delete(uri , timeout=HTTP_TIMEOUT, headers=headers)


    def maskUri(self, uri):
        if '@' in uri:
            return '//' + ''.join(uri.split('@')[1:])
        return uri