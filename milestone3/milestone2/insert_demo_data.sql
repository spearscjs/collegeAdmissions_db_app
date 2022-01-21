
-----------------------------------------------------------------------------
-- FILL TABLES
-----------------------------------------------------------------------------
INSERT INTO student
    (student_id, first_name, last_name, ssn, is_enrolled, residency)
VALUES
    (1, 'Benjamin', 'B', 1, 1, 'California resident'),
    (2, 'Kristen', 'W', 2, 0, 'California resident'),
    (3, 'Daniel', 'F', 3, 1, 'California resident'),
    (4, 'Claire', 'J', 4, 1, 'California resident'),
    (5, 'Julie', 'C', 5, 1, 'California resident'),
    (6, 'Kevin', 'L', 6, 0, 'California resident'),
    (7, 'Michael', 'B', 7, 1, 'California resident'),
    (8, 'Joseph', 'J', 8, 1, 'California resident'),
    (9, 'Devin', 'P', 9, 1, 'California resident'),
    (10, 'Logan', 'F', 10, 0, 'California resident'),
    (11, 'Vikram', 'N', 11, 0, 'California resident'),
    (12, 'Rachel', 'Z', 12, 1, 'California resident'),
    (13, 'Zach', 'M', 13, 1, 'California resident'),
    (14, 'Justin', 'H', 14, 1, 'California resident'),
    (15, 'Rahul', 'R', 15, 1, 'California resident'),
    (16, 'Dave', 'C', 16, 1, 'California resident'),
    (17, 'Nelson', 'H', 17, 1, 'California resident'),
    (18, 'Andrew', 'P', 18, 1, 'California resident'),
    (19, 'Nathan', 'S', 19, 1, 'California resident'),
    (20, 'John', 'H', 20, 1, 'California resident'),
    (21, 'Anwell', 'W', 21, 1, 'California resident'),
    (22, 'Tim', 'K', 22, 1, 'California resident');

INSERT INTO undergraduate
    (student_id, college, major, minor)
VALUES
    (1, 'marshall', 'B.S. in Computer Science', 'N/A'),
    (2, 'marshall', 'B.S. in Computer Science', 'N/A'),
    (3, 'marshall', 'B.S. in Computer Science', 'N/A'),
    (4, 'marshall', 'B.S. in Computer Science', 'N/A'),
    (5, 'marshall', 'B.S. in Computer Science', 'N/A'),
    (6, 'marshall', 'B.S. in Mechanical Engineering', 'N/A'),
    (7, 'marshall', 'B.S. in Mechanical Engineering', 'N/A'),
    (8, 'marshall', 'B.S. in Mechanical Engineering', 'N/A'),
    (9, 'marshall', 'B.S. in Mechanical Engineering', 'N/A'),
    (10, 'marshall', 'B.S. in Mechanical Engineering', 'N/A'),
    (11, 'marshall', 'B.A. in Philosophy', 'N/A'),
    (12, 'marshall', 'B.A. in Philosophy', 'N/A'),
    (13, 'marshall', 'B.A. in Philosophy', 'N/A'),
    (14, 'marshall', 'B.A. in Philosophy', 'N/A'),
    (15, 'marshall', 'B.A. in Philosophy', 'N/A');

INSERT INTO graduate
    (student_id, department)
VALUES
    (16, 'computer science'),
    (17, 'computer science'),
    (18, 'computer science'),
    (19, 'computer science'),
    (20, 'computer science'),
    (21, 'computer science'),
    (22, 'computer science');

INSERT INTO master
    (student_id)
VALUES
    (16),
    (17),
    (18),
    (19),
    (20),
    (21),
    (22);

INSERT INTO faculty
    (faculty_id, first_name, last_name, title, department)
VALUES
    (1, 'Justin', 'Bieber', 'Associate Professor', 'computer science and engineering'),
    (2, 'Flo', 'Rida', 'Professor', 'computer science and engineering'),
    (3, 'Selena', 'Gomez', 'Professor', 'mechanical engineering'),
    (4, 'Adele', 'N/A', 'Professor', 'computer science and engineering'),
    (5, 'Taylor', 'Swift', 'Professor', 'computer science and engineering'),
    (6, 'Kelly', 'Clarkson', 'Professor', 'computer science and engineering'),
    (7, 'Adam', 'Levine', 'Professor', 'philosophy'),
    (8, 'Bjork', 'N/A', 'Professor', 'computer science and engineering');


