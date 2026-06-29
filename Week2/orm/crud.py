from datetime import date

from database import get_session
from models import (
    Department,
    Student,
    Course,
    Professor,
    Enrollment
)

from sqlalchemy.orm import joinedload


# ==========================================================
# CREATE DATABASE SESSION
# ==========================================================

session = get_session()


# ==========================================================
# INSERT DEPARTMENTS
# ==========================================================

def insert_departments():

    departments = [

        Department(
            dept_name="Computer Science",
            head_of_dept="Dr. Ramesh Kumar",
            budget=900000
        ),

        Department(
            dept_name="Electronics",
            head_of_dept="Dr. Priya Sharma",
            budget=750000
        ),

        Department(
            dept_name="Mechanical",
            head_of_dept="Dr. Suresh Kumar",
            budget=650000
        )

    ]

    session.add_all(departments)
    session.commit()

    print("Departments inserted successfully.")


# ==========================================================
# INSERT STUDENTS
# ==========================================================

def insert_students():

    students = [

        Student(
            first_name="Arjun",
            last_name="Mehta",
            email="arjun@college.edu",
            date_of_birth=date(2003,5,14),
            enrollment_year=2022,
            department_id=1
        ),

        Student(
            first_name="Priya",
            last_name="Rao",
            email="priya@college.edu",
            date_of_birth=date(2003,8,10),
            enrollment_year=2022,
            department_id=1
        ),

        Student(
            first_name="Rahul",
            last_name="Verma",
            email="rahul@college.edu",
            date_of_birth=date(2002,12,20),
            enrollment_year=2021,
            department_id=2
        ),

        Student(
            first_name="Sneha",
            last_name="Iyer",
            email="sneha@college.edu",
            date_of_birth=date(2004,2,15),
            enrollment_year=2023,
            department_id=3
        )

    ]

    session.add_all(students)
    session.commit()

    print("Students inserted successfully.")


# ==========================================================
# INSERT COURSES
# ==========================================================

def insert_courses():

    courses = [

        Course(
            course_name="Database Management Systems",
            course_code="CS101",
            credits=4,
            department_id=1
        ),

        Course(
            course_name="Operating Systems",
            course_code="CS102",
            credits=4,
            department_id=1
        ),

        Course(
            course_name="Digital Electronics",
            course_code="EC201",
            credits=3,
            department_id=2
        ),

        Course(
            course_name="Thermodynamics",
            course_code="ME301",
            credits=3,
            department_id=3
        )

    ]

    session.add_all(courses)
    session.commit()

    print("Courses inserted successfully.")


# ==========================================================
# INSERT PROFESSORS
# ==========================================================

def insert_professors():

    professors = [

        Professor(
            professor_name="Dr. Anand",
            email="anand@college.edu",
            salary=85000,
            department_id=1
        ),

        Professor(
            professor_name="Dr. Kavitha",
            email="kavitha@college.edu",
            salary=82000,
            department_id=2
        ),

        Professor(
            professor_name="Dr. Manoj",
            email="manoj@college.edu",
            salary=80000,
            department_id=3
        )

    ]

    session.add_all(professors)
    session.commit()

    print("Professors inserted successfully.")


# ==========================================================
# INSERT ENROLLMENTS
# ==========================================================

def insert_enrollments():

    enrollments = [

        Enrollment(
            student_id=1,
            course_id=1,
            enrollment_date=date(2022,7,1),
            grade="A"
        ),

        Enrollment(
            student_id=2,
            course_id=2,
            enrollment_date=date(2022,7,1),
            grade="A"
        ),

        Enrollment(
            student_id=3,
            course_id=3,
            enrollment_date=date(2021,7,1),
            grade="B"
        ),

        Enrollment(
            student_id=4,
            course_id=4,
            enrollment_date=date(2023,7,1),
            grade="A"
        )

    ]

    session.add_all(enrollments)
    session.commit()

    print("Enrollments inserted successfully.")


# ==========================================================
# INSERT ALL SAMPLE DATA
# ==========================================================

def insert_sample_data():

    print("=" * 60)
    print("INSERTING SAMPLE DATA")
    print("=" * 60)

    insert_departments()
    insert_students()
    insert_courses()
    insert_professors()
    insert_enrollments()

    print("\nSample data inserted successfully.")


# ==========================================================
# READ ALL DEPARTMENTS
# ==========================================================

def read_departments():

    print("\n" + "=" * 60)
    print("ALL DEPARTMENTS")
    print("=" * 60)

    departments = session.query(Department).all()

    for department in departments:

        print(
            f"{department.department_id} | "
            f"{department.dept_name} | "
            f"{department.head_of_dept}"
        )


# ==========================================================
# READ ALL STUDENTS
# ==========================================================

def read_students():

    print("\n" + "=" * 60)
    print("ALL STUDENTS")
    print("=" * 60)

    students = session.query(Student).all()

    for student in students:

        print(
            f"{student.student_id} | "
            f"{student.first_name} {student.last_name} | "
            f"{student.email}"
        )


# ==========================================================
# READ ALL COURSES
# ==========================================================

