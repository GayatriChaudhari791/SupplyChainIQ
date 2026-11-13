
import pandas as pd
from pathlib import Path

file_path = Path("data/processed/supplychain_cleaned.csv")
df = pd.read_csv(file_path, nrows=100)

print("TOTAL COLUMNS:", len(df.columns))
print("\nCOLUMN NAME AND DATA TYPE")
print("-" * 65)

for column in df.columns:
    print(f"{column:40} {df[column].dtype}")

print("\nDUPLICATE ORDER ITEM IDS:")
print(df["Order Item Id"].duplicated().sum())

print("\nMISSING VALUES:")
print(df.isnull().sum()[df.isnull().sum() > 0])