INSERT INTO degree
    (degree_id, degree_type, department, lower_div_units_required, upper_div_units_required, tech_elective_unit, grad_units_in_major, min_avg_grade)
VALUES
    ('B.S. Computer Science', 'B.S.', 'computer science', 10, 15, 15, 0, 3.0),
    ('B.A. Philosophy', 'B.A.', 'philosophy', 15, 20, 0, 0, 3.0),
    ('B.S. Mechanical Engineering', 'B.S.', 'mechanical engineering', 20, 20, 10, 0, 3.0),
    ('M.S. Computer Science', 'M.S.', 'computer science', 0, 0, 0, 45, 3.0);



INSERT INTO degree_concentration
    (degree_id, concentration, course_number, min_GPA)
VALUES
    ('M.S. Computer Science', 'Databases', 'CSE232A', 3),
    ('M.S. Computer Science', 'AI', 'CSE255', 3.1),
    ('M.S. Computer Science', 'AI', 'CSE250A', 3.1),
    ('M.S. Computer Science', 'Systems', 'CSE221', 3.3);



INSERT INTO course
    (course_number, course_name, division, instructor_consent, lab_required, number_of_units, grade_option, department)
VALUES
    ('CSE8A', 'Introduction to Computer Science: Java', 'lower', 0, 0, 4, 'letter grade' , 'computer science and engineering'),
    ('CSE105', 'Intro to Theory', 'upper', 0, 0, 4, 'letter grade' , 'computer science and engineering'),
    ('CSE123', 'Computer Networks', 'upper', 0, 0, 4, 'letter grade' , 'computer science and engineering'),
	('CSE250A', 'Probabilistic Reasoning', 'graduate', 0, 0, 4, 'letter grade' , 'computer science and engineering'),
    ('CSE250B', 'Machine Learning', 'graduate', 0, 0, 4, 'letter grade' , 'computer science and engineering'),
    ('CSE255', 'Data Mining and Predictive Analytics', 'graduate', 0, 0, 4, 'letter grade' , 'computer science and engineering'),
    ('CSE232A', 'Databases', 'graduate', 0, 0, 4, 'letter grade' , 'computer science and engineering'),
    ('CSE221', 'Operating Systems', 'graduate', 0, 0, 4, 'letter grade' , 'computer science and engineering'),
    ('MAE3', 'Introduction to Engineering Graphics and Design', 'upper', 0, 0, 4, 'letter grade' , 'mechanical engineering'),
    ('MAE107', 'Computational Methods', 'upper', 0, 0, 4, 'letter grade' , 'mechanical engineering'),
    ('MAE108', 'Probability and Statistics', 'upper', 0, 0, 2, 'letter grade' , 'mechanical engineering'),
    ('PHIL10', 'Intro to Logic', 'lower', 0, 0, 4, 'letter grade' , 'philosophy'),
    ('PHIL12', 'Scientific Reasoning', 'lower', 0, 0, 4, 'letter grade' , 'philosophy'),
    ('PHIL165', 'Freedom, Equality, and the Law', 'upper', 0, 0, 2, 'letter grade' , 'philosophy'),
    ('PHIL167', 'Contemporary Political Philosophy', 'upper', 0, 0, 4, 'letter grade' , 'philosophy');
 
 

	

INSERT INTO class 
	(course_number, section_id, title, season, active_year, faculty_id, enrollment_limit, mandatory_discussion)
