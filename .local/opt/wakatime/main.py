import requests
from datetime import datetime, timedelta
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# --- CONFIG ---
API_KEY = "waka_9a8c2fbd-28a1-4a9d-976e-f040884f9422"

# --- GET DATES ---
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

# --- PROCESS DATA ---
# Prepare date labels
dates = [entry["range"]["date"] for entry in data]
day_labels = [datetime.strptime(d, "%Y-%m-%d").strftime("%a") for d in dates]

# Total hours
totals = [entry["grand_total"]["total_seconds"] / 3600 for entry in data]

# Languages
lang_records = []
for entry in data:
    day = datetime.strptime(entry["range"]["date"], "%Y-%m-%d").strftime("%a")
    for lang in entry["languages"]:
        lang_records.append(
            {
                "day": day,
                "language": lang["name"],
                "hours": lang["total_seconds"] / 3600,
            }
        )

lang_df = pd.DataFrame(lang_records)

# Projects
proj_records = []
for entry in data:
    day = datetime.strptime(entry["range"]["date"], "%Y-%m-%d").strftime("%a")
    for proj in entry["projects"]:
        proj_records.append(
            {"day": day, "project": proj["name"], "hours": proj["total_seconds"] / 3600}
        )

proj_df = pd.DataFrame(proj_records)

# --- PLOTTING STYLE ---
sns.set_theme(style="whitegrid")
plt.rcParams.update(
    {"font.size": 12, "axes.titlesize": 16, "axes.labelsize": 14, "legend.fontsize": 10}
)

# --- PLOT 1: Total time ---
plt.figure(figsize=(8, 5))
sns.barplot(x=day_labels, y=totals, color="steelblue")
plt.ylabel("Hours")
plt.xlabel("Day of Week")
plt.title("Total Coding Time per Day")
plt.tight_layout()
plt.savefig("total-per-day", dpi=300)
plt.show()

# --- PLOT 2: Language time ---
if not lang_df.empty:
    lang_pivot = lang_df.pivot_table(
        index="day", columns="language", values="hours", aggfunc="sum", fill_value=0
    )
    lang_pivot = lang_pivot.reindex(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"])
    lang_pivot.plot(kind="bar", stacked=True, figsize=(8, 5), colormap="tab20")
    plt.ylabel("Hours")
    plt.xlabel("Day of Week")
    plt.title("Coding Time by Language")
    plt.legend(title="Language", bbox_to_anchor=(1.05, 1), loc="upper left")
    plt.tight_layout()
    plt.savefig("by-language", dpi=300)
    plt.show()

# --- PLOT 3: Project time ---
if not proj_df.empty:
    proj_pivot = proj_df.pivot_table(
        index="day", columns="project", values="hours", aggfunc="sum", fill_value=0
    )
    proj_pivot = proj_pivot.reindex(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"])
    proj_pivot.plot(kind="bar", stacked=True, figsize=(8, 5), colormap="Set2")
    plt.ylabel("Hours")
    plt.xlabel("Day of Week")
    plt.title("Coding Time by Project")
    plt.legend(title="Project", bbox_to_anchor=(1.05, 1), loc="upper left")
    plt.tight_layout()
    plt.savefig("by-project", dpi=300)
    plt.show()
