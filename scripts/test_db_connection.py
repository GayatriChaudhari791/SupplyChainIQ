
import psycopg2
from getpass import getpass

password = getpass("Enter PostgreSQL password: ")

try:
    connection = psycopg2.connect(
        host="localhost",
        port="5432",
        database="supplychainiq",
        user="postgres",
        password=password
    )

    print("Successfully connected to SupplyChainIQ!")

    cursor = connection.cursor()
    cursor.execute("SELECT current_database(), current_user;")
    print("Database details:", cursor.fetchone())

    cursor.close()
    connection.close()

except psycopg2.Error as error:
    print("Database connection failed:", error)
