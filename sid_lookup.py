#!/usr/bin/env python3
import os
import requests
import sys

sidList = []

LookUpURL = "https://tm.tapi.videoready.tv/rest-api/pub/api/v2/subscriberLookup"

lookUpData = requests.post(LookUpURL,
                           json={"rmn": str(sys.argv[1])}, timeout=10)
k = lookUpData.json()

data = k['data']['sidList']

if len(data) == 1:
    for i in data:
        sidList = i['sid']
    sidString = "".join(sidList)
    with open(".tplaycreds", "w") as outfile:
        outfile.write(f"sub_id={sidString}\nmulti_sid={len(data)}\n")
else:
    for i in data:
        sidList.append(i['sid'])
        sidList.append(" ")
    sidString = "".join(sidList)
    with open(".tplaycreds", "w") as outfile:
        outfile.write(f"sub_id=\"{sidString}\"\nmulti_sid={len(data)}\n")
