#!/usr/bin/env python
import sys
import requests
import json
import argparse
import time

pub_id = "4722550562001"
client_id = "f3602d27-51aa-4746-a26e-93079101f192"
client_secret = "1Zw5CIgBtonxXGwM9y4jLP8AJXd8KKC1VnIar6RieLV3DdfpIzn9JSZvwKiv8_ewChuhcE9grtinNv1Sd3WoPw"
access_token_url = "https://oauth.brightcove.com/v3/access_token"
profiles_base_url = "http://ingestion.api.brightcove.com/v1/accounts/{pubid}/profiles"
access_token = None


def get_access_token():
    access_token = None
    r = requests.post(access_token_url, params="grant_type=client_credentials", auth=(
        client_id, client_secret), verify=False)
    if r.status_code == 200:
        access_token = r.json().get('access_token')
        # print(access_token)
    return access_token


def create_video(cid):
    #access_token = get_access_token()
    headers = {'Authorization': 'Bearer ' + access_token,
               "Content-Type": "application/json"}

    url = (
        "https://cms.api.brightcove.com/v1/accounts/{pubid}/videos/").format(pubid=pub_id)
    data = {"name": "pp-content-"+str(cid)}
    r = requests.post(url, headers=headers, json=data)
    return r.json()


def submit_pbi(video_id,cid):
    #access_token = get_access_token()
    # print access_token
    headers = {'Authorization': 'Bearer ' + access_token,
               "Content-Type": "application/json"}

    url = ("https://ingest.api.brightcove.com/v1/accounts/{pubid}/videos/{videoid}/ingest-requests").format(
        pubid=pub_id, videoid=video_id)
    # print url

    print "s3://pp-brightcove-source/pp-content-"+str(cid)+".mp4"
    data = {"master": {"url": "s3://pp-brightcove-source/pp-content-"+str(cid)+".mp4"}, "profile":
            "Asia-STANDARD", "callbacks": ['http://test-ammo.pressplaytv.in/hooks/brightcove']}
    r = requests.post(url, headers=headers, json=data)
    # print r.headers
    # print headers
    # print data
    return r.json()


access_token = get_access_token()
#print access_token

#v = create_video(198)


#print v['id']
#sys.exit()
file = open('content_remote_id.csv')
for line in file:
    field = line.split(",")
    print field[0], field[1]
#print submit_pbi(4784305666001,212)

    print submit_pbi(int(field[0]),int(field[1]))
    time.sleep(0.05)