VALUES
	('CSE8A', '100', 'Introduction to Computer Science: Java', 'winter', 2017, 1, 100, 0),
	('CSE8A', '101', 'Introduction to Computer Science: Java', 'fall', 2017, 3, 100, 0),
	('CSE8A', '102', 'Introduction to Computer Science: Java', 'winter', 2018, 6, 100, 0),
	('CSE8A', '103', 'Introduction to Computer Science: Java', 'spring', 2022, 1, 100, 0),
	('CSE8A', '104', 'Introduction to Computer Science: Java', 'spring', 2022, 1, 100, 0),
	('CSE105', '105', 'Intro to Theory', 'spring', 2017, 5, 100, 0),
	('CSE105', '106', 'Intro to Theory', 'fall', 2021, 1, 100, 0),
	('CSE250A', '107', 'Probabilistic Reasoning', 'winter', 2017, 8, 100, 0),
	('CSE250A', '108', 'Probabilistic Reasoning', 'winter', 2018, 8, 100, 0),
	('CSE250A', '109', 'Probabilistic Reasoning', 'winter', 2022, 1, 100, 0),
	('CSE250B', '110', 'Probabilistic Reasoning', 'spring', 2017, 1, 100, 0),
	('CSE250B', '111', 'Probabilistic Reasoning', 'fall', 2022, 1, 100, 0),
	('CSE255', '112', 'Data Mining and Predictive Analytics', 'winter', 2018, 1, 100, 0),
	('CSE255', '113', 'Data Mining and Predictive Analytics', 'winter', 2022, 1, 100, 0),
	('CSE232A', '114', 'Databases', 'winter', 2018, 6, 100, 0),
	('CSE232A', '115', 'Databases', 'spring', 2022, 1, 100, 0),
	('CSE221', '116', 'Operating Systems', 'fall', 2017, 1, 100, 0),
	('CSE221', '117', 'Operating Systems', 'fall', 2021, 1, 100, 0),
	('MAE107', '118', 'Computational Methods', 'fall', 2017, 8, 100, 0),
	('MAE107', '119', 'Computational Methods', 'spring', 2022, 1, 100, 0),
	('MAE108', '120', 'Probability and Statistics', 'winter', 2017, 2, 100, 0),
	('MAE108', '121', 'Probability and Statistics', 'spring', 2017, 3, 100, 0),
	('MAE108', '122', 'Probability and Statistics', 'fall', 2021, 1, 100, 0),
	('PHIL10', '123', 'Intro to Logic', 'winter', 2018, 8, 100, 0),
	('PHIL10', '124', 'Intro to Logic', 'winter', 2022, 1, 100, 0),
	('PHIL12', '125', 'Scientific Reasoning', 'spring', 2022, 1, 100, 0),
	('PHIL165', '126', 'Freedom, Equality, and the Law', 'fall', 2017, 2, 100, 0),
	('PHIL165', '127', 'Freedom, Equality, and the Law', 'winter', 2018, 7, 100, 0),
	('PHIL165', '128', 'Freedom, Equality, and the Law', 'spring', 2022, 1, 100, 0),
	
	-- current year
	('MAE108', '1', 'Probability and Statistics', 'spring', 2021, 4, 100, 0),
	('CSE221', '2', 'Operating Systems', 'spring', 2021, 6, 100, 0),
	('CSE255', '3', 'Data Mining and Predictive Analytics', 'spring', 2021, 2, 100, 0),
	('PHIL12', '4', 'Scientific Reasoning', 'spring', 2022, 7, 100, 0),
	('CSE221', '5', 'Operating Systems', 'spring', 2021, 6, 100, 0),
	('CSE105', '6', 'Intro to Theory', 'spring', 2021, 5, 100, 0),
	('PHIL165', '7', 'Freedom, Equality, and the Law', 'spring', 2021, 7, 100, 0),
	('MAE108', '8', 'Probability and Statistics', 'spring', 2021, 3, 100, 0),
	('CSE221', '9', 'Operating Systems', 'spring', 2021, 1, 100, 0),
	('CSE8A', '10', 'Introduction to Computer Science: Java', 'spring', 2021, 4, 100, 0);
	

INSERT INTO technical_elective
	(course_number) 
VALUES
	('CSE250A'),
	('CSE221'),
	('CSE105'),
	('MAE107'),
	('MAE3');
	


INSERT INTO coursework
	(student_id, course_number, section_id, grade) 
