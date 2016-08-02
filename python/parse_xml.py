import sys
import xml.etree.ElementTree as ET
import csv
import codecs
import urllib2

xml_file=urllib2.urlopen(sys.argv[1])
tree = ET.parse(xml_file)
root = tree.getroot()
#GETTING ALL TITLES
title_list=[]
for data in root.iter('title'):
	title_list.append(data.text.encode('utf-8'))
del title_list[0]
del title_list[0]

# GETTING VIDEOS URL
video_url_list=[]
for data in root.iter('{http://search.yahoo.com/mrss/}content'):
	if data.attrib['url'].endswith(".mp4"):
		video_url_list.append(data.attrib['url'].encode('utf-8'))

#GETTING THUMBNAILS URL
thumb_list=[]
for data in root.iter('{http://search.yahoo.com/mrss/}thumbnail'):
	thumb_list.append(data.attrib['url'].encode('utf-8'))

#WRITE  IN CSV FILE ALL THREE VALUES
with open('allnameurl.csv', 'wb') as f:
	writer = csv.writer(f, delimiter=',')
	for val in zip(title_list,video_url_list,thumb_list):
		writer.writerow(val)