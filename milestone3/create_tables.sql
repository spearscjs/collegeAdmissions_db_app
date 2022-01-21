DROP view IF EXISTS class_info;

DROP TABLE IF EXISTS grade_conversion;

DROP TABLE IF EXISTS probation_period;
DROP TABLE IF EXISTS quarters_attended;
DROP TABLE IF EXISTS completed_degree;

DROP TABLE IF EXISTS coursework;

DROP TABLE IF EXISTS instructed;
DROP TABLE IF EXISTS meeting;
DROP TABLE IF EXISTS recurring_meeting;
DROP TABLE IF EXISTS enrollment;
DROP TABLE IF EXISTS class;
DROP TABLE IF EXISTS technical_elective;

DROP TABLE IF EXISTS thesis_committee;
DROP TABLE IF EXISTS candidate;
DROP TABLE IF EXISTS fifth_year;
DROP TABLE IF EXISTS phd;
DROP TABLE IF EXISTS master;
DROP TABLE IF EXISTS graduate;
DROP TABLE IF EXISTS undergraduate;
DROP TABLE IF EXISTS student;

DROP TABLE IF EXISTS concentration;
DROP TABLE IF EXISTS degree_concentration;
DROP TABLE IF EXISTS degree;

DROP TABLE IF EXISTS prerequisite;
DROP TABLE IF EXISTS course;

DROP TABLE IF EXISTS faculty;

DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS billing_account;

DROP TABLE IF EXISTS college;
DROP TABLE IF EXISTS major;
DROP TABLE IF EXISTS minor;
DROP TABLE IF EXISTS season;
DROP TABLE IF EXISTS active_year;
DROP TABLE IF EXISTS department;

DROP TABLE IF EXISTS review_day;
DROP TABLE IF EXISTS day_abv_conversion;

-- CONSTANTS ---------------------------------------------------------

-- college(college)
CREATE TABLE college(
	college VARCHAR(20) NOT NULL,
	PRIMARY KEY(college)
);


-- major(major)
CREATE TABLE major(
	major VARCHAR(40) NOT NULL,
	PRIMARY KEY(major)
);


-- minor(minor)
CREATE TABLE minor(
	minor VARCHAR(40) NOT NULL,
	primary key(minor)
);


-- quarter(season, year)
CREATE TABLE season(
	season VARCHAR(30) NOT NULL,
	PRIMARY KEY(season)
);

CREATE TABLE active_year(
	active_year SMALLINT NOT NULL,
	CHECK(active_year >= 1960), -- year UCSD opened
	PRIMARY KEY(active_year)
);


-- department(department)
CREATE TABLE department(
	department VARCHAR(60) NOT NULL,
	PRIMARY KEY(department)
);

-- review_day
CREATE TABLE review_day(
    month VARCHAR(15) NOT NULL,
    date SMALLINT NOT NULL,
    day VARCHAR(10) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    PRIMARY KEY(month, date, day, start_time, end_time)
);

-- day_abv_conversion
CREATE TABLE day_abv_conversion(
    abbreviation VARCHAR(10) NOT NULL,
    day VARCHAR(10) NOT NULL,
    PRIMARY KEY(abbreviation, day)
);

-- NON CONSTANTS ----------------------------------------------------------

-- degree(*degree_id, *type, *department, lower_div_units_required, upper_div_units_required, ~min_avg_grade)
CREATE TABLE degree(
	degree_id VARCHAR(40) NOT NULL,
	degree_type CHAR(4) NOT NULL,
	department VARCHAR(60) NOT NULL,
	lower_div_units_required SMALLINT NOT NULL,
	upper_div_units_required SMALLINT NOT NULL,
    tech_elective_unit SMALLINT NOT NULL,
    grad_units_in_major SMALLINT NOT NULL,
	min_avg_grade NUMERIC(3,2), 
	CHECK(min_avg_grade = NULL OR (min_avg_grade >= 0 AND min_avg_grade <= 5)),
	FOREIGN KEY(department) REFERENCES department(department),
	PRIMARY KEY(degree_id)
);


