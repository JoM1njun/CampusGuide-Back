const fs = require('fs');
const data = require('./db'); // Render PostgreSQL 연결된 Pool

app.post("/import-db", async (req, res) => {
  try {
    const sql = fs.readFileSync('C:/Users/brian/dumpv2.sql', 'utf8');
    await data.query(sql);
    res.json({ status: "success", message: "Data imported" });
  } catch (err) {
    console.error("Import error:", err);
    res.status(500).json({ status: "error", message: "Failed to import" });
  }
});

app.listen(process.env.DB_port, () => {
  console.log("Server is running on port ${process.env.DB_port}");
});
