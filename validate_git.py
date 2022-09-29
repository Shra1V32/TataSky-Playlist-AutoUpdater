# Copyright (C) 2022 Shra1V32 <namanageshwar@outlook.com>
#        GitHub: https://github.com/Shra1V32

import sys
import requests
import datetime


class PeriodNotCompleted(Exception):
    pass


if sys.argv[1] != '':
    git_id = sys.argv[1]
    data = requests.get(f"https://api.github.com/users/{git_id}")
    current_date = requests.get(
        "https://www.timeanddate.com/scripts/ts.php")
    current_date = current_date.content[:10]
    api_data = data.json()
    creation_date = api_data["created_at"]
    u_year, u_month, u_day = creation_date[:10].split('-')
    u_hours, u_minutes, u_seconds = creation_date[11:19].split(':')
    ts = (datetime.datetime.fromtimestamp(int(current_date)) -
          datetime.datetime(int(u_year), int(u_month), int(u_day), int(u_hours), int(u_minutes), int(u_seconds))).total_seconds()
    if int(ts) < 604800:
        remaining_hrs = 24 - (int((int(ts) % 86400)/3600))
        remaining_days = 7 - int(ts/86400)
        remaining_mins = 60 - (int((int(ts) % 86400)/60)) % 60
        print(
            f"\033[0;31mYour GitHub account is too new to run this script, Please come back after {remaining_days} days, {remaining_hrs} hrs and {remaining_mins} minutes.\033[0m")
        raise PeriodNotCompleted
else:
    print("No arguments passed")
