import requests
import urllib.request
import json
import urllib

re = requests.get('https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY')

JTP = json.loads(re.content.decode('utf-8'))

#for img in JTP:
#	images=JTP[img]
#	print (images)

#for key, value in sorted(JTP.items()):
#	print ("key=%r, value=%r\n" % (key,value))
#count = {}
#for element in JTP:
#	count[element] = count.get(element,0) + 1
#print (count)

print ("url = %s" % JTP['url'])
print ("date = %s" % JTP['date'])
print ("description = %s" % JTP['explanation'])
url_jpg=JTP['url']
urllib.request.urlretrieve(url_jpg, "pic1.jpg")

#print (JTP)
#JTP_attr = {}
#for img in JTP:
#	for attr in JTP[img]:
#		print (JTP[img][attr])

#print ("images are: ", JTP['photos'])
#print ("JTP['img_src']: ", JTP['img_src'])

#for key, value in JsonToPython.items():
	#print ("key=%r value=%r" % (key,value))
#	image = JsonToPython.get('http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/ncam/NLB_486265192EDR_S0481570NCAM00546M_.JPG', 'Does Not Exist')
	#print (image)
	#print (JsonToPython['img_src'])

#print (re.content)
#print (json_string)




