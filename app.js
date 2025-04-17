const fs = require('fs');
const data = require('./db'); // Render PostgreSQL 연결된 Pool

app.post("/import-db", async (req, res) => {
  try {
    const sql = fs.readFileSync('dump.sql', 'utf8');
    console.log("Running SQL:", sql);  // 실행할 SQL 쿼리 확인
    await data.query(sql);  // 쿼리 실행
    res.json({ status: "success", message: "Data imported" });
  } catch (err) {
    console.error("Import error:", err);  // 에러 로그 확인
    res.status(500).json({ status: "error", message: "Failed to import" });
  }
});

app.listen(process.env.DB_port, () => {
  console.log(`Server is running on port ${process.env.DB_port}`);
});
