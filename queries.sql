SELECT * FROM Students;

SELECT * FROM TimeSlots;

SELECT * FROM StudySessions;

SELECT * FROM Subjects;

SELECT * FROM SessionAttendance;

SELECT * FROM SessionSubjects;
SELECT st.first_name, st.last_name, sa.session_id, sa.status
FROM SessionAttendance sa
JOIN Students st ON sa.student_id = st.student_id;  