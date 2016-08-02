__author__ = 'gaurav'

'''
This file download content along with metadata from youtube it takes csv files as command line arguments
it can take multiple csv file as space seprated arguments


Loopin.csv
 ____________________________________________________
|Title     |youtube Link** |channel name |id         |
|__________|_______________|_____________|___________|


** Mandatory Feild at given position
'''

import sys
import os
#import youtube_dl
import csv
import json
import subprocess
#import youtube_upload

'''
Download Media along with metadata json
@param url: Takes youtube url, name and channel as input

'''

def download_video(filename,url):
	create_directory("content")
	if "youtu" in url:
		if not os.path.isfile(filename):

			os.system("youtube-dl -f mp4 -i -o \"content/"+filename+"\" --restrict-filenames "+url)
			#metadata={}
			#if os.path.isfile(filename):
			#	with open(filename,'r') as infofile:
			#		metadata=json.load(infofile)
			#		metadata['new_title']=newname
			#		metadata['channel']=channel
					#json.dump(metadata,infofile)
			#		infofile.close()
				#print metadata
			#	with open(filename,'w')as infofile:
			#		json.dump(metadata,infofile)

		else:
			print "File Already Exists..!!"

def read_csv(csv_filename):
	with open(csv_filename) as csvfile:
		filereader = csv.reader(csvfile)
		for row in filereader:
			download_video(row[0],row[1])



def create_directory(directory_name):
	if not os.path.exists(directory_name):
		os.makedirs(directory_name)


def do_for_all(filenames):
	for filename in filenames:
		if(os.path.splitext(filename)[1]==".csv"):
			read_csv(filename)


do_for_all(sys.argv)
#download_video(sys.argv[1])