VALUES
	('1', 'CSE8A', '100', 'A-'),
	('3', 'CSE8A', '100', 'B+'),
	('2', 'CSE8A', '101', 'C-'),
	('4', 'CSE8A', '102', 'A-'),
	('5', 'CSE8A', '102', 'B'),
	('1', 'CSE105', '105', 'A-'),
	('5', 'CSE105', '105', 'B+'),
	('4', 'CSE105', '105', 'C'),
	('16', 'CSE250A', '107', 'C'),
	('22', 'CSE250A', '108', 'B+'),
	('18', 'CSE250A', '108', 'D'),
	('19', 'CSE250A', '108', 'F'),
	('17', 'CSE250B', '110', 'A'),
	('19', 'CSE250B', '110', 'A'),
	('20', 'CSE255', '112', 'B-'),
	('18', 'CSE255', '112', 'B'),
	('21', 'CSE255', '112', 'F'),
	('17', 'CSE232A', '114', 'A-'),
	('22', 'CSE221', '116', 'A'),
	('20', 'CSE221', '116', 'A'),
	('10', 'MAE107', '118', 'B+'),
	('8', 'MAE108', '120', 'B-'),
	('7', 'MAE108', '120', 'A-'),
	('6', 'MAE108', '121', 'B'),
	('10', 'MAE108', '121', 'B+'),
	('11', 'PHIL10', '124', 'A'),
	('12', 'PHIL10', '124', 'A'),
	('13', 'PHIL10', '124', 'C-'),
	('14', 'PHIL10', '124', 'C+'),
	('15', 'PHIL165', '126', 'F'),
	('12', 'PHIL165', '126', 'D'),
	('11', 'PHIL165', '127', 'A-');
	

INSERT INTO enrollment
	(section_id, course_number, student_id, grade_option) 
VALUES
	('2', 'CSE221', '16', 'letter'),
	('9', 'CSE221', '17', 's/u'),
	('5', 'CSE221', '18', 'letter'),
	('2', 'CSE221', '19', 'letter'),
	('9', 'CSE221', '20', 'letter'),
	('5', 'CSE221', '21', 's/u'),
	('3', 'CSE255', '22', 'letter'),
	('3', 'CSE255', '16', 'letter'),
	('3', 'CSE255', '17', 'letter'),
	('10', 'CSE8A', '1', 's/u'),
	('10', 'CSE8A', '5', 'letter'),
	('10', 'CSE8A', '3', 'letter'),
	('1', 'MAE108', '7', 'letter'),
	('1', 'MAE108', '8', 'letter'),
	('8', 'MAE108', '9', 'letter'),
	('6', 'CSE105', '4', 'letter'),
	('5', 'CSE221', '12', 'letter'),
	('7', 'PHIL165', '13', 's/u'),
	('4', 'PHIL12', '14', 'letter'),
	('7', 'PHIL165', '15', 'letter');

-- some data for MILESTONE 4&5 are commented out
INSERT INTO recurring_meeting
    (course_number, section_id, meeting_day, start_time, room, meeting_type)
VALUES
    ('MAE108', '1', 'MWF', '10:00:00', 'N/A', 'Lec'),
--     ('MAE108', '1', 'TueThu', '10:00:00', 'N/A', 'Dis'),
--     ('MAE108', '1', 'F', '18:00:00', 'N/A', 'Lab'),
    ('CSE221', '2', 'MWF', '10:00:00', 'N/A', 'Lec'),
--     ('CSE221', '2', 'TueThu', '11:00:00', 'N/A', 'Dis'),
    ('CSE255', '3', 'MWF', '12:00:00', 'N/A', 'Lec'),
    ('PHIL12', '4', 'MWF', '12:00:00', 'N/A', 'Lec'),
--     ('PHIL12', '4', 'WF', '13:00:00', 'N/A', 'Dis'),
    ('CSE221', '5', 'MWF', '12:00:00', 'N/A', 'Lec'),
--     ('CSE221', '5', 'TueThu', '12:00:00', 'N/A', 'Dis'),
    ('CSE105', '6', 'TueThu', '14:00:00', 'N/A', 'Lec'),
    ('CSE105', '6', 'F', '18:00:00', 'N/A', 'Dis'),
    ('PHIL165', '7', 'TueThu', '15:00:00', 'N/A', 'Lec'),
--     ('PHIL165', '7', 'Thu', '13:00:00', 'N/A', 'Dis'),
    ('MAE108', '8', 'TueThu', '15:00:00', 'N/A', 'Lec'),
--     ('MAE108', '8', 'M', '15:00:00', 'N/A', 'Dis'),
    ('CSE221', '9', 'TueThu', '17:00:00', 'N/A', 'Lec'),
--     ('CSE221', '9', 'MF', '9:00:00', 'N/A', 'Dis'),
    ('CSE8A', '10', 'TueThu', '17:00:00', 'N/A', 'Lec'),
    ('CSE8A', '10', 'W', '19:00:00', 'N/A', 'Dis');


	