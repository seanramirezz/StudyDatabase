-- 1. View all students
SELECT * FROM Students;

-- 2. View all sessions with date/time/location
SELECT ss.session_id, ts.session_date, ts.start_time, ts.end_time, ss.location
FROM StudySessions ss
JOIN TimeSlots ts ON ss.time_id = ts.time_id;

-- 3. Students attending sessions
SELECT st.first_name, st.last_name, sa.session_id, sa.status
FROM SessionAttendance sa
JOIN Students st ON sa.student_id = st.student_id;

-- 4. Subjects for each session
SELECT ss.session_id, s.subject_name, ss.topic
FROM SessionSubjects ss
JOIN Subjects s ON ss.subject_id = s.subject_id;

-- 5. Count students per session
SELECT session_id, COUNT(student_id) AS total_students
FROM SessionAttendance
GROUP BY session_id;

-- 6. Show only active subjects
SELECT * FROM Subjects
WHERE active = TRUE;

-- 7. Update student major
UPDATE Students
SET major = 'Software Engineering'
WHERE student_id = 1;

-- 8. Delete an attendance record
DELETE FROM SessionAttendance
WHERE student_id = 1 AND session_id = 2;

-- 9. Sessions grouped by subject
SELECT s.subject_name, COUNT(ss.session_id) AS total_sessions
FROM SessionSubjects ss
JOIN Subjects s ON ss.subject_id = s.subject_id
GROUP BY s.subject_name;

-- 10. Use your VIEW (advanced feature)
SELECT * FROM SessionSummaryView;


