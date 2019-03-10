CREATE DATABASE uni;
CREATE UNLOGGED TABLE Degrees(DegreeId INT PRIMARY KEY,Dept VARCHAR,DegreeDescription VARCHAR,TotalECTS INT);
CREATE UNLOGGED TABLE Students(StudentId INT PRIMARY KEY,StudentName VARCHAR,Address VARCHAR,BirthyearStudent INT,Gender VARCHAR);
CREATE UNLOGGED TABLE Teachers(TeacherId INT PRIMARY KEY,TeacherName VARCHAR,Address VARCHAR,BirthyearTeacher INT,Gender VARCHAR) ;
CREATE UNLOGGED TABLE Courses(CourseId INT PRIMARY KEY,CourseName VARCHAR,CourseDescription VARCHAR,DegreeId INT ,ECTS INT);
CREATE UNLOGGED TABLE CourseOffers(CourseOfferId INT PRIMARY KEY,CourseId INT, Year INT ,Quartile INT );
CREATE UNLOGGED TABLE StudentRegistrationsToDegrees(StudentRegistrationId INT PRIMARY KEY,StudentId INT,DegreeId INT ,RegistrationYear INT );
CREATE UNLOGGED TABLE CourseRegistrations(CourseOfferId INT,StudentRegistrationId INT ,Grade INT );
CREATE UNLOGGED TABLE StudentAssistants(CourseOfferId INT,StudentRegistrationId INT );
CREATE UNLOGGED TABLE TeacherAssignmentsToCourses(CourseOfferId INT ,TeacherId INT);
COPY CourseOffers(CourseOfferId,CourseId,Year,Quartile)  FROM '/mnt/ramdisk/tables/CourseOffers.table' DELIMITER ',' CSV HEADER;
COPY CourseRegistrations(CourseOfferId,StudentRegistrationId,Grade)  FROM '/mnt/ramdisk/tables/CourseRegistrations.table' DELIMITER ',' CSV HEADER NULL 'null';
COPY Courses(CourseId,CourseName,CourseDescription,DegreeId,ECTS)  FROM '/mnt/ramdisk/tables/Courses.table' DELIMITER ',' CSV HEADER;
COPY Degrees(DegreeId,Dept,DegreeDescription,TotalECTS)  FROM '/mnt/ramdisk/tables/Degrees.table' DELIMITER ',' CSV HEADER;
COPY StudentAssistants(CourseOfferId,StudentRegistrationId)  FROM '/mnt/ramdisk/tables/StudentAssistants.table' DELIMITER ',' CSV HEADER;
COPY StudentRegistrationsToDegrees(StudentRegistrationId,StudentId,DegreeId,RegistrationYear)  FROM '/mnt/ramdisk/tables/StudentRegistrationsToDegrees.table' DELIMITER ',' CSV HEADER;
COPY Students(StudentId,StudentName,Address,BirthyearStudent,Gender)  FROM '/mnt/ramdisk/tables/Students.table' DELIMITER ',' CSV HEADER;
COPY TeacherAssignmentsToCourses(CourseOfferId,TeacherId)  FROM '/mnt/ramdisk/tables/TeacherAssignmentsToCourses.table' DELIMITER ',' CSV HEADER;
COPY Teachers(TeacherId,TeacherName,Address,BirthyearTeacher,Gender)  FROM '/mnt/ramdisk/tables/Teachers.table' DELIMITER ',' CSV HEADER;
CREATE UNLOGGED TABLE CourseRegistrations_NULL AS SELECT * FROM CourseRegistrations WHERE NOT (CourseRegistrations.grade IS NOT NULL) ORDER BY studentregistrationid;
CREATE UNLOGGED TABLE CourseRegistrations_failed AS SELECT * FROM CourseRegistrations WHERE grade < 4 ORDER BY studentregistrationid;
CREATE UNLOGGED TABLE CourseRegistrations_4 AS SELECT * FROM CourseRegistrations WHERE grade = 4 ORDER BY studentregistrationid;
CREATE UNLOGGED TABLE CourseRegistrations_passed AS SELECT * FROM CourseRegistrations WHERE grade >4 ORDER BY studentregistrationid;
DROP TABLE CourseRegistrations;
ALTER TABLE courseregistrations_4 ADD PRIMARY KEY (studentregistrationid,courseofferid);
ALTER TABLE courseregistrations_null ADD PRIMARY KEY (studentregistrationid,courseofferid);
ALTER TABLE courseregistrations_failed ADD PRIMARY KEY (studentregistrationid,courseofferid);
ALTER TABLE courseregistrations_passed ADD PRIMARY KEY (studentregistrationid,courseofferid);
VACUUM;
ANALYZE;