CREATE TABLE degree_concentration(
     degree_id VARCHAR(25) NOT NULL,
     concentration VARCHAR(40) NOT NULL,
     course_number VARCHAR(10) NOT NULL,
     min_GPA NUMERIC(3,2),
     FOREIGN KEY(degree_id) REFERENCES degree(degree_id),
     PRIMARY KEY(degree_id, concentration, course_number)
);

-- student(student_id, first_name, ~middle_name, last_name, ssn, is_enrolled, *degree_id, residency)
CREATE TABLE student(
	student_id CHAR(9) NOT NULL,
	first_name VARCHAR(25) NOT NULL,
	middle_name VARCHAR(25),
	last_name VARCHAR(25) NOT NULL,
	ssn CHAR(9) NOT NULL, 
	is_enrolled SMALLINT NOT NULL,
	residency VARCHAR(30) NOT NULL,
	CHECK(is_enrolled = 0 OR is_enrolled = 1),
	UNIQUE(ssn),
	PRIMARY KEY(student_id)
);

-- faculty(faculty_id, first_name, ~middle_name, last_name, title, *department)
CREATE TABLE faculty(
	faculty_id CHAR(9) NOT NULL,
	first_name VARCHAR(25) NOT NULL,
	middle_name VARCHAR(25),
	last_name VARCHAR(25) NOT NULL,
	title VARCHAR(25) NOT NULL,
	department VARCHAR(60) NOT NULL,
	FOREIGN KEY(department) REFERENCES department(department),
	UNIQUE(first_name, middle_name, last_name),
	PRIMARY KEY(faculty_id)
);

-- undergraduate(*student_id, *college, *major, *minor)
CREATE TABLE undergraduate(
	student_id CHAR(9) NOT NULL,
	college VARCHAR(20) NOT NULL,
	major VARCHAR(40) NOT NULL,
	minor VARCHAR(40),
	FOREIGN KEY(college) REFERENCES college(college),
	FOREIGN KEY(major) REFERENCES major(major),
	FOREIGN KEY(minor) REFERENCES minor(minor),
	FOREIGN KEY(student_id) REFERENCES student(student_id),
	PRIMARY KEY(student_id)
);

-- graduate(*student_id, *department)
CREATE TABLE graduate(
	student_id CHAR(9) NOT NULL,
	department VARCHAR(60) NOT NULL,
	FOREIGN KEY(department) REFERENCES department(department),
	FOREIGN KEY(student_id) REFERENCES student(student_id),
	PRIMARY KEY(student_id)
);

-- master(*student_id) 
CREATE TABLE master(
	student_id CHAR(9) NOT NULL,
	FOREIGN KEY(student_id) REFERENCES graduate(student_id),
	PRIMARY KEY(student_id)
);


-- 5thyear(*student_id, college, major, minor, ~*department)
CREATE TABLE fifth_year(
	student_id CHAR(9) NOT NULL,
	college VARCHAR(20) NOT NULL,
	major VARCHAR(40) NOT NULL,
	minor VARCHAR(40) NOT NULL,
	department VARCHAR(60),
	FOREIGN KEY(student_id) REFERENCES student(student_id),
	FOREIGN KEY(college) REFERENCES college(college),
	FOREIGN KEY(major) REFERENCES major(major),
	FOREIGN KEY(minor) REFERENCES minor(minor),
	FOREIGN KEY(department) REFERENCES department(department),
	PRIMARY KEY(student_id)
);



-- phd(*student_id, is_candidate, ~advisor_id)
CREATE TABLE phd(
	student_id CHAR(9) NOT NULL,
	is_candidate SMALLINT NOT NULL,
    advisor_id CHAR(9),
	CHECK((is_candidate = 1 AND (advisor_id IS NOT NULL)) OR is_candidate = 0),
	FOREIGN KEY(advisor_id) REFERENCES faculty(faculty_id),
	FOREIGN KEY(student_id) REFERENCES graduate(student_id),
	PRIMARY KEY(student_id)
);



-- thesis_committee(*student_id, *faculty_id)
CREATE TABLE thesis_committee(
	student_id CHAR(9) NOT NULL,
	faculty_id CHAR(9) NOT NULL,
	FOREIGN KEY(faculty_id) REFERENCES faculty(faculty_id),
	FOREIGN KEY(student_id ) REFERENCES graduate(student_id),
	PRIMARY KEY(student_id , faculty_id)
);

