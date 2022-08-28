# Copyright (C) 2022 Shra1V32 <namanageshwar@outlook.com>
#        GitHub: https://github.com/Shra1V32

import sys
import requests
import json
import datetime


class PeriodNotCompleted(Exception):
    pass


if sys.argv[1] != '':
    data = requests.get(sys.argv[1])
    current_date = requests.get(
        "http://worldtimeapi.org/api/timezone/Asia/Kolkata")
    a_year, a_month, a_day = current_date.json()["datetime"][:10].split('-')
    a_hours, a_minutes, a_seconds = current_date.json()[
        "datetime"][11:19].split(':')
    # print(a_hours,a_minutes,a_seconds)
    api_data = data.json()
    creation_date = api_data["created_at"]
    u_year, u_month, u_day = creation_date[:10].split('-')
    u_hours, u_minutes, u_seconds = creation_date[11:19].split(':')
    ts = (datetime.datetime(int(a_year), int(a_month), int(a_day), int(a_hours), int(a_minutes), int(a_seconds)) -
          datetime.datetime(int(u_year), int(u_month), int(u_day), int(u_hours), int(u_minutes), int(u_seconds))).total_seconds()
    if int(ts) < 1209600:
        raise PeriodNotCompleted("A Period of 14 is not completed")
else:
    print("No arguments passed")

