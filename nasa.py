import requests
import json

re = requests.get('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=v4TvVJY91oXrtZPT5A7RnCiiiruKjd6y7IPfJHfR')

json_string = json.dumps(re.content)

print (re.status_code)
#print (re.content)
#print (json_string)

da = json.loads(json_string)
print (da["img_src"])



