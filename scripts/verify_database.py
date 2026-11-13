
import psycopg2
from getpass import getpass

password = getpass("PostgreSQL password: ")

connection = psycopg2.connect(
    host="localhost",
    port="5432",
    database="supplychainiq",
    user="postgres",
    password=password
)

cursor = connection.cursor()

queries = [
    ("Total records", "SELECT COUNT(*) FROM supply_chain"),
    ("Unique orders", 'SELECT COUNT(DISTINCT "Order Id") FROM supply_chain'),
    ("Unique customers", 'SELECT COUNT(DISTINCT "Customer Id") FROM supply_chain'),
    ("Total sales", 'SELECT ROUND(SUM("Sales")::numeric, 2) FROM supply_chain')
]

for label, query in queries:
    cursor.execute(query)
    print(f"{label}: {cursor.fetchone()[0]}")

cursor.close()
connection.close()
