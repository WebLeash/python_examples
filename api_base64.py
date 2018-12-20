import json
import sys
import urllib2
import base64

api_url="https://#####################################################"
api_user="username:password"

#json_file="/tmp/last.json"
success_msg="HTTP/1.1 200 OK"

# Input argument
JSON_DATA=sys.argv[1]

# Append and Prepend []

inputString = "["
for line in JSON_DATA:
   inputString += line
inputString += "]"
# Parse the array of payloads
payloads = json.loads(inputString)
# Merge u_deployment_targets
mergedDeploymentTargets = []
for payload in payloads:
   mergedDeploymentTargets.extend(payload["u_deployment_targets"])
# Compose the merged target payload
mergedPayload = payloads[0]
mergedPayload["u_deployment_targets"] = mergedDeploymentTargets

# Stringify the payload
jsonOutput=json.dumps(mergedPayload, indent=2, sort_keys=True)
print (jsonOutput)

# Post json to snow api
req=urllib2.Request(api_url)
req.add_header('Content-Type', 'application/json')
userAndPass = base64.b64encode(api_user)
#print (userAndPass)
req.add_header("Authorization", 'Basic %s' % userAndPass)
response = urllib2.urlopen(req,jsonOutput)
