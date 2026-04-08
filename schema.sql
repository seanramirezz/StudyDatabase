-- Drop objects in reverse dependency order so the script can be rerun
DROP VIEW IF EXISTS SessionSummaryView;

DROP TRIGGER IF EXISTS trg_set_duration ON TimeSlots;
DROP FUNCTION IF EXISTS set_duration_minutes();

DROP TABLE IF EXISTS SessionAttendance;
DROP TABLE IF EXISTS SessionSubjects;
DROP TABLE IF EXISTS StudySessions;
DROP TABLE IF EXISTS Subjects;
DROP TABLE IF EXISTS TimeSlots;
DROP TABLE IF EXISTS Students;

-- =========================
-- STUDENTS
-- =========================
CREATE TABLE Students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    major VARCHAR(50),
    year_level INT CHECK (year_level BETWEEN 1 AND 6)
);

-- =========================
-- TIME SLOTS
-- =========================
CREATE TABLE TimeSlots (
    time_id SERIAL PRIMARY KEY,
    session_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
    CONSTRAINT chk_time_order CHECK (end_time > start_time)
);

-- =========================
-- STUDY SESSIONS
-- =========================
CREATE TABLE StudySessions (
    session_id SERIAL PRIMARY KEY,
    time_id INT NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL,
    notes TEXT,
    FOREIGN KEY (time_id) REFERENCES TimeSlots(time_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================
-- SUBJECTS
-- =========================
CREATE TABLE Subjects (
    subject_id SERIAL PRIMARY KEY,
    subject_name VARCHAR(100) UNIQUE NOT NULL,
    subject_level VARCHAR(50) NOT NULL
        CHECK (subject_level IN ('Beginner', 'Intermediate', 'Advanced')),
    active BOOLEAN NOT NULL DEFAULT TRUE
);

-- =========================
-- SESSION-SUBJECT LINK
-- Many-to-many between sessions and subjects
-- =========================
CREATE TABLE SessionSubjects (
    session_id INT NOT NULL,
    subject_id INT NOT NULL,
    topic TEXT,
    PRIMARY KEY (session_id, subject_id),
    FOREIGN KEY (session_id) REFERENCES StudySessions(session_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================
-- SESSION ATTENDANCE
-- Many-to-many between sessions and students
-- =========================
CREATE TABLE SessionAttendance (
    session_id INT NOT NULL,
    student_id INT NOT NULL,
    status VARCHAR(20) NOT NULL
        CHECK (status IN ('Present', 'Absent', 'Late')),
    checked_in_time TIME,
    PRIMARY KEY (session_id, student_id),
    FOREIGN KEY (session_id) REFERENCES StudySessions(session_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================
-- FUNCTION: automatically calculate duration_minutes
-- =========================
CREATE OR REPLACE FUNCTION set_duration_minutes()
RETURNS TRIGGER AS $$
BEGIN
    NEW.duration_minutes :=
        EXTRACT(EPOCH FROM (NEW.end_time - NEW.start_time)) / 60;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =========================
-- TRIGGER: set duration before insert/update
-- =========================
CREATE TRIGGER trg_set_duration
BEFORE INSERT OR UPDATE ON TimeSlots
FOR EACH ROW
EXECUTE FUNCTION set_duration_minutes();

-- =========================
-- VIEW: useful advanced feature for reporting
-- =========================
CREATE VIEW SessionSummaryView AS
SELECT
    ss.session_id,
    ts.session_date,
    ts.start_time,
    ts.end_time,
    ts.duration_minutes,
    ss.location,
    s.subject_name,
    s.subject_level,
    COUNT(sa.student_id) AS total_students
FROM StudySessions ss
JOIN TimeSlots ts
    ON ss.time_id = ts.time_id
LEFT JOIN SessionSubjects ssub
    ON ss.session_id = ssub.session_id
LEFT JOIN Subjects s
    ON ssub.subject_id = s.subject_id
LEFT JOIN SessionAttendance sa
    ON ss.session_id = sa.session_id
GROUP BY
    ss.session_id,
    ts.session_date,
    ts.start_time,
    ts.end_time,
    ts.duration_minutes,
    ss.location,
    s.subject_name,
    s.subject_level;