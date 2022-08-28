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
    if int(ts) < 604800:
        remaining_hrs = 24 - (int((int(ts) % 86400)/3600))
        remaining_days = 7 - int(ts/86400)
        remaining_mins = 60 - (int((int(ts) % 86400)/60)) % 60
        #print(f"Account created: {u_day}-{u_month}-{u_year}")
        print(
            f"\033[0;31mYour GitHub account is too new to run this script, Please come back after {remaining_days} days, {remaining_hrs} hrs and {remaining_mins} minutes.\033[0m")
        raise PeriodNotCompleted
else:
    print("No arguments passed")

