
import pandas as pd
import psycopg2
from psycopg2 import sql
from getpass import getpass
from pathlib import Path

# Project paths
file_path = Path("data/processed/supplychain_cleaned.csv")

# Read dataset
df = pd.read_csv(file_path)

# Convert date columns
date_columns = [
    "order date (DateOrders)",
    "shipping date (DateOrders)"
]

for col in date_columns:
    df[col] = pd.to_datetime(df[col], errors="coerce")

# PostgreSQL connection
password = getpass("Enter PostgreSQL password: ")

connection = psycopg2.connect(
    host="localhost",
    port="5432",
    database="supplychainiq",
    user="postgres",
    password=password
)

cursor = connection.cursor()

# Create table with inferred types
column_definitions = []

for column, dtype in df.dtypes.items():
    if column == "Order Item Id":
        pg_type = "BIGINT PRIMARY KEY"
    elif pd.api.types.is_integer_dtype(dtype):
        pg_type = "BIGINT"
    elif pd.api.types.is_float_dtype(dtype):
        pg_type = "DOUBLE PRECISION"
    elif pd.api.types.is_datetime64_any_dtype(dtype):
        pg_type = "TIMESTAMP"
    else:
        pg_type = "TEXT"

    column_definitions.append(
        sql.SQL("{} {}").format(
            sql.Identifier(column),
            sql.SQL(pg_type)
        )
    )

create_table_query = sql.SQL(
    "CREATE TABLE IF NOT EXISTS supply_chain ({})"
).format(sql.SQL(", ").join(column_definitions))

cursor.execute(create_table_query)

# Prepare insert query
columns = list(df.columns)

insert_query = sql.SQL(
    "INSERT INTO supply_chain ({}) VALUES ({})"
).format(
    sql.SQL(", ").join(map(sql.Identifier, columns)),
    sql.SQL(", ").join(sql.Placeholder() * len(columns))
)

# Convert missing values to None
df = df.astype(object).where(pd.notnull(df), None)

# Insert in batches
batch_size = 5000

for start in range(0, len(df), batch_size):
    batch = df.iloc[start:start + batch_size]
    cursor.executemany(insert_query, batch.values.tolist())
    print(f"Inserted {min(start + batch_size, len(df)):,} / {len(df):,} rows")

connection.commit()

# Verify import
cursor.execute("SELECT COUNT(*) FROM supply_chain")
print("\nTotal rows imported:", cursor.fetchone()[0])

cursor.close()
connection.close()

print("SupplyChainIQ data import completed!")