-- OMITTED TABLE -- pre-candidate(student_id)

-- course(course_number, course_name, instructor_consent, lab_required, number_of_units, grade_option, *department)
CREATE TABLE course(
	course_number VARCHAR(10) NOT NULL,
	course_name VARCHAR(100) NOT NULL,
	division VARCHAR(10) NOT NULL,
	instructor_consent SMALLINT NOT NULL,
	lab_required SMALLINT NOT NULL,
	number_of_units SMALLINT NOT NULL,
	grade_option VARCHAR(20) NOT NULL,
	department VARCHAR(60) NOT NULL,
	CHECK(lab_required = 0 OR lab_required = 1),
	CHECK(instructor_consent = 0 OR instructor_consent = 1),
	FOREIGN KEY(department) REFERENCES department(department),
	UNIQUE(course_name),
	PRIMARY KEY(course_number)

);


-- class(section_id, *course_number,  title, *season, *year, *faculty_id, mandatory_discussion, enrollment_limit)
CREATE TABLE class(
    course_number VARCHAR(10) NOT NULL,
	section_id CHAR(9) NOT NULL,
	title VARCHAR(100) NOT NULL,
	season VARCHAR(30) NOT NULL,
	active_year SMALLINT NOT NULL,
	faculty_id CHAR(9) NOT NULL,
	enrollment_limit SMALLINT NOT NULL,
	mandatory_discussion SMALLINT NOT NULL,
	CHECK(mandatory_discussion  = 0 OR mandatory_discussion = 1),
	FOREIGN KEY(course_number) REFERENCES course(course_number),
	FOREIGN KEY(active_year) REFERENCES active_year(active_year),
	FOREIGN KEY(season) REFERENCES season(season),
	FOREIGN KEY(faculty_id) REFERENCES faculty(faculty_id),
	PRIMARY KEY(section_id, course_number)
);

-- technical_elective(*course_number)
CREATE TABLE technical_elective(
	course_number VARCHAR(10) NOT NULL,
	FOREIGN KEY(course_number) REFERENCES course(course_number)
);

-- instructed(*faculty_id, section_id, *course_number)
CREATE TABLE instructed( 
	faculty_id CHAR(9) NOT NULL,
	section_id CHAR(9) NOT NULL,
	course_number VARCHAR(10) NOT NULL,
	FOREIGN KEY(faculty_id) REFERENCES faculty(faculty_id),
	FOREIGN KEY(section_id, course_number ) REFERENCES class(section_id, course_number ),
	PRIMARY KEY(faculty_id, section_id, course_number)
);


-- meeting(*section_id, *course_number, meeting_date, meeting_time, meeting_room, meeting_type)
-- date format: YYYY-MM-DD
-- time format: HH-MM [PM/AM]
CREATE TABLE meeting( 
	course_number VARCHAR(10) NOT NULL,
	section_id CHAR(9) NOT NULL,
	scheduled_date CHAR(10) NOT NULL, 
	scheduled_time CHAR(8) NOT NULL, 
	room VARCHAR(20) NOT NULL,
	meeting_type CHAR(20) NOT NULL,
	FOREIGN KEY(section_id, course_number) REFERENCES class(section_id, course_number),
	PRIMARY KEY(section_id, course_number, scheduled_date, scheduled_time, room, meeting_type)
);

CREATE TABLE recurring_meeting(
    course_number VARCHAR(10) NOT NULL,
    section_id CHAR(9) NOT NULL,
    meeting_day CHAR(10) NOT NULL,
    start_time TIME NOT NULL,
    room VARCHAR(20) NOT NULL,
    meeting_type CHAR(20) NOT NULL,
    FOREIGN KEY(section_id, course_number) REFERENCES class(section_id, course_number),
    PRIMARY KEY(section_id, course_number, meeting_day, start_time, room, meeting_type)
);

-- enrollment(*section_id, *course_number, *student_id, grade_option)
CREATE TABLE enrollment( 
	student_id CHAR(9) NOT NULL,
	course_number VARCHAR(10) NOT NULL,
	section_id CHAR(9) NOT NULL,
	grade_option CHAR(10), 
	FOREIGN KEY(section_id, course_number ) REFERENCES class(section_id, course_number),
	FOREIGN KEY(student_id ) REFERENCES student(student_id),
	PRIMARY KEY(section_id, course_number, student_id)
);