def read_courses():

    print("\n" + "=" * 60)
    print("ALL COURSES")
    print("=" * 60)

    courses = session.query(Course).all()

    for course in courses:

        print(
            f"{course.course_code} | "
            f"{course.course_name} | "
            f"{course.credits} Credits"
        )


# ==========================================================
# READ ENROLLMENTS
# ==========================================================

def read_enrollments():

    print("\n" + "=" * 60)
    print("ENROLLMENT DETAILS")
    print("=" * 60)

    enrollments = session.query(Enrollment).all()

    for enrollment in enrollments:

        print(
            f"{enrollment.student.first_name} "
            f"{enrollment.student.last_name}"
            f" -> "
            f"{enrollment.course.course_name}"
            f" | Grade : {enrollment.grade}"
        )


# ==========================================================
# UPDATE STUDENT
# ==========================================================

def update_student():

    print("\n" + "=" * 60)
    print("UPDATE STUDENT")
    print("=" * 60)

    student = session.query(Student).filter_by(
        email="arjun@college.edu"
    ).first()

    if student:

        print(
            f"Before Update : {student.enrollment_year}"
        )

        student.enrollment_year = 2024

        session.commit()

        print(
            f"After Update : {student.enrollment_year}"
        )

    else:

        print("Student Not Found")


# ==========================================================
# DELETE ENROLLMENT
# ==========================================================

def delete_enrollment():

    print("\n" + "=" * 60)
    print("DELETE ENROLLMENT")
    print("=" * 60)

    enrollment = session.query(Enrollment).filter_by(
        enrollment_id=4
    ).first()

    if enrollment:

        session.delete(enrollment)

        session.commit()

        print("Enrollment Deleted Successfully")

    else:

        print("Enrollment Not Found")


# ==========================================================
# DATABASE SUMMARY
# ==========================================================

def database_summary():

    print("\n" + "=" * 60)
    print("DATABASE SUMMARY")
    print("=" * 60)

    print(
        "Departments :",
        session.query(Department).count()
    )

    print(
        "Students :",
        session.query(Student).count()
    )

    print(
        "Courses :",
        session.query(Course).count()
    )

    print(
        "Professors :",
        session.query(Professor).count()
    )

    print(
        "Enrollments :",
        session.query(Enrollment).count()
    )


# ==========================================================
# EXECUTE CRUD OPERATIONS
# ==========================================================

def execute_crud():

    read_departments()

    read_students()

    read_courses()

    read_enrollments()

    update_student()

    delete_enrollment()

    database_summary()

# ==========================================================
# TASK 87
# N+1 QUERY PROBLEM
# ==========================================================

def demonstrate_n_plus_one():

    print("\n" + "=" * 60)
    print("N+1 QUERY PROBLEM")
    print("=" * 60)

    enrollments = session.query(Enrollment).all()

    for enrollment in enrollments:

        print(
            f"{enrollment.student.first_name} "
            f"{enrollment.student.last_name}"
            f" -> "
            f"{enrollment.course.course_name}"
        )


# ==========================================================
# TASK 88
# FIX N+1 USING joinedload()
# ==========================================================

def demonstrate_joinedload():

    print("\n" + "=" * 60)
    print("USING joinedload()")
    print("=" * 60)

    enrollments = (

        session.query(Enrollment)

        .options(

            joinedload(Enrollment.student),

            joinedload(Enrollment.course)

        )

        .all()

    )

    for enrollment in enrollments:

        print(

            f"{enrollment.student.first_name} "
            f"{enrollment.student.last_name}"

            f" -> "

            f"{enrollment.course.course_name}"

            f" | Grade : {enrollment.grade}"

        )


# ==========================================================
# QUERY COMPARISON
# ==========================================================

def query_comparison():

    print("\n" + "=" * 60)
    print("QUERY COMPARISON")
    print("=" * 60)

    print("""
Without joinedload()

1 Query for Enrollment

+

Additional Queries
for Student and Course
for every record.

Result:
N + 1 Query Problem


With joinedload()

Single SQL Query

using JOIN

Improved Performance.
""")


# ==========================================================
# DISPLAY FINAL REPORT
# ==========================================================

def final_report():

    print("\n" + "=" * 60)
    print("ORM HANDS-ON SUMMARY")
    print("=" * 60)

    print("✓ Departments Inserted")
    print("✓ Students Inserted")
    print("✓ Courses Inserted")
    print("✓ Professors Inserted")
    print("✓ Enrollments Inserted")
    print("✓ Read Operations")
    print("✓ Update Operation")
    print("✓ Delete Operation")
    print("✓ N+1 Demonstrated")
    print("✓ joinedload() Demonstrated")

    print("=" * 60)


# ==========================================================
# CLOSE DATABASE SESSION
# ==========================================================

def close_database():

    session.close()

    print("\nDatabase Session Closed Successfully.")


# ==========================================================
# MAIN FUNCTION
# ==========================================================

def main():

    print("=" * 60)
    print("CTS DIGITAL NURTURE 5.0")
    print("ORM CRUD OPERATIONS")
    print("=" * 60)

    # Uncomment ONLY once while setting up the database
    # insert_sample_data()

    execute_crud()

    demonstrate_n_plus_one()

    demonstrate_joinedload()

    query_comparison()

    final_report()

    close_database()


if __name__ == "__main__":

    main()