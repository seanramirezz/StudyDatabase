CREATE TABLE Students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    major VARCHAR(50),
    year_level INT
);

CREATE TABLE TimeSlots (
    time_id SERIAL PRIMARY KEY,
    session_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0)
);

CREATE TABLE StudySessions (
    session_id SERIAL PRIMARY KEY,
    time_id INT NOT NULL,
    location VARCHAR(100),
    notes TEXT,
    FOREIGN KEY (time_id) REFERENCES TimeSlots(time_id)
);

CREATE TABLE Subjects (
    subject_id SERIAL PRIMARY KEY,
    subject_name VARCHAR(100) UNIQUE NOT NULL,
    subject_level VARCHAR(50),
    active BOOLEAN NOT NULL
);

CREATE TABLE SessionSubjects (
    session_id INT NOT NULL,
    subject_id INT NOT NULL,
    topic TEXT,
    PRIMARY KEY (session_id, subject_id),
    FOREIGN KEY (session_id) REFERENCES StudySessions(session_id),
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

CREATE TABLE SessionAttendance (
    session_id INT NOT NULL,
    student_id INT NOT NULL,
    status VARCHAR(20),
    checked_in_time TIME,
    PRIMARY KEY (session_id, student_id),
    FOREIGN KEY (session_id) REFERENCES StudySessions(session_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);