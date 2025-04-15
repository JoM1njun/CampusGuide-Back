require('dotenv').config(); // .env 파일 불러오기

const express = require("express"); // express 모듈 불러오기
const cors = require("cors"); // CORS 모듈 불러오기
const mysql = require("mysql2"); // mysql 모듈 불러오기
const app = express(); // express 앱 생성
const path = require('path');
const port = process.env.port;

app.use(cors()); // CORS 설정
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// 라우트에서 API 키 전달
app.get("/config", (req, res) => {
  console.log("Received /config");
  const apikey = process.env.KAKAO_API_KEY;
  if (apikey) {
    res.json({ apikey: apikey });
    console.log("API : ", apikey);
  } else {
    res.status(500).json({error: 'API key not found'});
  }
});

// 정적 파일 제공 (예: HTML, JS, CSS)
app.use(express.static(path.join(__dirname, 'public')));

// DB 연결 코드
const db = mysql.createPool({
  host: process.env.DB_host,
  user: process.env.DB_user,
  password: process.env.DB_pw,
  database: process.env.DB_name, // DB 이름
  ssl: {
    rejectUnauthorized: true,
  },
});

// 검색 및 데이터 전달 API
app.get("/api/db-status", (req, res) => {
  const { query } = req.query;
  console.log("Recieved : ", query);

  let sql = `
        SELECT SQL_NO_CACHE *,
        IFNULL(p.etc, '정보 없음') AS etc
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
    if (isEnglish) {
      sql += `
            AND (
                p.name LIKE ? OR
                p.type LIKE ? OR
                LOWER(CONCAT(p.alias, r.num)) LIKE LOWER(?) OR
                p.alias LIKE ?
            )`;
      params.push(`${input}`, `${input}`, `${input}`, `${input}`);
    } else {
      sql += `
            AND (
                p.name LIKE ? OR
                p.type LIKE ? OR
                LOWER(CONCAT(p.alias, r.num)) LIKE LOWER(?) OR
                p.alias LIKE ?
            )`;
      params.push(`%${input}%`, `%${input}%`, `${input}`, `${input}`);
    }
  }

  console.log("Executing SQL : ", sql, params);

  try {
    db.query(sql, params, (err, result) => {
      if (err) {
        console.error("DB error : ", err);
        return res.status(500).json({ error: err });
      } else {
        if (result.length > 0) {
          const place = result;
          console.log(
            "Result : ",
            result.map((r) => r.name)
          );

          return res.json({
            places: result.map((place) => {
              return {
                name: place.name,
                alias: place.alias,
                latitude: place.lat,
                longitude: place.lng,
                etc: place.etc ? place.etc : "정보 없음",
                
              }
            }),
            rooms: result.map((room_number) =>{
              return {
                num: room_number.num,
                etc: room_number ? room_number : "정보 없음",
              }
            }),
          });
        } else {
          return res.status(404).json({ message: "Place Not Found" });
        }
      }
    });
  } catch (e) {
    console.error("Unhandled error:", e);
    res.status(500).json({ error: e.toString() });
  }
});

// 장소 정보 전달 API
app.get("/api/place-info", (req, res) => {
  const place = req.query.alias;
  console.log("Received alias : ", place);

  let sql = `
        SELECT SQL_NO_CACHE *,
        IFNULL(p.etc, '정보 없음') AS etc,
        IFNULL(p.\`floor-info\`, '정보 없음') AS floor_info,
        IFNULL(p.\`major-info\`, '정보 없음') AS major_info
        FROM place p
        WHERE 1=1
    `;
    const params = [];

    if (place) {
      sql += ` AND p.alias LIKE ?`;
      params.push(place);
    }

    try {
      db.query(sql, params, (err, result) => {
        if (err) {
          console.error("DB error : ", err);
          return res.status(500).json({ error: err });
        } else {
          if (result.length > 0) {
            return res.json({
              places: result.map((place) => {
                console.log("Etc : ", place.etc);
                console.log("DB에서 가져온 floor-info: ", place.floor_info);
                return {
                  name: place.name,
                  alias: place.alias,
                  latitude: place.lat,
                  longitude: place.lng,
                  etc: place.etc ? place.etc : "정보 없음",
                  floor: place.floor_info ? place.floor_info.replace(/\\n\s*\n/g, '\n') : "정보 없음",
                  major: place.major_info ? place.major_info.replace(/\\n\s*\n/g, '\n') : "정보 없음",
                };
              }),
            });
          } else {
            return res.status(404).json({ message: "Place Not Found" });
          }
        }
      });
    } catch (e) {
      console.error("Unhandled error:", e);
      res.status(500).json({ error: e.toString() });
    }
})

// 버스 시간표 불러내는 api
app.get("/api/bus-time", (req, res) => {
  const stopId = req.query.station; // 프론트에서 정류장 ID를 넘겨줌
  console.log("Stop : ", stopId);

  if (!stopId) {
      return res.status(400).json({ error: "정류장 ID가 필요합니다." });
  }

  let sql = `
      SELECT * FROM bus_time 
      WHERE station = ? AND direction = '배재대학교 종점' 
      ORDER BY departure_time;
  `;

  db.query(sql, [stopId], (err, results) => {
      if (err) {
          console.error("DB error:", err);
          return res.status(500).json({ error: err });
      }
      res.json({ timetable: results });
  });
});


// DB 연결 확인
app.get("/api/db-connect", (req, res) => {
  db.getConnection((err, connection) => {
    if (err) {
      console.log("Connect Failed", err);
      return res
        .status(500)
        .json({ status: "error", message: "Connect Failed" });
    }

    connection.ping((pingErr) => {
      if (pingErr) {
        console.log("Ping Failed", pingErr);
        res.status(500).json({ status: "error", message: "Ping Failed" });
      } else {
        console.log("DB Connected");
        res.json({ status: "success", message: "DB Connected" });
      }
      connection.release();
    });
  });
});

// 서버 실행
app.listen(port, () => {
  console.log(`서버가 https://campusguide-back.onrender.com:${port}에서 실행되고 있습니다.`);
});
