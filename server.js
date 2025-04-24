require('dotenv').config(); // .env 파일 불러오기

const express = require("express"); // express 모듈 불러오기
const cors = require("cors"); // CORS 모듈 불러오기
const { Pool } = require('pg');
const app = express(); // express 앱 생성
const path = require('path');
const normalizeText = require('./utils/normalizeText');
const server_port = process.env.PORT || 3000;

app.use(cors()); // CORS 설정
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// 서버 실행 및 상태 출력(uptimeRobot)
app.get("/ping", (req, res) => {
  res.status(200).send("Server Living");
});

// 정적 파일 제공 (예: HTML, JS, CSS)
app.use(express.static(path.join(__dirname, 'public')));

// DB 연결 코드
const db = new Pool({
  host: process.env.DB_host,
  user: process.env.DB_user,
  port: process.env.DB_port,
  password: process.env.DB_pw,
  database: process.env.DB_name, // DB 이름
  ssl: {
    rejectUnauthorized: false,  // SSL 인증서 문제를 해결하기 위한 설정
  },
});
module.exports = db;

console.log("Host : ", process.env.DB_host);

// 검색 및 데이터 전달 API
app.get("/api/db-status", async (req, res) => {
  const { query } = req.query;
  console.log("Recieved : ", query);

  let sql = `
        SELECT p.*, f.*,
        COALESCE(p.etc, '정보 없음') AS etc
        FROM place p
        LEFT JOIN floor f ON p.alias = f.p_id 
        LEFT JOIN room_number r ON f.f_id = r.f_id 
        LEFT JOIN category c ON p.category_id = c.c_id 
        WHERE 1=1`;
  const params = [];

  function escapeRegExp(query) {
    // 정규식 특수 문자들을 '\\'로 이스케이프 처리
    return query.replace(/[.*+?^=!:${}()|\[\]\/\\]/g, "\\$&");
  }

  let input = escapeRegExp(query);

  // p.name의 %?%로 인해 겹치는 이름이 표시됨 다시 손 볼것
  if (input) {
    const isEnglish = /^[a-zA-Z]+$/.test(input);

    sql += `
            AND (
                p.name LIKE $1 OR
                p.type LIKE $2 OR
                LOWER(CONCAT(p.alias, r.num)) LIKE LOWER($3) OR
                p.alias LIKE $4
            )`;

    if (isEnglish) {
      params.push(`${input}`, `${input}`, `${input}`, `${input}`);
    } else {
      params.push(`%${input}%`, `%${input}%`, `${input}`, `${input}`);
    }
  }

  console.log("Executing SQL : ", sql, params);

  try {
    const result = await db.query(sql, params);
    return res.json({
      places: result.rows.map((place) => ({
        name: place.name,
        alias: place.alias,
        latitude: place.lat,
        longitude: place.lng,
        etc: place.etc ? place.etc : "정보 없음",
        floor: place.floor,
      })),
      rooms: result.rows.map((room_number) => ({
        num: room_number.num,
        etc: room_number ? room_number : "정보 없음",
      })),
    });
  } catch (e) {
    console.error("Unhandled error:", e);
    res.status(500).json({ error: e.toString() });
  }
});


// 장소 정보 전달 API
app.get("/api/place-info", async (req, res) => {
  const place = req.query.alias;
  console.log("Received alias : ", place);

  let sql = `
        SELECT *,
        COALESCE(p.etc, '정보 없음') AS etc,
        COALESCE(p."floor-info", '정보 없음') AS floor_info,
        COALESCE(p."major-info", '정보 없음') AS major_info
        FROM place p
        WHERE 1=1
    `;
  const params = [];

  if (place) {
    sql += ` AND p.alias LIKE $1`;
    params.push(place);
  }

  try {
    const result = await db.query(sql, params);
      if (result.rows.length > 0) {
        return res.json({
          places: result.rows.map((place) => {
            console.log("Etc : ", place.etc);
            console.log("DB에서 가져온 floor-info: ", place.floor_info);
            return {
              name: place.name,
              alias: place.alias,
              latitude: place.lat,
              longitude: place.lng,
              etc: place.etc ? place.etc : "정보 없음",
              floor: normalizeText(place.floor_info),
              major: normalizeText(place.major_info),
            };
          }),
        });
      } else {
        return res.status(404).json({ message: "Place Not Found" });
      }
    } catch (e) {
    console.error("Unhandled error:", e);
    return res.status(500).json({ error: e.toString() });
  }
});


// 버스 시간표 불러내는 api
app.get("/api/bus-time", async (req, res) => {
  const stopId = req.query.station; // 프론트에서 정류장 ID를 넘겨줌
  console.log("Stop : ", stopId);

  if (!stopId) {
      return res.status(400).json({ error: "정류장 ID가 필요합니다." });
  }

  let sql = `
      SELECT * FROM bus_time 
      WHERE station = $1 AND direction = '배재대학교 종점' 
      ORDER BY departure_time;
  `;

  try {
    const result = await db.query(sql, [stopId]);
    res.json({ timetable: result.rows });
  } catch (err) {
    console.error("DB error:", err);
    res.status(500).json({ error: err.message });
  }
});


// DB 연결 확인
app.get("/api/db-connect", async (req, res) => {
  try {
    // 간단한 쿼리로 연결 확인 (예: 현재 시간 가져오기)
    const result = await db.query("SELECT NOW()");
    console.log("DB Connected");
    res.json({
      status: "success",
      message: "DB Connected",
      time: result.rows[0].now,
    });
  } catch (err) {
    console.error("Connect Failed", err);
    res.status(500).json({ status: "error", message: "Connect Failed" });
  }
});

// console.log("Received POST /import-db");
// app.post("/import-db", async (req, res) => {
//   try {
//     const sql = fs.readFileSync('./dumpv2.sql', 'utf8');
//     console.log("Running SQL:", sql);  // 실행할 SQL 쿼리 확인
    
//     await data.query(sql);  // 쿼리 실행
//     res.json({ status: "success", message: "Data imported" });
//   } catch (err) {
//     console.error("Import error:", err.message);  // 에러 로그 확인
//     res.status(500).json({ status: "error", message: "Failed to import" });
//   }
// });

// 서버 실행
app.listen(server_port, () => {
  console.log(`서버가 https://campusguide-back.onrender.com:${server_port}에서 실행되고 있습니다.`);
});
