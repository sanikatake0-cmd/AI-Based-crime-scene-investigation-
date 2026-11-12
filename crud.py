from database import get_db_connection

# 1. User Login Verification
def verify_user(officer_id, password_hash):
    conn = get_db_connection()
    if not conn:
        return None
    try:
        with conn.cursor() as cursor:
            query = "SELECT * FROM users WHERE officer_id = %s AND password_hash = %s;"
            cursor.execute(query, (officer_id, password_hash))
            user = cursor.fetchone()
            return user
    finally:
        conn.close()

# 2. Add New Crime Case
def create_case(case_id, title, description, location, status="Active"):
    conn = get_db_connection()
    if not conn:
        return False
    try:
        with conn.cursor() as cursor:
            query = """
                INSERT INTO cases (case_id, title, description, location, status)
                VALUES (%s, %s, %s, %s, %s) RETURNING id;
            """
            cursor.execute(query, (case_id, title, description, location, status))
            conn.commit()
            return True
    except Exception as e:
        print(f"Error creating case: {e}")
        return False
    finally:
        conn.close()

# 3. Add Evidence File Details
def add_evidence(case_id, file_name, file_url, file_hash, ai_score=0.0):
    conn = get_db_connection()
    if not conn:
        return False
    try:
        with conn.cursor() as cursor:
            query = """
                INSERT INTO evidence_files (case_id, file_name, file_url, file_hash, ai_score)
                VALUES (%s, %s, %s, %s, %s);
            """
            cursor.execute(query, (case_id, file_name, file_url, file_hash, ai_score))
            conn.commit()
            return True
    except Exception as e:
        print(f"Error adding evidence: {e}")
        return False
    finally:
        conn.close()

# 4. Fetch All Cases
def get_all_cases():
    conn = get_db_connection()
    if not conn:
        return []
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM cases ORDER BY created_at DESC;")
            return cursor.fetchall()
    finally:
        conn.close()

# Simple Test Run
if __name__ == "__main__":
    print("Testing CRUD operations...")
    cases = get_all_cases()
    print(f"Total Cases found: {len(cases)}")