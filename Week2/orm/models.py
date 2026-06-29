from sqlalchemy import (
    Column,
    Integer,
    String,
    Date,
    Numeric,
    ForeignKey
)

from sqlalchemy.orm import relationship

from database import Base
from database import engine


# ==========================================================
# DEPARTMENT MODEL
# ==========================================================

class Department(Base):

    __tablename__ = "departments"

    department_id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )

    dept_name = Column(
        String(100),
        nullable=False,
        unique=True
    )

    head_of_dept = Column(
        String(100),
        nullable=False
    )

    budget = Column(
        Numeric(12, 2),
        nullable=False
    )

    students = relationship(
        "Student",
        back_populates="department",
        cascade="all, delete-orphan"
    )

    courses = relationship(
        "Course",
        back_populates="department",
        cascade="all, delete-orphan"
    )

    professors = relationship(
        "Professor",
        back_populates="department",
        cascade="all, delete-orphan"
    )

    def __repr__(self):

        return (
            f"Department("
            f"id={self.department_id}, "
            f"name='{self.dept_name}')"
        )


# ==========================================================
# STUDENT MODEL
# ==========================================================

class Student(Base):

    __tablename__ = "students"

    student_id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )

    first_name = Column(
        String(50),
        nullable=False
    )

    last_name = Column(
        String(50),
        nullable=False
    )

    email = Column(
        String(100),
        unique=True,
        nullable=False
    )

    date_of_birth = Column(
        Date,
        nullable=False
    )

    enrollment_year = Column(
        Integer,
        nullable=False
    )

    department_id = Column(
        Integer,
        ForeignKey("departments.department_id"),
        nullable=False
    )

    department = relationship(
        "Department",
        back_populates="students"
    )

    enrollments = relationship(
        "Enrollment",
        back_populates="student",
        cascade="all, delete-orphan"
    )

    def __repr__(self):

        return (
            f"Student("
            f"id={self.student_id}, "
            f"name='{self.first_name} {self.last_name}')"
        )


# ==========================================================
# COURSE MODEL
# ==========================================================

class Course(Base):

    __tablename__ = "courses"

    course_id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )

    course_name = Column(
        String(100),
        nullable=False
    )

    course_code = Column(
        String(20),
        unique=True,
        nullable=False
    )

    credits = Column(
        Integer,
        nullable=False
    )

    department_id = Column(
        Integer,
        ForeignKey("departments.department_id"),
        nullable=False
    )

    department = relationship(
        "Department",
        back_populates="courses"
    )

    enrollments = relationship(
        "Enrollment",
        back_populates="course",
        cascade="all, delete-orphan"
    )

    def __repr__(self):

        return (
            f"Course("
            f"id={self.course_id}, "
            f"code='{self.course_code}', "
            f"name='{self.course_name}')"
        )

# ==========================================================
# PROFESSOR MODEL
# ==========================================================

class Professor(Base):

    __tablename__ = "professors"

    professor_id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )

    professor_name = Column(
        String(100),
        nullable=False
    )

    email = Column(
        String(100),
        unique=True,
        nullable=False
    )

    salary = Column(
        Numeric(10, 2),
        nullable=False
    )

    department_id = Column(
        Integer,
        ForeignKey("departments.department_id"),
        nullable=False
    )

    department = relationship(
        "Department",
        back_populates="professors"
    )

    def __repr__(self):

        return (
            f"Professor("
            f"id={self.professor_id}, "
            f"name='{self.professor_name}')"
        )


# ==========================================================
# ENROLLMENT MODEL
# ==========================================================

class Enrollment(Base):

    __tablename__ = "enrollments"

    enrollment_id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )

    student_id = Column(
        Integer,
        ForeignKey("students.student_id"),
        nullable=False
    )

    course_id = Column(
        Integer,
        ForeignKey("courses.course_id"),
        nullable=False
    )

    enrollment_date = Column(
        Date,
        nullable=False
    )

    grade = Column(
        String(2)
    )

    student = relationship(
        "Student",
        back_populates="enrollments"
    )

    course = relationship(
        "Course",
        back_populates="enrollments"
    )

    def __repr__(self):

        return (
            f"Enrollment("
            f"id={self.enrollment_id}, "
            f"student={self.student_id}, "
            f"course={self.course_id}, "
            f"grade='{self.grade}')"
        )


# ==========================================================
# CREATE TABLES
# ==========================================================

def create_tables():

    print("=" * 60)
    print("Creating Database Tables...")
    print("=" * 60)

    Base.metadata.create_all(bind=engine)

    print("Tables Created Successfully.")
    print("=" * 60)


# ==========================================================
# DISPLAY REGISTERED MODELS
# ==========================================================

def display_models():

    print("\nRegistered ORM Models\n")

    models = [
        "Department",
        "Student",
        "Course",
        "Professor",
        "Enrollment"
    ]

    for index, model in enumerate(models, start=1):
        print(f"{index}. {model}")


# ==========================================================
# MAIN FUNCTION
# ==========================================================

def main():

    create_tables()

    display_models()

    print("\nDatabase Name : college_db_orm")
    print("ORM Models Ready")
    print("=" * 60)


if __name__ == "__main__":

    main()