-- coursework(*student_id, *course_number, *section_id, grade)
CREATE TABLE coursework(
	student_id CHAR(9) NOT NULL,
	course_number VARCHAR(10) NOT NULL,
	section_id CHAR(9) NOT NULL,
	grade VARCHAR(2) NOT NULL,
	FOREIGN KEY(student_id) REFERENCES student(student_id),
	FOREIGN KEY(course_number, section_id) REFERENCES class(course_number, section_id),
	PRIMARY KEY(student_id, course_number, section_id)
);



-- prerequisite(course_number, prerequisite.course_number)
CREATE TABLE prerequisite(
	course_number VARCHAR(10) NOT NULL,
	prereq_course_number VARCHAR(30) NOT NULL,
	FOREIGN KEY(course_number) REFERENCES course(course_number),
	FOREIGN KEY(prereq_course_number ) REFERENCES course(course_number),
	PRIMARY KEY(course_number, prereq_course_number)
);


-- completed_degree(student_id, degree_title, university_name)
CREATE TABLE completed_degree(
	student_id CHAR(9) NOT NULL,
	degree_title VARCHAR(25) NOT NULL,
	type CHAR(3) NOT NULL,
	university_name VARCHAR(25) NOT NULL,
	FOREIGN KEY(student_id) REFERENCES student(student_id),
	PRIMARY KEY(student_id, degree_title, university_name)
);

--quarters_attended(*student_id,  *start.season, *start.year, *end.season, *end.year)
CREATE TABLE quarters_attended(
	student_id CHAR(9) NOT NULL,
	start_season VARCHAR(30) NOT NULL,
	start_year SMALLINT NOT NULL,
	end_season VARCHAR(30) NOT NULL,
	end_year SMALLINT NOT NULL,
	CHECK(start_year < end_year OR (start_year=end_year AND start_season > end_season)),
	FOREIGN KEY(student_id) REFERENCES student(student_id),
	FOREIGN KEY(start_season) REFERENCES season(season),
	FOREIGN KEY(start_year) REFERENCES active_year(active_year),
	FOREIGN KEY(end_season) REFERENCES season(season),
	FOREIGN KEY(end_year) REFERENCES active_year(active_year),
	PRIMARY KEY(student_id, start_season, start_year, end_season, end_year)
);

-- probation_period(*student_id, *start.season, *start.year, *end.season, *end.year, reason)
CREATE TABLE probation_period(
	student_id CHAR(9) NOT NULL,
	start_season VARCHAR(30) NOT NULL,
	start_year SMALLINT NOT NULL,
	end_season VARCHAR(30) NOT NULL,
	end_year SMALLINT NOT NULL,
	reason VARCHAR(100) NOT NULL,
	CHECK(start_year < end_year OR (start_year=end_year AND start_season > end_season)),
	CHECK(start_year < end_year OR (start_year=end_year AND start_season > end_season)),
	FOREIGN KEY(student_id) REFERENCES student(student_id),
	FOREIGN KEY(start_season) REFERENCES season(season),
	FOREIGN KEY(start_year) REFERENCES active_year(active_year),
	FOREIGN KEY(end_season) REFERENCES season(season),
	FOREIGN KEY(end_year) REFERENCES active_year(active_year),
	PRIMARY KEY(student_id, start_season, start_year, end_season, end_year)

);


-- billing_account(account_number, holder_name, payment_method, address, zip, state, city)
CREATE TABLE billing_account(
	account_number CHAR(16) NOT NULL,
	first_name VARCHAR(25) NOT NULL,
	middle_name VARCHAR(25),
	last_name VARCHAR(25) NOT NULL,
	address VARCHAR(50) NOT NULL,
	zip CHAR(5) NOT NULL, 
	state CHAR(2) NOT NULL,
	city VARCHAR(50) NOT NULL,
	PRIMARY KEY(account_number)
);

-- payment(*account_number, payment_date, payment_amount)
CREATE TABLE payment(
	account_number CHAR(16) NOT NULL,
	payment_date date,
	payment_amount NUMERIC(12,2),
	FOREIGN KEY(account_number) REFERENCES billing_account(account_number),
	PRIMARY KEY(account_number, payment_amount)
);


