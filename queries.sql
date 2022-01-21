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


























-- MILESTONE 4 ------------------------------------------------------------------------------------------------------------------
/*
-- find violations
SELECT * FROM meeting_info e1, meeting_info e2
	WHERE e1.course_number = e2.course_number 
		AND e1.section_id = e2.section_id
		AND e1.day = e2.day
		AND (
				(
					e2.start_time >= e1.start_time
					AND
					e2.start_time <= e1.end_time
				)
				OR
				(
					e2.end_time >= e1.start_time
					AND
					e2.end_time <= e1.end_time
				)
		)
		AND e1.* != e2.*
		AND e1.start_time < e2.start_time;
*/


/*
-- overlap trigger
CREATE OR REPLACE FUNCTION meeting_overlap() RETURNS TRIGGER AS 
$$
BEGIN
	IF EXISTS(
		SELECT * FROM meeting_info e1
		WHERE e1.course_number = NEW.course_number 
			AND e1.section_id = NEW.section_id
			AND EXISTS(
				SELECT * FROM day_abv_conversion d 
					WHERE NEW.meeting_day = d.abbreviation
						AND e1.day = d.day
			)
			AND (
					(
						NEW.start_time >= e1.start_time
						AND
						NEW.start_time <= e1.end_time
					)
					OR
					(
						NEW.start_time + interval '50 minutes' >= e1.start_time
						AND
						NEW.start_time + interval '50 minutes' <= e1.end_time
					)
			)	
	)
	THEN RAISE EXCEPTION 'failed: overlap';
	END IF;
	return NEW;
END;
$$
LANGUAGE 'plpgsql';



DROP TRIGGER IF EXISTS check_recurring ON recurring_meeting;
CREATE TRIGGER check_recurring AFTER INSERT ON recurring_meeting
    FOR EACH ROW 
	EXECUTE PROCEDURE meeting_overlap();
*/
