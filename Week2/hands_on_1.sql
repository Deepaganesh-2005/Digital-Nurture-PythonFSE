-- =======================================================
-- TASK 1 : CREATE DATABASE
-- =======================================================

CREATE DATABASE IF NOT EXISTS college_db;

USE college_db;

-- =======================================================
-- TABLE : departments
-- =======================================================

CREATE TABLE departments
(
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    hod_name VARCHAR(100),
    budget DECIMAL(12,2)
);

-- =======================================================
-- TABLE : students
-- =======================================================

CREATE TABLE students
(
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    department_id INT,
    enrollment_year INT,

    CONSTRAINT fk_student_department
    FOREIGN KEY(department_id)
    REFERENCES departments(department_id)
);

-- =======================================================
-- TABLE : courses
-- =======================================================

CREATE TABLE courses
(
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_code VARCHAR(20) UNIQUE,
    credits INT,
    department_id INT,

    CONSTRAINT fk_course_department
    FOREIGN KEY(department_id)
    REFERENCES departments(department_id)
);

-- =======================================================
-- TABLE : enrollments
-- =======================================================

CREATE TABLE enrollments
(
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(2),

    CONSTRAINT fk_enrollment_student
    FOREIGN KEY(student_id)
    REFERENCES students(student_id),

    CONSTRAINT fk_enrollment_course
    FOREIGN KEY(course_id)
    REFERENCES courses(course_id)
);

-- =======================================================
-- TABLE : professors
-- =======================================================

CREATE TABLE professors
(
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    prof_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT,
    salary DECIMAL(10,2),

    CONSTRAINT fk_professor_department
    FOREIGN KEY(department_id)
    REFERENCES departments(department_id)
);

-- =======================================================
-- VERIFY TABLES
-- =======================================================

SHOW TABLES;

DESCRIBE departments;
DESCRIBE students;
DESCRIBE courses;
DESCRIBE enrollments;
DESCRIBE professors;

-- =======================================================
-- TASK 2 : NORMALIZATION ANALYSIS
-- =======================================================

/*

1NF (First Normal Form)

✓ Every column stores only a single value.
✓ There are no repeating groups.
✓ Example:
  Phone numbers should not be stored as
  9876543210,9123456789
  in one column.

----------------------------------------------------------

2NF (Second Normal Form)

✓ Every non-key attribute depends entirely
  on the primary key.

Example:
In enrollments,
grade depends on
(student_id + course_id)
and not on only student_id.

----------------------------------------------------------

3NF (Third Normal Form)

✓ No transitive dependency exists.

Example:
dept_name should NOT be stored in students.

students
    department_id

departments
    department_id
    dept_name

The department name can always be retrieved
using a JOIN.

Therefore the schema satisfies 3NF.

*/

-- =======================================================
-- TASK 3 : ALTER TABLE
-- =======================================================

-- Add phone number

ALTER TABLE students
ADD phone_number VARCHAR(15);

-- Add maximum seats

ALTER TABLE courses
ADD max_seats INT DEFAULT 60;

-- Add CHECK constraint

ALTER TABLE enrollments
ADD CONSTRAINT chk_grade
CHECK
(
grade IN ('A','B','C','D','F')
OR grade IS NULL
);

-- Rename column

ALTER TABLE departments
RENAME COLUMN hod_name TO head_of_dept;

-- Rollback example

ALTER TABLE students
DROP COLUMN phone_number;

-- =======================================================
-- VERIFY CHANGES
-- =======================================================

DESCRIBE departments;

DESCRIBE courses;

DESCRIBE enrollments;

SHOW CREATE TABLE students;

SHOW CREATE TABLE departments;

SHOW CREATE TABLE courses;

SHOW CREATE TABLE enrollments;

SHOW CREATE TABLE professors;