import pandas as pd

# Load TSV
df = pd.read_csv("arbtt_data.csv", sep="\t")

# Optional: inspect the data
print(df.head())
