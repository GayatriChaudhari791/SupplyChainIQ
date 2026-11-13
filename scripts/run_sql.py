
import psycopg2
from getpass import getpass
from pathlib import Path

password = getpass("PostgreSQL password: ")

connection = psycopg2.connect(
    host="localhost",
    port="5432",
    database="supplychainiq",
    user="postgres",
    password=password
)

cursor = connection.cursor()

# Read SQL file
sql_file = Path("sql/01_business_analysis.sql")
query = sql_file.read_text(encoding="utf-8")

# Execute SQL
cursor.execute(query)

# Display results
columns = [desc[0] for desc in cursor.description]
rows = cursor.fetchall()

print("\n========== SQL QUERY RESULTS ==========")
print(" | ".join(columns))
print("-" * 90)

for row in rows:
    print(" | ".join(str(value) for value in row))

cursor.close()
connection.close()
