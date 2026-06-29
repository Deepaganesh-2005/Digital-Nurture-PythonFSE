USE college_db;

-- ========================================================
-- TASK 1 : BASELINE PERFORMANCE (WITHOUT INDEXES)
-- ========================================================

/*
------------------------------------------------------------
48. Display the execution plan for the JOIN query
using EXPLAIN FORMAT=JSON.
------------------------------------------------------------
*/

EXPLAIN FORMAT=JSON

SELECT
    s.first_name,
    s.last_name,
    c.course_name

FROM enrollments e

INNER JOIN students s
ON e.student_id = s.student_id

INNER JOIN courses c
ON e.course_id = c.course_id

WHERE s.enrollment_year = 2022;





/*
------------------------------------------------------------
49. Normal EXPLAIN Output
------------------------------------------------------------
*/

EXPLAIN

SELECT
    s.first_name,
    s.last_name,
    c.course_name

FROM enrollments e

INNER JOIN students s
ON e.student_id = s.student_id

INNER JOIN courses c
ON e.course_id = c.course_id

WHERE s.enrollment_year = 2022;





/*
------------------------------------------------------------
50. Query Execution
------------------------------------------------------------
*/

SELECT
    s.first_name,
    s.last_name,
    c.course_name

FROM enrollments e

INNER JOIN students s
ON e.student_id = s.student_id

INNER JOIN courses c
ON e.course_id = c.course_id

WHERE s.enrollment_year = 2022;





-- ========================================================
-- OBSERVATION
-- ========================================================

/*

The execution plan before creating indexes
may display:

type : ALL

This indicates a Full Table Scan.

Possible observations:

1.
students table
→ Full Table Scan

2.
enrollments table
→ Full Table Scan

3.
courses table
→ Primary Key lookup

Rows examined depend on
the amount of sample data.

Since our database is small,
MySQL may still prefer
table scans instead of indexes.

As the number of records grows,
indexes become much more beneficial.

*/




-- ========================================================
-- EXTRA PERFORMANCE CHECKS
-- ========================================================

------------------------------------------------------------
-- Student Table
------------------------------------------------------------

EXPLAIN
SELECT *
FROM students
WHERE enrollment_year = 2022;





------------------------------------------------------------
-- Course Lookup
------------------------------------------------------------

EXPLAIN
SELECT *
FROM courses
WHERE course_code='CS101';





------------------------------------------------------------
-- Enrollment Lookup
------------------------------------------------------------

EXPLAIN
SELECT *
FROM enrollments
WHERE student_id=1;





------------------------------------------------------------
-- Professor Lookup
------------------------------------------------------------

EXPLAIN
SELECT *
FROM professors
WHERE department_id=1;





------------------------------------------------------------
-- Verification Queries
------------------------------------------------------------

SELECT COUNT(*) AS Total_Students
FROM students;

SELECT COUNT(*) AS Total_Courses
FROM courses;

SELECT COUNT(*) AS Total_Enrollments
FROM enrollments;

SELECT COUNT(*) AS Total_Professors
FROM professors;

SELECT COUNT(*) AS Total_Departments
FROM departments;


/*=========================================================
           TASK 2 : ADD INDEXES & COMPARE PLANS
=========================================================*/


------------------------------------------------------------
-- 51. Create B-Tree Index on enrollment_year
------------------------------------------------------------

CREATE INDEX idx_students_enrollment_year
ON students(enrollment_year);

SHOW INDEX FROM students;



------------------------------------------------------------
-- Verify Index Usage
------------------------------------------------------------

EXPLAIN

SELECT *
FROM students
WHERE enrollment_year = 2022;



/*=========================================================
52. Composite UNIQUE Index
=========================================================*/

CREATE UNIQUE INDEX idx_enrollment_student_course
ON enrollments(student_id,course_id);

SHOW INDEX FROM enrollments;



------------------------------------------------------------
-- Verify Duplicate Prevention
------------------------------------------------------------

-- This insert should fail if the same
-- student is already enrolled in the course.

-- INSERT INTO enrollments
-- VALUES
-- (20,1,1,CURDATE(),'A');



/*=========================================================
53. Create Index on Course Code
=========================================================*/

CREATE INDEX idx_course_code
ON courses(course_code);

SHOW INDEX FROM courses;



------------------------------------------------------------
-- Verify Course Code Index
------------------------------------------------------------

EXPLAIN

SELECT *
FROM courses
WHERE course_code='CS101';



/*=========================================================
54. Compare Query Plans
=========================================================*/

EXPLAIN FORMAT=JSON

SELECT

    s.first_name,
    s.last_name,
    c.course_name

FROM enrollments e

INNER JOIN students s
ON s.student_id=e.student_id

INNER JOIN courses c
ON c.course_id=e.course_id

WHERE s.enrollment_year=2022;



EXPLAIN

SELECT

    s.first_name,
    s.last_name,
    c.course_name

FROM enrollments e

INNER JOIN students s
ON s.student_id=e.student_id

INNER JOIN courses c
ON c.course_id=e.course_id

WHERE s.enrollment_year=2022;



/*
===========================================================
OBSERVATION

Before Index

type = ALL

Rows Examined = More

After Index

type = ref / range

Rows Examined = Less

Performance becomes better
for larger datasets.

===========================================================
*/



/*=========================================================
55. Partial Index
=========================================================*/

-- PostgreSQL supports

/*
CREATE INDEX idx_null_grade
ON enrollments(student_id)
WHERE grade IS NULL;
*/

-- MySQL does not support partial indexes
-- directly.

-- Alternative:

CREATE INDEX idx_grade_student
ON enrollments(grade,student_id);



------------------------------------------------------------
-- Verify
------------------------------------------------------------

EXPLAIN

SELECT *
FROM enrollments
WHERE grade IS NULL;



------------------------------------------------------------
-- Verify Composite Index
------------------------------------------------------------

EXPLAIN

SELECT *
FROM enrollments
WHERE student_id=1
AND course_id=1;



------------------------------------------------------------
-- Verify Enrollment Year Index
------------------------------------------------------------

EXPLAIN

SELECT
first_name,
last_name
FROM students
WHERE enrollment_year=2022;



------------------------------------------------------------
-- Verify Course Code Index
------------------------------------------------------------

EXPLAIN

SELECT
course_name
FROM courses
WHERE course_code='CS102';



------------------------------------------------------------
-- Display All Indexes
------------------------------------------------------------

SHOW INDEX
FROM students;

SHOW INDEX
FROM courses;

SHOW INDEX
FROM enrollments;



/*
===========================================================
Index Summary

idx_students_enrollment_year

idx_course_code

idx_enrollment_student_course

idx_grade_student

===========================================================
*/

