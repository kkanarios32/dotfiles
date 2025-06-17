import sys
import requests
from datetime import datetime, timedelta
from etils import epath
import json
import os
import argparse

# --- CONFIG ---
API_KEY = os.getenv("WAKA_API")


def main(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument("-d", "--date", help="end date for desired range")

    if len(argv) > 0:
        # --- GET DATES ---
        end_date = datetime.strptime(argv[0], "%Y-%m-%d")
    else:
        end_date = datetime.today().date()

    start_date = end_date - timedelta(days=6)

    start_str = start_date.strftime("%Y-%m-%d")
    end_str = end_date.strftime("%Y-%m-%d")

    # --- API REQUEST ---
    url = "https://wakatime.com/api/v1/users/current/summaries"
    params = {"start": start_str, "end": end_str}

    response = requests.get(url, params=params, auth=(API_KEY, ""))

    if response.status_code != 200:
        print(f"Error: {response.status_code}")
        print(response.text)
        exit(1)

    data = response.json()["data"]

    save_dir = f"data/{end_str}"
    os.makedirs(save_dir, exist_ok=True)
    path = f"{save_dir}/data.json"

    with epath.Path(path).open("w") as fout:
        json.dump(data, fout)


if __name__ == "__main__":
    main(sys.argv[1:])
