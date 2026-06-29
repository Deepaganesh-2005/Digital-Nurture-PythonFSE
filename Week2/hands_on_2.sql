USE college_db;

-- =======================================================
-- TASK 1 : INSERT SAMPLE DATA
-- =======================================================

-- Departments

INSERT INTO departments (dept_name, head_of_dept, budget)
VALUES
('Computer Science','Dr. Ramesh Kumar',850000.00),
('Electronics','Dr. Priya Nair',620000.00),
('Mechanical','Dr. Suresh Iyer',540000.00),
('Civil','Dr. Ananya Sharma',430000.00);

----------------------------------------------------------

-- Students

INSERT INTO students
(first_name,last_name,email,date_of_birth,department_id,enrollment_year)
VALUES
('Arjun','Mehta','arjun.mehta@college.edu','2003-04-12',1,2022),
('Priya','Suresh','priya.suresh@college.edu','2003-07-25',1,2022),
('Rohan','Verma','rohan.verma@college.edu','2002-11-08',2,2021),
('Sneha','Patel','sneha.patel@college.edu','2004-01-30',3,2023),
('Vikram','Das','vikram.das@college.edu','2003-09-14',1,2022),
('Kavya','Menon','kavya.menon@college.edu','2002-05-17',2,2021),
('Aditya','Singh','aditya.singh@college.edu','2004-03-22',4,2023),
('Deepika','Rao','deepika.rao@college.edu','2003-08-09',1,2022);

----------------------------------------------------------

-- Courses

INSERT INTO courses
(course_name,course_code,credits,department_id,max_seats)
VALUES
('Data Structures & Algorithms','CS101',4,1,60),
('Database Management Systems','CS102',3,1,60),
('Object Oriented Programming','CS103',4,1,60),
('Circuit Theory','EC101',3,2,60),
('Thermodynamics','ME101',3,3,60);

----------------------------------------------------------

-- Enrollments

INSERT INTO enrollments
(student_id,course_id,enrollment_date,grade)
VALUES
(1,1,'2022-07-01','A'),
(1,2,'2022-07-01','B'),
(2,1,'2022-07-01','B'),
(2,3,'2022-07-01','A'),
(3,4,'2021-07-01','A'),
(4,5,'2023-07-01',NULL),
(5,1,'2022-07-01','C'),
(5,2,'2022-07-01','A'),
(6,4,'2021-07-01','B'),
(7,5,'2023-07-01',NULL),
(8,1,'2022-07-01','A'),
(8,3,'2022-07-01','B');

----------------------------------------------------------

-- Professors

INSERT INTO professors
(prof_name,email,department_id,salary)
VALUES
('Dr. Anand Krishnan','anand.k@college.edu',1,95000),
('Dr. Meena Pillai','meena.p@college.edu',1,88000),
('Dr. Sunil Rajan','sunil.r@college.edu',2,82000),
('Dr. Latha Gopal','latha.g@college.edu',3,79000),
('Dr. Kartik Bose','kartik.b@college.edu',4,76000);

-- =======================================================
-- TASK 2 : INSERT ADDITIONAL STUDENTS
-- =======================================================

INSERT INTO students
(first_name,last_name,email,date_of_birth,department_id,enrollment_year)
VALUES
('Rahul','Sharma','rahul.sharma@college.edu','2004-01-12',1,2023),
('Keerthana','Ravi','keerthana.ravi@college.edu','2003-10-05',2,2022);

-- Verify

SELECT COUNT(*) AS Total_Students
FROM students;

-- =======================================================
-- TASK 3 : UPDATE DATA
-- =======================================================

UPDATE enrollments
SET grade='B'
WHERE student_id=5
AND course_id=1;

SELECT *
FROM enrollments
WHERE student_id=5
AND course_id=1;

-- =======================================================
-- TASK 4 : DELETE DATA
-- =======================================================

SELECT *
FROM enrollments
WHERE grade IS NULL;

DELETE FROM enrollments
WHERE grade IS NULL;

SELECT COUNT(*) AS Total_Enrollments
FROM enrollments;

-- =======================================================
-- TASK 5 : SINGLE TABLE QUERIES
-- =======================================================

----------------------------------------------------------
-- Students enrolled in 2022
----------------------------------------------------------

SELECT *
FROM students
WHERE enrollment_year=2022
ORDER BY last_name ASC;

----------------------------------------------------------
-- Courses with credits greater than 3
----------------------------------------------------------

SELECT *
FROM courses
WHERE credits>3
ORDER BY credits DESC;

----------------------------------------------------------
-- Professors salary between 80000 and 95000
----------------------------------------------------------

SELECT *
FROM professors
WHERE salary BETWEEN 80000 AND 95000;

----------------------------------------------------------
-- Email ends with @college.edu
----------------------------------------------------------

SELECT *
FROM students
WHERE email LIKE '%@college.edu';

----------------------------------------------------------
-- Count students based on enrollment year
----------------------------------------------------------

SELECT
enrollment_year,
COUNT(*) AS Total_Students
FROM students
GROUP BY enrollment_year
ORDER BY enrollment_year;

----------------------------------------------------------
-- Display all departments
----------------------------------------------------------

SELECT *
FROM departments;

----------------------------------------------------------
-- Display all students
----------------------------------------------------------

SELECT *
FROM students;