-- grade_conversion(letter_grade, number_grade)
create table grade_conversion(
	letter_grade CHAR(2) NOT NULL,
	number_grade DECIMAL(2,1)
);


                   

-----------------------------------------------------------------------------
-- FILL CONSTANT TABLES
-----------------------------------------------------------------------------

-- grade_conversion(letter_grade, number_grade)
insert into grade_conversion values('A+', 4.3);
insert into grade_conversion values('A', 4);
insert into grade_conversion values('A-', 3.7);
insert into grade_conversion values('B+', 3.4);
insert into grade_conversion values('B', 3.1);
insert into grade_conversion values('B-', 2.8);
insert into grade_conversion values('C+', 2.5);
insert into grade_conversion values('C', 2.2);
insert into grade_conversion values('C-', 1.9);
insert into grade_conversion values('D', 1.6);
insert into grade_conversion values('F', 0);


-- college(college)
INSERT INTO college(college) VALUES('warren');
INSERT INTO college(college) VALUES('muir');
INSERT INTO college(college) VALUES('revelle');
INSERT INTO college(college) VALUES('marshall');
INSERT INTO college(college) VALUES('roosevelt');
INSERT INTO college(college) VALUES('sixth');
INSERT INTO college(college) VALUES('seventh');

-- major(major)
INSERT INTO major(major) VALUES('computer science');
INSERT INTO major(major) VALUES('computer engineering');
INSERT INTO major(major) VALUES('data science');
INSERT INTO major(major) VALUES('physics');
INSERT INTO major(major) VALUES('economics');
INSERT INTO major(major) VALUES('philosophy');
INSERT INTO major(major) VALUES('B.S. in Computer Science');
INSERT INTO major(major) VALUES('B.S. in Mechanical Engineering');
INSERT INTO major(major) VALUES('B.A. in Philosophy');

-- minor(minor)
INSERT INTO minor(minor) VALUES('computer science');
INSERT INTO minor(minor) VALUES('computer engineering');
INSERT INTO minor(minor) VALUES('data science');
INSERT INTO minor(minor) VALUES('physics');
INSERT INTO minor(minor) VALUES('economics');
INSERT INTO minor(minor) VALUES('philosophy');
INSERT INTO minor(minor) VALUES('N/A');


-- department(department)
INSERT INTO department(department) VALUES('computer science and engineering');
INSERT INTO department(department) VALUES('computer science');
INSERT INTO department(department) VALUES('data science');
INSERT INTO department(department) VALUES('physics');
INSERT INTO department(department) VALUES('economics');
INSERT INTO department(department) VALUES('philosophy');
INSERT INTO department(department) VALUES('mechanical engineering');

-- season(season)
INSERT INTO season(season) VALUES ('fall');
INSERT INTO season(season) VALUES ('winter');
INSERT INTO season(season) VALUES ('spring');
INSERT INTO season(season) VALUES ('summer 1');
INSERT INTO season(season) VALUES ('summer 2');
INSERT INTO season(season) VALUES ('summer special');

-- year(year)
INSERT INTO active_year(active_year) SELECT * FROM   generate_series(1960, 2022);

