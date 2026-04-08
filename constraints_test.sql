-- Duplicate email should fail
INSERT INTO Students (first_name, last_name, email, major, year_level)
VALUES ('Test', 'User', 'sean@fiu.edu', 'CS', 1);

-- Invalid year_level should fail
INSERT INTO Students (first_name, last_name, email, major, year_level)
VALUES ('Bad', 'Year', 'badyear@fiu.edu', 'Math', 10);

-- Invalid attendance status should fail
INSERT INTO SessionAttendance (session_id, student_id, status, checked_in_time)
VALUES (1, 1, 'Unknown', '14:00');

-- Invalid foreign key should fail
INSERT INTO StudySessions (time_id, location, notes)
VALUES (999, 'Nowhere', 'Invalid test');