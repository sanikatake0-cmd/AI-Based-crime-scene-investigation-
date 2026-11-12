import psycopg2
from psycopg2.extras import RealDictCursor

# Supabase Transaction Pooler Connection URL (Port 6543)
DATABASE_URL = "postgresql://postgres:crimepass%402026@db.ekphvgzqzqdypnxcycia.supabase.co:5432/postgres"

def get_db_connection():
    try:
        conn = psycopg2.connect(DATABASE_URL, cursor_factory=RealDictCursor)
        print("✅ Database Connection Successful!")
        return conn
    except Exception as e:
        print(f"❌ Database Connection Error: {e}")
        return None

if __name__ == "__main__":
    get_db_connection()