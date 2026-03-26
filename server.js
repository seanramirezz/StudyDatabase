const { Client } = require("pg");

const client = new Client({
    user: "postgres",
    host: "localhost",
    database: "StudDB",
    password: "Realmiami26",
    port: 5432,
});

client.connect()
    .then(async () => {
        console.log("Connected to PostgreSQL");

        const result = await client.query("SELECT * FROM students;");
        console.log(result.rows);

        await client.end();
    })
    .catch(err => {
        console.error("Connection error:", err.message);
    });