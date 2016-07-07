import sys
import os
import json
import requests
import time

android_count=ios_count=web_count=unknown_count = 0

for file in os.listdir('/Users/rajan/logs'):
	print 'Looking in file: '+file
	time.sleep(2)
	with open('/Users/rajan/logs/'+file,'r') as infile:
		for line in infile:
			data = json.loads(line)
			user_id = data['user_id']
			reason = data['reason']
			device_id = data['events']['deviceId']
			device_req = requests.get('http://api.pressplaytv.in/fetch/device/'+device_id)
			device_response = device_req.json()
			
			if 'status' in device_response:
				if (device_response['status'] == 'failed'):
					unknown_count += 1
			else:
				os_family = device_response['os_family']
			
			user_req = requests.get('http://api.pressplaytv.in/fetch/user/'+user_id)
			user_response = user_req.json()
			
			if 'status' in user_response:
				if (user_response['status'] == 'failed'):
					unknown_count += 1
			else:
				source = user_response['source']

			if device_id != 'null' or device_id != '' or user_id != 'null' or user_id != '':
				if source == 'native':
					if os_family == 'iOS':
						ios_count += 1 
					elif os_family == 'Android':
						android_count += 1
					else:
						unknown_count += 1	
				elif source == 'web':
					if os_family == 'iOS':
						ios_count += 1 
						web_count =+ 1
					elif os_family == 'Android':
						android_count += 1
						web_count =+ 1
					else:
						unknown_count += 1
						web_count += 1
			else:
				unknown_count += 1			
				
#			print 'user_id: '+user_id,'device_id: '+device_id,'source: '+source,'os_family: '+os_family

#			time.sleep(1)
#			print 'ANDROID: '+str(android_count)+'   '+'IOS: '+str(ios_count)+'   '+'WEB: '+str(web_count)+'   '+'UNKNOWN: '+str(unknown_count)
print 'Total ANDROID: '+str(android_count)
print 'Total IOS: '+str(ios_count)
print 'Total WEB: '+str(web_count)
print 'Total UNKNOWN: '+str(unknown_count)