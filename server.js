const express = require("express");
const cors = require("cors");
const { Pool } = require("pg");

const app = express();
const PORT = 3001;

app.use(cors());
app.use(express.json());

const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "StudDB",
  password: "Realmiami26",
  port: 5432,
});

app.get("/", (req, res) => {
  res.send("Study Database backend is running.");
});

app.get("/students", async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM Students ORDER BY student_id ASC"
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Error fetching students:", err.message);
    res.status(500).json({ error: "Failed to fetch students" });
  }
});

app.post("/students", async (req, res) => {
  const { first_name, last_name, email, major, year_level } = req.body;

  try {
    const result = await pool.query(
      `INSERT INTO Students (first_name, last_name, email, major, year_level)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
      [first_name, last_name, email, major, year_level]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error("Error adding student:", err.message);
    res.status(500).json({ error: "Failed to add student" });
  }
});

app.get("/sessions", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        ss.session_id,
        ts.session_date,
        ts.start_time,
        ts.end_time,
        ts.duration_minutes,
        ss.location,
        ss.notes
      FROM StudySessions ss
      JOIN TimeSlots ts ON ss.time_id = ts.time_id
      ORDER BY ss.session_id ASC
    `);

    res.json(result.rows);
  } catch (err) {
    console.error("Error fetching sessions:", err.message);
    res.status(500).json({ error: "Failed to fetch sessions" });
  }
});

app.post("/sessions", async (req, res) => {
  const { session_date, start_time, end_time, location, notes } = req.body;
  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    const timeResult = await client.query(
      `INSERT INTO TimeSlots (session_date, start_time, end_time, duration_minutes)
       VALUES ($1, $2, $3, 1)
       RETURNING time_id`,
      [session_date, start_time, end_time]
    );

    const time_id = timeResult.rows[0].time_id;

    const sessionResult = await client.query(
      `INSERT INTO StudySessions (time_id, location, notes)
       VALUES ($1, $2, $3)
       RETURNING *`,
      [time_id, location, notes]
    );

    await client.query("COMMIT");
    res.status(201).json(sessionResult.rows[0]);
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("Error creating session:", err.message);
    res.status(500).json({ error: "Failed to create session" });
  } finally {
    client.release();
  }
});

app.get("/summary", async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM SessionSummaryView ORDER BY session_id ASC"
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Error fetching summary:", err.message);
    res.status(500).json({ error: "Failed to fetch summary" });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});