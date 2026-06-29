USE college_db;
/*
------------------------------------------------------------
35. Students enrolled in more courses than the average
number of enrollments per student.
------------------------------------------------------------
*/

SELECT
    s.student_id,
    CONCAT(s.first_name,' ',s.last_name) AS student_name,
    COUNT(e.course_id) AS total_courses
FROM students s
INNER JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY
    s.student_id,
    s.first_name,
    s.last_name
HAVING COUNT(e.course_id) >
(
    SELECT AVG(course_count)
    FROM
    (
        SELECT
            COUNT(*) AS course_count
        FROM enrollments
        GROUP BY student_id
    ) avg_table
);

------------------------------------------------------------
-- Verification
------------------------------------------------------------

SELECT
    student_id,
    COUNT(course_id) AS total_courses
FROM enrollments
GROUP BY student_id
ORDER BY total_courses DESC;





/*
------------------------------------------------------------
36. Courses where every enrolled student
has received grade 'A'
------------------------------------------------------------
*/

SELECT
    c.course_id,
    c.course_name,
    c.course_code
FROM courses c
WHERE NOT EXISTS
(
    SELECT 1
    FROM enrollments e
    WHERE
        e.course_id = c.course_id
        AND e.grade IS NOT NULL
        AND e.grade <> 'A'
);

------------------------------------------------------------
-- Verification
------------------------------------------------------------

SELECT
    c.course_name,
    e.grade
FROM courses c
INNER JOIN enrollments e
ON c.course_id=e.course_id
ORDER BY
    c.course_name,
    e.grade;





/*
------------------------------------------------------------
37. Highest paid professor
from every department
------------------------------------------------------------
*/

SELECT
    p.professor_id,
    p.prof_name,
    d.dept_name,
    p.salary
FROM professors p
INNER JOIN departments d
ON p.department_id=d.department_id
WHERE salary=
(
    SELECT MAX(salary)
    FROM professors
    WHERE department_id=p.department_id
);

------------------------------------------------------------
-- Verification
------------------------------------------------------------

SELECT
    department_id,
    MAX(salary) AS highest_salary
FROM professors
GROUP BY department_id;






/*
------------------------------------------------------------
38. Departments whose average salary
is greater than 85000
(Using Derived Table)
------------------------------------------------------------
*/

SELECT
    dept_name,
    average_salary
FROM
(
    SELECT
        d.department_id,
        d.dept_name,
        ROUND(AVG(p.salary),2) AS average_salary
    FROM departments d
    INNER JOIN professors p
    ON d.department_id=p.department_id
    GROUP BY
        d.department_id,
        d.dept_name
) salary_table
WHERE average_salary > 85000;

------------------------------------------------------------
-- Verification
------------------------------------------------------------

SELECT
    d.dept_name,
    ROUND(AVG(p.salary),2) AS average_salary
FROM departments d
INNER JOIN professors p
ON d.department_id=p.department_id
GROUP BY
    d.department_id,
    d.dept_name
ORDER BY average_salary DESC;





-- =========================================================
-- ADDITIONAL PRACTICE QUERIES
-- =========================================================

------------------------------------------------------------
-- Student enrolled in maximum courses
------------------------------------------------------------

SELECT
    CONCAT(s.first_name,' ',s.last_name) AS student_name,
    COUNT(e.course_id) AS total_courses
FROM students s
INNER JOIN enrollments e
ON s.student_id=e.student_id
GROUP BY
    s.student_id,
    s.first_name,
    s.last_name
ORDER BY total_courses DESC;

------------------------------------------------------------
-- Department wise professor count
------------------------------------------------------------

SELECT
    d.dept_name,
    COUNT(p.professor_id) AS total_professors
FROM departments d
LEFT JOIN professors p
ON d.department_id=p.department_id
GROUP BY
    d.department_id,
    d.dept_name;

------------------------------------------------------------
-- Department budgets
------------------------------------------------------------

SELECT
    dept_name,
    budget
FROM departments
ORDER BY budget DESC;

------------------------------------------------------------
-- Students and their departments
------------------------------------------------------------

SELECT
    CONCAT(s.first_name,' ',s.last_name) AS student_name,
    d.dept_name
