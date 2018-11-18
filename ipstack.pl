import requests
import urllib.request
import json
import urllib
import sys

headers = {
        'Content-Type': 'application/json',
	    }
params = {
        'access_key': '5499ee2ad395fdb1c8d1612cbab59f9c',
         }
ip = sys.argv[1]
url = 'http://api.ipstack.com/' + ip
print ("processing ip %s" % ip)
response = requests.post(url, headers=headers, params=params )
J = json.loads(response.content.decode('utf-8'))
print (J)
loc = J['region_name']
print (loc)
response.raise_for_status()



