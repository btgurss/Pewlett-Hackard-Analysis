--Creating table to list all eligible retirees(including those no longer working)
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
--Saving data to new table
INTO eligible_retirees_with_duplicates
--Joining the employees and titles tables
FROM employees as e
INNER JOIN titles as t
	ON (e.emp_no = t.emp_no)
--Filtering to those birthdays between January 1, 1952 and December 31, 1955
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
--Ordering table by employee number
ORDER BY emp_no;

--Printing information to check for errors
SELECT *
FROM eligible_retirees_with_duplicates;



-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
	first_name,
	last_name,
	title
--Saving information to new table
INTO eligible_retirees_without_duplicate_id
FROM eligible_retirees_with_duplicates
--Ordering by employee number and deleting duplicates with new job titles (keep new)
ORDER BY emp_no, to_date DESC;

--Printing information to check for errors
SELECT *
FROM eligible_retirees_without_duplicate_id;


--Using count and groupby to find number of retirees by job title
SELECT COUNT(emp_no) AS "Number of Retirees", 
	title AS "Job Title"
INTO retiring_titles
FROM eligible_retirees_without_duplicate_id
--Grouping by title
GROUP BY title
--ORDER BY emp_no DESC
ORDER BY "Number of Retirees" DESC;

--Printing information to check for errors
SELECT *
FROM retiring_titles;


--Mentorship eligibility tables
--Retrieving columns for new table
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
--Save to new table
INTO membership_eligibility
--Joining three tables (employees, department_employees, and titles)
FROM employees AS e
	INNER JOIN department_employees AS de
		ON (e.emp_no = de.emp_no)
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
--Filtering staff who are still employed at company
WHERE (de.to_date = '9999-01-01')
--Filtering staff with birthdays in 1965
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
--Ordering table by employee number
ORDER BY e.emp_no;