FROM students s
INNER JOIN departments d
ON s.department_id=d.department_id
ORDER BY student_name;

------------------------------------------------------------
-- Course details
------------------------------------------------------------

SELECT
    course_name,
    course_code,
    credits
FROM courses
ORDER BY course_name;


------------------------------------------------------------
-- 39. Create View : Student Enrollment Summary
------------------------------------------------------------

DROP VIEW IF EXISTS vw_student_enrollment_summary;

CREATE VIEW vw_student_enrollment_summary AS
SELECT
    s.student_id,
    CONCAT(s.first_name,' ',s.last_name) AS student_name,
    d.dept_name,
    COUNT(e.course_id) AS total_courses,

    ROUND(
        AVG(
            CASE
                WHEN e.grade='A' THEN 4
                WHEN e.grade='B' THEN 3
                WHEN e.grade='C' THEN 2
                WHEN e.grade='D' THEN 1
                WHEN e.grade='F' THEN 0
                ELSE NULL
            END
        ),2
    ) AS GPA

FROM students s

LEFT JOIN departments d
ON s.department_id=d.department_id

LEFT JOIN enrollments e
ON s.student_id=e.student_id

GROUP BY
    s.student_id,
    s.first_name,
    s.last_name,
    d.dept_name;


------------------------------------------------------------
-- Verify View
------------------------------------------------------------

SELECT *
FROM vw_student_enrollment_summary;



/*=========================================================
40. Create View : Course Statistics
=========================================================*/

DROP VIEW IF EXISTS vw_course_stats;

CREATE VIEW vw_course_stats AS

SELECT

    c.course_id,
    c.course_name,
    c.course_code,

    COUNT(e.enrollment_id) AS total_enrollments,

    ROUND(
        AVG(
            CASE
                WHEN e.grade='A' THEN 4
                WHEN e.grade='B' THEN 3
                WHEN e.grade='C' THEN 2
                WHEN e.grade='D' THEN 1
                WHEN e.grade='F' THEN 0
                ELSE NULL
            END
        ),2
    ) AS avg_gpa

FROM courses c

LEFT JOIN enrollments e
ON c.course_id=e.course_id

GROUP BY
    c.course_id,
    c.course_name,
    c.course_code;


------------------------------------------------------------
-- Verify View
------------------------------------------------------------

SELECT *
FROM vw_course_stats;



/*=========================================================
41. Students having GPA greater than 3
=========================================================*/

SELECT
    student_name,
    dept_name,
    total_courses,
    GPA
FROM vw_student_enrollment_summary
WHERE GPA > 3.0
ORDER BY GPA DESC;



/*=========================================================
42. Update through View
=========================================================*/

-- Attempting update on a multi-table view.

UPDATE vw_student_enrollment_summary
SET student_name='Test Student'
WHERE student_id=1;

-- Expected:
-- MySQL generally prevents updates on views
-- containing JOIN, GROUP BY and Aggregate
-- functions because they are not updatable.

-- Error may look similar to:
-- ERROR 1288 (HY000):
-- The target table of the UPDATE
-- is not updatable.



/*=========================================================
Explanation
=========================================================*/

-- This view is created using:
-- 1. Multiple tables
-- 2. LEFT JOIN
-- 3. Aggregate Functions
-- 4. GROUP BY
--
-- Therefore MySQL marks this
-- view as NON-UPDATABLE.



/*=========================================================
43. Drop Views
=========================================================*/

DROP VIEW IF EXISTS vw_student_enrollment_summary;
DROP VIEW IF EXISTS vw_course_stats;



/*=========================================================
Create Single Table View
using WITH CHECK OPTION
=========================================================*/

CREATE VIEW vw_student_enrollment_summary AS

SELECT

    student_id,
    first_name,
    last_name,
    email,
    department_id,
    enrollment_year

FROM students

WHERE enrollment_year >= 2022

WITH CHECK OPTION;



------------------------------------------------------------
-- Verify New View
------------------------------------------------------------

SELECT *
FROM vw_student_enrollment_summary;



------------------------------------------------------------
-- Allowed Update
------------------------------------------------------------

UPDATE vw_student_enrollment_summary
SET enrollment_year=2023
WHERE student_id=1;



