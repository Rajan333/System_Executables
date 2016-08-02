import sys
import time
import json

count = 0

with open('/Users/rajan/mrss.json','r') as infile:
    data = infile.read()
    jsondata = json.loads(data)
    jsonitems = jsondata['channel']['item']
    for iteritems in jsondata['channel']['item']:
        itemtitle =  iteritems['title']
        for iterurl in iteritems['content']:
            itemurl = iterurl['@url']
            count = count + 1
            print (count,itemtitle,itemurl)
           # time.sleep(0.2)

