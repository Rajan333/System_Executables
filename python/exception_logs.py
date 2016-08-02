import sys
import os
import json
import requests
import time

global reason_count,android_count,ios_count,web_count,unknown_count 
reason_count=android_count=ios_count=web_count=unknown_count = 0
exception_reason = {}
events = {}

def bhasad(reason,device_id,user_id):
	global reason_count,android_count,ios_count,web_count,unknown_count			
	device_req = requests.get('http://api.pressplaytv.in/fetch/device/'+device_id)
	device_response = device_req.json()
	
	 		
	if reason not in exception_reason:
		exception_reason[reason] = 0
	exception_reason[reason] += 1				

	if device_id not in events:
		events[device_id] = {'count': 0, 'os_family':'Unknown'}
		#events[user_id] = 0
	events[device_id]['count'] += 1
	#events[user_id] += 1

	if 'status' in device_response:
		if (device_response['status'] == 'failed'):
			unknown_count += 1
	else:
		os_family = device_response['os_family']
		events[device_id]['os_family'] = os_family
	
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
				web_count += 1
			elif os_family == 'Android':
				android_count += 1
				web_count += 1
			else:
				unknown_count += 1
				web_count += 1
	else:
		unknown_count += 1

for file in os.listdir('/Users/rajan/logs'):
	if file.count('worker') == 0:
		print 'Looking in file: '+file
		time.sleep(1)
		with open('/Users/rajan/logs/'+file,'r') as infile:
			for line in infile:
				data = json.loads(line)
				user_id = data['user_id']
				reason = data['reason']
				event = data['events']

				if type(event) == list:
					for items in data['events']:	
				 		event_id = items['eventId']
				 		device_id = items['deviceId']
				 		bhasad(reason,device_id,user_id)	
				else:	
					event_id = data['events']['eventId']
					device_id = data['device_id']
					bhasad(reason,device_id,user_id) 		

print '\n'

print '##########################################################################################'
print '                         TOTAL COUNT                                            '
print '##########################################################################################'					
print 'Total ANDROID: ',android_count
print 'Total IOS: ','\t',ios_count
print 'Total WEB: ','\t',web_count
print 'Total UNKNOWN: ',unknown_count
#print '################################################################################'
print '\n'
print '##########################################################################################'
print '                        EXCEPTION REASON                                       '
print '##########################################################################################'
#print 'Exception Reason:'
for key,value in exception_reason.iteritems():
	print  'Reason: ', key,'\tCount: ',value
#print '##########################################################################################'
print '\n' 	
print '##########################################################################################'
print '                              EVENTS                                           '
print '##########################################################################################'
for key,value in events.iteritems():
	print 'Device Id: ',key, '\tCount: ',value['count'],'\tos_family: ',value['os_family']
print '\n'
print '*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*THE END-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*'		

