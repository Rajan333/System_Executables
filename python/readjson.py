
import requests
import json
import os
import sys

filepath = sys.argv[1]

with open(filepath, 'r') as infile:
    data = infile.read()
    readjson = json.loads(data)
   # print readjson

    title = readjson['rss']['channel']['item']
    print title
    sys.exit(0)

for item in readjson['rss']['channel']['item']['title'].iteritems():
    print item.value
        