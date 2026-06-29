import mysql.connector
import time

# =========================================================
# Database Connection
# =========================================================

connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="your_password",
    database="college_db"
)

cursor = connection.cursor(dictionary=True)

print("=" * 60)
print("DATABASE CONNECTED SUCCESSFULLY")
print("=" * 60)


# =========================================================
# TASK 56
# Simulate the N+1 Query Problem
# =========================================================

print("\nTASK 56 : N+1 QUERY PROBLEM\n")

query_count = 0

start_time = time.time()

cursor.execute("SELECT * FROM enrollments")
enrollments = cursor.fetchall()
query_count += 1

for enrollment in enrollments:

    cursor.execute(
        """
        SELECT first_name,last_name
        FROM students
        WHERE student_id=%s
        """,
        (enrollment["student_id"],)
    )

    student = cursor.fetchone()
    query_count += 1

    print(
        student["first_name"],
        student["last_name"],
        "-> Course ID:",
        enrollment["course_id"]
    )

end_time = time.time()

n1_time = end_time - start_time

print("\nQueries Executed :", query_count)
print("Execution Time   :", round(n1_time,6), "seconds")


# =========================================================
# TASK 57
# Optimized JOIN Query
# =========================================================

print("\n")
print("=" * 60)
print("TASK 57 : OPTIMIZED JOIN QUERY")
print("=" * 60)

query_count = 0

start_time = time.time()

cursor.execute(
    """
    SELECT

        s.first_name,
        s.last_name,
        c.course_name,
        e.grade

    FROM enrollments e

    INNER JOIN students s
    ON e.student_id=s.student_id

    INNER JOIN courses c
    ON e.course_id=c.course_id
    """
)

rows = cursor.fetchall()
query_count += 1

for row in rows:

    print(
        row["first_name"],
        row["last_name"],
        "-",
        row["course_name"],
        "- Grade:",
        row["grade"]
    )

end_time = time.time()

join_time = end_time - start_time

print("\nQueries Executed :", query_count)
print("Execution Time   :", round(join_time,6), "seconds")


# =========================================================
# TASK 58
# Compare Performance
# =========================================================

print("\n")
print("=" * 60)
print("TASK 58 : PERFORMANCE COMPARISON")
print("=" * 60)

print()

print("N+1 Query Time      :", round(n1_time,6), "seconds")
print("JOIN Query Time     :", round(join_time,6), "seconds")

if join_time < n1_time:

    print("\nJOIN query is faster.")

elif join_time == n1_time:

    print("\nBoth queries performed similarly.")

else:

    print("\nJOIN query is slower (small dataset).")


# =========================================================
# TASK 59
# Documentation
# =========================================================

print("\n")
print("=" * 60)
print("TASK 59 : OBSERVATION")
print("=" * 60)

print("""

N+1 Query

1 query fetches all enrollments.

Then

N additional queries are executed
to fetch each student's details.

Total Queries

1 + N


Optimized Query

A single JOIN retrieves
students,
courses,
grades

in one database call.

Advantages

✔ Less network overhead

✔ Faster execution

✔ Better scalability

✔ Recommended approach for ORM
using eager loading or JOINs.

If there are 10,000 enrollments,

N+1 Query

10001 Queries

JOIN Query

1 Query

""")


# =========================================================
# Close Connection
# =========================================================

cursor.close()
connection.close()

print("=" * 60)
print("DATABASE CONNECTION CLOSED")
print("=" * 60)