-- review_day
INSERT INTO  review_day(month, date, day, start_time, end_time)
VALUES
    ('May', 5, 'Monday', '8:00:00', '9:00:00'),
    ('May', 5, 'Monday', '9:00:00', '10:00:00'),
    ('May', 5, 'Monday', '10:00:00', '11:00:00'),
    ('May', 5, 'Monday', '11:00:00', '12:00:00'),
    ('May', 5, 'Monday', '12:00:00', '13:00:00'),
    ('May', 5, 'Monday', '13:00:00', '14:00:00'),
    ('May', 5, 'Monday', '14:00:00', '15:00:00'),
    ('May', 5, 'Monday', '15:00:00', '16:00:00'),
    ('May', 5, 'Monday', '16:00:00', '17:00:00'),
    ('May', 5, 'Monday', '17:00:00', '18:00:00'),
    ('May', 5, 'Monday', '18:00:00', '19:00:00'),
    ('May', 5, 'Monday', '19:00:00', '20:00:00'),
    ('May', 6, 'Tuesday', '8:00:00', '9:00:00'),
    ('May', 6, 'Tuesday', '9:00:00', '10:00:00'),
    ('May', 6, 'Tuesday', '10:00:00', '11:00:00'),
    ('May', 6, 'Tuesday', '11:00:00', '12:00:00'),
    ('May', 6, 'Tuesday', '12:00:00', '13:00:00'),
    ('May', 6, 'Tuesday', '14:00:00', '15:00:00'),
    ('May', 6, 'Tuesday', '15:00:00', '16:00:00'),
    ('May', 6, 'Tuesday', '16:00:00', '17:00:00'),
    ('May', 6, 'Tuesday', '17:00:00', '18:00:00'),
    ('May', 6, 'Tuesday', '18:00:00', '19:00:00'),
    ('May', 6, 'Tuesday', '19:00:00', '20:00:00'),
    ('May', 7, 'Wednesday', '8:00:00', '9:00:00'),
    ('May', 7, 'Wednesday', '9:00:00', '10:00:00'),
    ('May', 7, 'Wednesday', '10:00:00', '11:00:00'),
    ('May', 7, 'Wednesday', '11:00:00', '12:00:00'),
    ('May', 7, 'Wednesday', '12:00:00', '13:00:00'),
    ('May', 7, 'Wednesday', '14:00:00', '15:00:00'),
    ('May', 7, 'Wednesday', '15:00:00', '16:00:00'),
    ('May', 7, 'Wednesday', '16:00:00', '17:00:00'),
    ('May', 7, 'Wednesday', '17:00:00', '18:00:00'),
    ('May', 7, 'Wednesday', '18:00:00', '19:00:00'),
    ('May', 7, 'Wednesday', '19:00:00', '20:00:00'),
    ('May', 8, 'Thursday', '8:00:00', '9:00:00'),
    ('May', 8, 'Thursday', '9:00:00', '10:00:00'),
    ('May', 8, 'Thursday', '10:00:00', '11:00:00'),
    ('May', 8, 'Thursday', '11:00:00', '12:00:00'),
    ('May', 8, 'Thursday', '12:00:00', '13:00:00'),
    ('May', 8, 'Thursday', '14:00:00', '15:00:00'),
    ('May', 8, 'Thursday', '15:00:00', '16:00:00'),
    ('May', 8, 'Thursday', '16:00:00', '17:00:00'),
    ('May', 8, 'Thursday', '17:00:00', '18:00:00'),
    ('May', 8, 'Thursday', '18:00:00', '19:00:00'),
    ('May', 8, 'Thursday', '19:00:00', '20:00:00'),
    ('May', 9, 'Friday', '8:00:00', '9:00:00'),
    ('May', 9, 'Friday', '9:00:00', '10:00:00'),
    ('May', 9, 'Friday', '10:00:00', '11:00:00'),
    ('May', 9, 'Friday', '11:00:00', '12:00:00'),
    ('May', 9, 'Friday', '12:00:00', '13:00:00'),
    ('May', 9, 'Friday', '14:00:00', '15:00:00'),
    ('May', 9, 'Friday', '15:00:00', '16:00:00'),
    ('May', 9, 'Friday', '16:00:00', '17:00:00'),
    ('May', 9, 'Friday', '17:00:00', '18:00:00'),
    ('May', 9, 'Friday', '18:00:00', '19:00:00'),
    ('May', 9, 'Friday', '19:00:00', '20:00:00');

-- day_abv_conversion
INSERT INTO day_abv_conversion(abbreviation, day)
VALUES
    ('MWF', 'Monday'),
    ('MWF', 'Wednesday'),
    ('MWF', 'Friday'),
    ('MW', 'Monday'),
    ('MW', 'Wednesday'),
    ('MF', 'Monday'),
    ('MF', 'Friday'),
    ('WF', 'Wednesday'),
    ('WF', 'Friday'),
    ('M', 'Monday'),
    ('W', 'Wednesday'),
    ('F', 'Friday'),
    ('TueThu', 'Tuesday'),
    ('TueThu', 'Thursday'),
    ('Tue', 'Tuesday'),
    ('Thu', 'Thursday');