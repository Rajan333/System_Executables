import os
import sys
import json
import urllib

directories = ['content', 'poster', 'posterSmall']
for directory in directories:
	os.mkdir(directory)

json_file = sys.argv[1]

with open(json_file) as data_file:
	
	data = json.load(data_file)
	data['downloadUrl'] = 'download_url'
	
	for content_id in data["content"]:
		try:
			print data['content'][content_id]['itemData']['ppId']
			for item in data['content'][content_id]['itemContents']:
					for sub_item in item:
							sub_item['poster'] = "http://pressplaytv.in/static/posters/"+sub_item['poster'].split('/')[-1]
							sub_item['posterSmall'] = "http://pressplaytv.in/static/posters/"+sub_item['posterSmall'].split('/')[-1]
							if sub_item['type'] == "video":
								sub_item['localUrl'] = "http://pressplaytv.in/static/stream/"+sub_item['ppId']+"/mp4"
							if sub_item['type'] == "audio":
								sub_item['localUrl'] = "http://pressplaytv.in/static/stream/"+sub_item['ppId']+"/mp3"
							#print sub_item['posterSmall']
						
		except TypeError:
			continue

	for channel in data["channels"]:
		try:
			print data['channels'][channel]['itemData']['ppId']
			for item in data['channels'][channel]['itemContents']:
					for sub_item in item:
							sub_item['poster'] = "http://pressplaytv.in/static/posters/"+sub_item['poster'].split('/')[-1]
							sub_item['posterSmall'] = "http://pressplaytv.in/static/posters/"+sub_item['posterSmall'].split('/')[-1]
							if sub_item['type'] == "video":
								sub_item['localUrl'] = "http://pressplaytv.in/static/stream/"+sub_item['ppId']+"/mp4"
							if sub_item['type'] == "audio":
								sub_item['localUrl'] = "http://pressplaytv.in/static/stream/"+sub_item['ppId']+"/mp3"
							#print sub_item['posterSmall']
						
		except TypeError:
			continue
			
		testfile = urllib.URLopener()

		#testfile.retrieve(data['content'][content_id]['itemData']['localUrl'],"content/"+data['content'][content_id]['itemData']['ppId']+".mp4")
		testfile.retrieve(data['content'][content_id]['itemData']['poster'],"poster/"+data['content'][content_id]['itemData']['poster'].split('/')[-1])
		testfile.retrieve(data['content'][content_id]['itemData']['posterSmall'],"posterSmall/"+data['content'][content_id]['itemData']['posterSmall'].split('/')[-1])

	for content_id in data["content"]:
		data['content'][content_id]['itemData']['poster'] = "http://pressplaytv.in/static/posters/"+data['content'][content_id]['itemData']['poster'].split('/')[-1]
		data['content'][content_id]['itemData']['posterSmall'] = "http://pressplaytv.in/static/posters/"+data['content'][content_id]['itemData']['posterSmall'].split('/')[-1]
		if data['content'][content_id]['itemData']['type'] == "video":
			data['content'][content_id]['itemData']['localUrl'] = "http://pressplaytv.in/stream/"+data['content'][content_id]['itemData']['ppId']+"/mp4"
			data['content'][content_id]['itemData']['downloadUrl'] = "http://pressplaytv.in/download/"+data['content'][content_id]['itemData']['ppId']+"/mp4"
		else:
			data['content'][content_id]['itemData']['localUrl'] = "http://pressplaytv.in/stream/"+data['content'][content_id]['itemData']['ppId']+"/mp3"
			data['content'][content_id]['itemData']['downloadUrl'] = "http://pressplaytv.in/download/"+data['content'][content_id]['itemData']['ppId']+"/mp3"

######## FOR /COLLECTION ######
	
	#data = json.load(data_file)
	for feed in data['feeds']['/collection']:
		for item in feed:
			print item['poster']
			item['poster'] = "http://pressplaytv.in/static/posters/"+item['poster'].split('/')[-1]
			item['posterSmall'] = "http://pressplaytv.in/static/posters/"+item['posterSmall'].split('/')[-1]

######### FOR /CHANNEL ##########
	for feed in data['feeds']['/channel']:
		for item in feed:
			item['poster'] = "http://pressplaytv.in/static/posters/"+item['poster'].split('/')[-1]
			item['posterSmall'] = "http://pressplaytv.in/static/posters/"+item['posterSmall'].split('/')[-1]
			
########## FOR /HOME ############
	for feed in data['feeds']['/home']:
		for item in feed:
			item['poster'] = "http://pressplaytv.in/static/posters/"+item['poster'].split('/')[-1]
			item['posterSmall'] = "http://pressplaytv.in/static/posters/"+item['posterSmall'].split('/')[-1]

			if item['type'] == "video":
				item['localUrl'] = "http://pressplaytv.in/static/stream/"+item['ppId']+"/mp4"
			if item['type'] == "audio":
				item['localUrl'] = "http://pressplaytv.in/static/stream/"+item['ppId']+"/mp3"

	for content_id in data["channel"]:
		print data['channel'][content_id]['itemData']['ppId']		
		
		data['channel'][content_id]['itemData']['poster'] = "http://pressplaytv.in/static/posters/"+data['channel'][content_id]['itemData']['poster'].split('/')[-1]
		data['channel'][content_id]['itemData']['posterSmall'] = "http://pressplaytv.in/static/posters/"+data['channel'][content_id]['itemData']['posterSmall'].split('/')[-1]
		if data['channel'][content_id]['itemData']['type'] == "video":
			data['channel'][content_id]['itemData']['localUrl'] = "http://pressplaytv.in/stream/"+data['channel'][content_id]['itemData']['ppId']+"/mp4"
			data['channel'][content_id]['itemData']['downloadUrl'] = "http://pressplaytv.in/download/"+data['channel'][content_id]['itemData']['ppId']+"/mp4"
		else:
			data['channel'][content_id]['itemData']['localUrl'] = "http://pressplaytv.in/stream/"+data['channel'][content_id]['itemData']['ppId']+"/mp3"
			data['channel'][content_id]['itemData']['downloadUrl'] = "http://pressplaytv.in/download/"+data['channel'][content_id]['itemData']['ppId']+"/mp3"		

	for content_id in data["collection"]:
		print data['collection'][content_id]['itemData']['ppId']		
		
		data['collection'][content_id]['itemData']['poster'] = "http://pressplaytv.in/static/posters/"+data['collection'][content_id]['itemData']['poster'].split('/')[-1]
		data['collection'][content_id]['itemData']['posterSmall'] = "http://pressplaytv.in/static/posters/"+data['collection'][content_id]['itemData']['posterSmall'].split('/')[-1]
		
with open(json_file, 'w') as data_file:
    data_file.write(json.dumps(data))
    
    
		
			


