INSERT INTO Students (first_name, last_name, email, major, year_level)
VALUES
('Sean', 'Ramirez', 'sean@fiu.edu', 'Computer Science', 2),
('Maria', 'Lopez', 'maria@fiu.edu', 'Biology', 1),
('Daniel', 'Perez', 'daniel@fiu.edu', 'Mathematics', 3),
('Sofia', 'Gomez', 'sofia@fiu.edu', 'Computer Science', 2);

INSERT INTO TimeSlots (session_date, start_time, end_time, duration_minutes)
VALUES
('2026-03-08', '14:00', '15:00', 60),
('2026-03-09', '10:00', '11:30', 90),
('2026-03-10', '16:00', '17:15', 75);

INSERT INTO StudySessions (time_id, location, notes)
VALUES
(1, 'Library Room 2', 'Database review'),
(2, 'GC 243', 'Exam prep'),
(3, 'Online - Zoom', 'Homework help');

INSERT INTO Subjects (subject_name, subject_level, active)
VALUES
('Database Systems', 'Intermediate', TRUE),
('Calculus II', 'Beginner', TRUE),
('Programming I', 'Advanced', TRUE);

INSERT INTO SessionSubjects (session_id, subject_id, topic)
VALUES
(1, 1, 'Normalization and ERDs'),
(2, 2, 'Integration by parts'),
(3, 3, 'Loops and functions');

INSERT INTO SessionAttendance (session_id, student_id, status, checked_in_time)
VALUES
(1, 1, 'Present', '13:55'),
(1, 2, 'Present', '13:58'),
(2, 1, 'Late', '10:05'),
(2, 3, 'Present', '09:57'),
(3, 4, 'Present', '15:58');