------------------------------------------------------------
-- This Update will FAIL
------------------------------------------------------------

UPDATE vw_student_enrollment_summary
SET enrollment_year=2021
WHERE student_id=2;

-- Reason:
-- WITH CHECK OPTION prevents any update
-- that causes a row to no longer satisfy
-- the WHERE condition.



------------------------------------------------------------
-- Verify Final Data
------------------------------------------------------------

SELECT *
FROM students
ORDER BY student_id;



-- ========================================================
-- TASK 44 : STORED PROCEDURE - ENROLL STUDENT
-- ========================================================

DROP PROCEDURE IF EXISTS sp_enroll_student;

DELIMITER $$

CREATE PROCEDURE sp_enroll_student
(
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_enrollment_date DATE
)
BEGIN

    DECLARE record_count INT;

    SELECT COUNT(*)
    INTO record_count
    FROM enrollments
    WHERE student_id = p_student_id
      AND course_id = p_course_id;

    IF record_count > 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Student is already enrolled in this course';

    ELSE

        INSERT INTO enrollments
        (
            student_id,
            course_id,
            enrollment_date,
            grade
        )
        VALUES
        (
            p_student_id,
            p_course_id,
            p_enrollment_date,
            NULL
        );

    END IF;

END $$

DELIMITER ;

------------------------------------------------------------
-- Test Procedure
------------------------------------------------------------

CALL sp_enroll_student(3,2,'2024-01-15');

-- Duplicate Test
-- CALL sp_enroll_student(3,2,'2024-01-15');



-- ========================================================
-- TASK 45 : TRANSACTION - TRANSFER STUDENT
-- ========================================================

DROP TABLE IF EXISTS department_transfer_log;

CREATE TABLE department_transfer_log
(
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    old_department INT,
    new_department INT,
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP PROCEDURE IF EXISTS sp_transfer_student;

DELIMITER $$

CREATE PROCEDURE sp_transfer_student
(
    IN p_student_id INT,
    IN p_new_department INT
)
BEGIN

    DECLARE old_department_id INT;

    START TRANSACTION;

    SELECT department_id
    INTO old_department_id
    FROM students
    WHERE student_id = p_student_id;

    UPDATE students
    SET department_id = p_new_department
    WHERE student_id = p_student_id;

    INSERT INTO department_transfer_log
    (
        student_id,
        old_department,
        new_department
    )
    VALUES
    (
        p_student_id,
        old_department_id,
        p_new_department
    );

    COMMIT;

END $$

DELIMITER ;

------------------------------------------------------------
-- Test Transfer
------------------------------------------------------------

CALL sp_transfer_student(4,2);

SELECT *
FROM department_transfer_log;



-- ========================================================
-- TASK 46 : ROLLBACK DEMONSTRATION
-- ========================================================

START TRANSACTION;

UPDATE students
SET department_id = 1
WHERE student_id = 6;

-- Invalid Department
UPDATE students
SET department_id = 999
WHERE student_id = 6;

ROLLBACK;

------------------------------------------------------------
-- Verify Rollback
------------------------------------------------------------

SELECT
student_id,
department_id
FROM students
WHERE student_id = 6;



-- ========================================================
-- TASK 47 : SAVEPOINT DEMONSTRATION
-- ========================================================

START TRANSACTION;

INSERT INTO enrollments
(
    student_id,
    course_id,
    enrollment_date,
    grade
)
VALUES
(
    7,
    2,
    CURDATE(),
    'A'
);

SAVEPOINT first_insert;

-- Duplicate Enrollment
INSERT INTO enrollments
(
    student_id,
    course_id,
    enrollment_date,
    grade
)
VALUES
(
    7,
    2,
    CURDATE(),
    'A'
);

ROLLBACK TO first_insert;

COMMIT;

------------------------------------------------------------
-- Verify Savepoint
------------------------------------------------------------

SELECT *
FROM enrollments
WHERE student_id = 7;



-- ========================================================
-- ADDITIONAL VERIFICATION
-- ========================================================

SELECT *
FROM students
ORDER BY student_id;

SELECT *
FROM department_transfer_log
ORDER BY log_id;

SELECT *
FROM enrollments
ORDER BY enrollment_id;