----------------------------------------------------------
-- Display all courses
----------------------------------------------------------

SELECT *
FROM courses;

----------------------------------------------------------
-- Display all enrollments
----------------------------------------------------------

SELECT *
FROM enrollments;

----------------------------------------------------------
-- Display all professors
----------------------------------------------------------

SELECT *
FROM professors;

-- =======================================================
-- TASK 6 : MULTI TABLE JOINS
-- =======================================================

----------------------------------------------------------
-- 25. Student Full Name with Department Name
----------------------------------------------------------

SELECT
    CONCAT(s.first_name,' ',s.last_name) AS Student_Name,
    d.dept_name AS Department
FROM students s
INNER JOIN departments d
ON s.department_id = d.department_id
ORDER BY Student_Name;

----------------------------------------------------------
-- 26. Student Name with Course Name
----------------------------------------------------------

SELECT
    CONCAT(s.first_name,' ',s.last_name) AS Student_Name,
    c.course_name,
    e.grade,
    e.enrollment_date
FROM enrollments e
INNER JOIN students s
ON e.student_id = s.student_id
INNER JOIN courses c
ON e.course_id = c.course_id
ORDER BY Student_Name;

----------------------------------------------------------
-- 27. Students Not Enrolled in Any Course
----------------------------------------------------------

SELECT
    s.student_id,
    CONCAT(s.first_name,' ',s.last_name) AS Student_Name
FROM students s
LEFT JOIN enrollments e
ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

----------------------------------------------------------
-- 28. Courses with Number of Students Enrolled
----------------------------------------------------------

SELECT
    c.course_name,
    COUNT(e.student_id) AS Enrollment_Count
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
GROUP BY
    c.course_id,
    c.course_name
ORDER BY Enrollment_Count DESC;

----------------------------------------------------------
-- 29. Departments with Professors
----------------------------------------------------------

SELECT
    d.dept_name,
    p.prof_name,
    p.salary
FROM departments d
LEFT JOIN professors p
ON d.department_id = p.department_id
ORDER BY d.dept_name;

-- =======================================================
-- TASK 7 : AGGREGATE FUNCTIONS
-- =======================================================

----------------------------------------------------------
-- 30. Total Enrollments Per Course
----------------------------------------------------------

SELECT
    c.course_name,
    COUNT(e.student_id) AS Enrollment_Count
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
GROUP BY
    c.course_id,
    c.course_name
ORDER BY Enrollment_Count DESC;

----------------------------------------------------------
-- 31. Average Professor Salary Per Department
----------------------------------------------------------

SELECT
    d.dept_name,
    ROUND(AVG(p.salary),2) AS Average_Salary
FROM departments d
LEFT JOIN professors p
ON d.department_id = p.department_id
GROUP BY
    d.department_id,
    d.dept_name
ORDER BY Average_Salary DESC;

----------------------------------------------------------
-- 32. Departments with Budget Greater Than 600000
----------------------------------------------------------

SELECT
    dept_name,
    budget
FROM departments
WHERE budget > 600000;

----------------------------------------------------------
-- 33. Grade Distribution for CS101
----------------------------------------------------------

SELECT
    e.grade,
    COUNT(*) AS Total_Students
FROM enrollments e
INNER JOIN courses c
ON e.course_id = c.course_id
WHERE c.course_code='CS101'
GROUP BY e.grade
ORDER BY e.grade;

----------------------------------------------------------
-- 34. Departments Having More Than Two Students
----------------------------------------------------------

SELECT
    d.dept_name,
    COUNT(DISTINCT s.student_id) AS Total_Students
FROM departments d
INNER JOIN students s
ON d.department_id = s.department_id
GROUP BY
    d.department_id,
    d.dept_name
HAVING COUNT(DISTINCT s.student_id) > 2;

-- =======================================================
-- ADDITIONAL VERIFICATION QUERIES
-- =======================================================

SELECT COUNT(*) AS Department_Count
FROM departments;

SELECT COUNT(*) AS Student_Count
FROM students;

SELECT COUNT(*) AS Course_Count
FROM courses;

SELECT COUNT(*) AS Enrollment_Count
FROM enrollments;

SELECT COUNT(*) AS Professor_Count
FROM professors;

----------------------------------------------------------
-- Display Complete Student Information
----------------------------------------------------------

SELECT
    s.student_id,
    CONCAT(s.first_name,' ',s.last_name) AS Student_Name,
    d.dept_name,
    s.enrollment_year
FROM students s
INNER JOIN departments d
ON s.department_id = d.department_id
ORDER BY s.student_id;

----------------------------------------------------------
-- Display Complete Enrollment Details
----------------------------------------------------------

SELECT
    e.enrollment_id,
    CONCAT(s.first_name,' ',s.last_name) AS Student_Name,
    c.course_name,
    e.grade,
    e.enrollment_date
FROM enrollments e
INNER JOIN students s
ON e.student_id = s.student_id
INNER JOIN courses c
ON e.course_id = c.course_id
ORDER BY e.enrollment_id;

----------------------------------------------------------
-- Display Professor Details
----------------------------------------------------------

SELECT
    p.prof_name,
    d.dept_name,
    p.salary
FROM professors p
INNER JOIN departments d
ON p.department_id = d.department_id
ORDER BY p.salary DESC;
