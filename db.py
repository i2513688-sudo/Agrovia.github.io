import os
import mysql.connector
from dotenv import load_dotenv

load_dotenv()

def get_connection():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST") or os.getenv("MYSQLHOST", "127.0.0.1"),
        port=int(os.getenv("DB_PORT") or os.getenv("MYSQLPORT", "3306")),
        database=os.getenv("DB_NAME") or os.getenv("MYSQLDATABASE", "agrovia_v01"),
        user=os.getenv("DB_USER") or os.getenv("MYSQLUSER", "root"),
        password=os.getenv("DB_PASSWORD") or os.getenv("MYSQLPASSWORD", "")
    )

def query(sql, params=(), one=False):
    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(sql, params)
        rows = cur.fetchone() if one else cur.fetchall()
        return rows
    finally:
        cur.close()
        conn.close()

def execute(sql, params=()):
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute(sql, params)
        conn.commit()
        return cur.lastrowid
    finally:
        cur.close()
        conn.close()
