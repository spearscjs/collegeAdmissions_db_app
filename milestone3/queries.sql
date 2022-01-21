-- 1e ------------------------------------------------------------------------------------------------------------------
/*
-- GET COMPLETED CONCENTRATIONS ---------------------------------------
-- ALL CONCENTRATIONS MEETING REQUIRED GPA
(
	SELECT concentration
	FROM degree_concentration 
	INNER JOIN coursework ON degree_concentration.course_number = coursework.course_number 
	INNER JOIN course ON course.course_number = coursework.course_number 
	INNER JOIN grade_conversion ON grade_conversion.letter_grade = coursework.grade 
	WHERE student_id = '22' AND degree_id = 'M.S. Computer Science'
	GROUP BY (concentration)
	HAVING ROUND(AVG(number_grade), 2) >= MAX(min_gpa)
)
INTERSECT 
-- ALL CONCENTRATIONS MEETING COURSE REQUIREMENTS (ALL COURSES IN CONCENTRATION TAKEN)
( 
	-- ALL CONCENTRATIONS
	SELECT concentration 
	FROM degree_concentration 
	WHERE degree_id = 'M.S. Computer Science'

	EXCEPT
	-- INCOMPLETE CONCENTRATIONS
	SELECT concentration 
	FROM (
		SELECT concentration, course_number
		FROM degree_concentration WHERE degree_id = 'M.S. Computer Science'

		EXCEPT 


		SELECT concentration, coursework.course_number 
		FROM degree_concentration 
		INNER JOIN coursework ON degree_concentration.course_number = coursework.course_number 
		WHERE (grade < 'F' OR grade = 'P') AND student_id = '22' AND degree_id = 'M.S. Computer Science') incomplete

)
*/









/*
-- GET NEEDED COURSES WITH NEXT COURSE OFFERING --------------------------------------------

SELECT needed.concentration, needed.course_number, schedule.next_offering
FROM (
	(SELECT * 
	FROM (
		SELECT concentration, course_number
		FROM degree_concentration WHERE degree_id = 'M.S. Computer Science'

		EXCEPT 

		SELECT concentration, coursework.course_number 
		FROM degree_concentration 
		INNER JOIN coursework ON degree_concentration.course_number = coursework.course_number 
		WHERE (grade < 'F' OR grade = 'P') AND student_id = '14' AND degree_id = 'M.S. Computer Science') incomplete)
) needed
INNER JOIN(
	SELECT course_number, MIN(CONCAT(CONCAT(active_year, ' '), season)) AS next_offering FROM class 
			   WHERE active_year > 2021 OR (active_year = 2021 AND season > 'spring') GROUP BY course_number
) schedule
ON (needed.course_number = schedule.course_number);
*/ 







-- 3a ---------------------------------------------------------------------------------------------------------------
/*
-- professor grade count for class
SELECT coursework.course_number, grade, season, active_year, COUNT(*)
FROM coursework, class, grade_conversion
WHERE coursework.course_number = class.course_number AND faculty_id = '1' AND coursework.course_number = 'CSE8A' AND coursework.section_id = class.section_id
AND grade_conversion.letter_grade = coursework.grade
GROUP BY(coursework.course_number, grade, season, active_year);
*/

/*
SELECT * FROM class, coursework, grade_conversion
WHERE class.course_number = coursework.course_number 
	AND class.section_id = coursework.section_id
	AND grade_conversion.letter_grade = coursework.grade
	GROUP BY(class.course_number);
*/

/*
SELECT coursework.course_number, grade, COUNT(*) 
FROM coursework, class, grade_conversion
WHERE coursework.course_number = class.course_number AND faculty_id = '4' AND season = 'spring' AND active_year = '2021' AND coursework.course_number = 'CSE8A' AND coursework.section_id = class.section_id
AND grade_conversion.letter_grade = coursework.grade
GROUP BY(coursework.course_number, grade);
*/

/*
SELECT  coursework.course_number, season, active_year, grade, COUNT(*)
FROM coursework, class
WHERE coursework.course_number = 'CSE8A' AND coursework.course_number = class.course_number AND coursework.section_id = class.section_id
GROUP BY(coursework.course_number, season, active_year, grade);
*/