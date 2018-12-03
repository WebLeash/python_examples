import requests
import sys
from requests.auth import HTTPBasicAuth


arguments = len(sys.argv) - 1
if arguments > 0:
    print ("Script name = %s arg = %s" % (sys.argv[0],sys.argv[1]));

user = sys.argv[1]
passwd = sys.argv[2]
url = sys.argv[3]
method = sys.argv[4]
file_pl = sys.argv[5]
auth_values = (user,passwd)
headers = {'content-type':'application/json'}

f = open(file_pl, "r")
content = f.read()

print ("auth_values = %s\nurl = %s\npayload = %s" % (auth_values,url,content))

#r = requests.post(url,auth=('user','passwd'),content, headers=headers)
r = requests.post(url,content, headers=headers,auth=auth_values)

print (r.status_code)


