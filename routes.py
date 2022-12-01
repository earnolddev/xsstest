from flask import Flask, render_template, request
from urllib.parse import urlparse, urlencode
import os
import urllib
import base64
import requests
import json

###############################CONFIG#######################################
BUILTINPORT = 5000
TWISTEDPORT = 5000
TWISTEDLOGFILE = "app.log"
app = Flask(__name__, static_folder='static', static_url_path='')
app.config['MAX_CONTENT_LENGTH'] = 100 * 1024 * 1024
# Session seed, for per-session data
app.secret_key = os.urandom(24)


################################METHODS######################################
## Start up Stuff

# start a built in flask server
def builtin():
	#print 'Built-in development server on port {port}...'.format(port=BUILTINPORT)
	app.run(host="0.0.0.0",port=BUILTINPORT,debug=True)

## END Start up Stuff


###############################VIEWS#######################################

@app.route("/")
def home():
	return render_template('formsubmit.html')


@app.route('/hello/', methods=['GET'])
def hello():
    name = request.args.get('yourname', '')
    email = request.args.get('youremail', '')
	#construct encoded parameters
    path = request.full_path
    full_path = str("GET "+str(path)+" HTTP/1.1")
    headers = str(request.headers)
    url = request.url
    response = render_template('formaction.html', name=name, email=email)

    response_enc = urllib.parse.quote_plus(base64.standard_b64encode(response.encode('utf-8')))
    url_enc = urllib.parse.quote_plus(base64.standard_b64encode(url.encode('utf-8')))
    request_enc = urllib.parse.quote_plus(base64.standard_b64encode(full_path.encode('utf-8')+headers.encode('utf-8')))

	#send postto phantomjs
    data = str("http-response="+response_enc+"&http-url="+url_enc+"&http-headers="+request_enc)
    content = {'Content-Type': 'application/x-www-form-urlencoded'}
    r = requests.post("http://127.0.0.1:8093/", data=data, headers=content)

	#read response from phantomjs
    xss = json.dumps(r.json(), indent=4)
    if "1" in (xss):
        return render_template('flag.html', name=name, email=email)
    else:       
        return render_template('noflag.html')


if __name__ == "__main__":
    #twisted()
    builtin()
else:
    print ('This program is not meant to be included in any other script and will not function as such.')
    import sys
    sys.exit(1)
