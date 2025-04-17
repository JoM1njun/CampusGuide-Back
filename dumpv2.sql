--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: direction; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.direction AS ENUM (
    '대전동신과학고',
    '배재대학교 종점'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bus_time; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bus_time (
    id integer NOT NULL,
    direction public.direction NOT NULL,
    departure_time time without time zone NOT NULL,
    station character varying(255) DEFAULT NULL::character varying
);


--
-- Name: bus_time_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bus_time_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bus_time_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bus_time_id_seq OWNED BY public.bus_time.id;


--
-- Name: category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category (
    c_id integer NOT NULL,
    type character varying(255) NOT NULL,
    etc text
);


--
-- Name: category_c_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.category_c_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_c_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.category_c_id_seq OWNED BY public.category.c_id;


--
-- Name: floor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.floor (
    f_id character varying(255) NOT NULL,
    floor character varying(255) NOT NULL,
    etc text,
    p_id character varying(255)
);


--
-- Name: place; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.place (
    alias character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) DEFAULT NULL::character varying,
    lat numeric(12,9) NOT NULL,
    lng numeric(12,9) NOT NULL,
    etc text,
    "floor-info" text,
    "major-info" text,
    category_id integer
);


--
-- Name: room_number; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.room_number (
    r_id integer NOT NULL,
    num character varying(255) NOT NULL,
    etc text,
    f_id character varying(255)
);


--
-- Name: room_number_r_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.room_number_r_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: room_number_r_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.room_number_r_id_seq OWNED BY public.room_number.r_id;


--
-- Name: bus_time id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bus_time ALTER COLUMN id SET DEFAULT nextval('public.bus_time_id_seq'::regclass);


--
-- Name: category c_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category ALTER COLUMN c_id SET DEFAULT nextval('public.category_c_id_seq'::regclass);


--
-- Name: room_number r_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_number ALTER COLUMN r_id SET DEFAULT nextval('public.room_number_r_id_seq'::regclass);


--
-- Data for Name: bus_time; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bus_time (id, direction, departure_time, station) FROM stdin;
1	대전동신과학고	05:40:00	BUS
2	대전동신과학고	06:00:00	BUS
3	대전동신과학고	06:20:00	BUS
4	대전동신과학고	06:37:00	BUS
5	대전동신과학고	06:54:00	BUS
6	대전동신과학고	07:11:00	BUS
7	대전동신과학고	07:28:00	BUS
8	대전동신과학고	07:45:00	BUS
9	대전동신과학고	08:02:00	BUS
10	대전동신과학고	08:20:00	BUS
11	대전동신과학고	08:38:00	BUS
12	대전동신과학고	08:56:00	BUS
13	대전동신과학고	09:14:00	BUS
14	대전동신과학고	09:35:00	BUS
15	대전동신과학고	09:56:00	BUS
16	대전동신과학고	10:17:00	BUS
17	대전동신과학고	10:38:00	BUS
18	대전동신과학고	11:00:00	BUS
19	대전동신과학고	11:22:00	BUS
20	대전동신과학고	11:42:00	BUS
21	대전동신과학고	12:02:00	BUS
22	대전동신과학고	12:22:00	BUS
23	대전동신과학고	12:40:00	BUS
24	대전동신과학고	12:59:00	BUS
25	대전동신과학고	13:18:00	BUS
26	대전동신과학고	13:37:00	BUS
27	대전동신과학고	13:56:00	BUS
28	대전동신과학고	14:19:00	BUS
29	대전동신과학고	14:40:00	BUS
30	대전동신과학고	15:02:00	BUS
31	대전동신과학고	15:24:00	BUS
32	대전동신과학고	15:46:00	BUS
33	대전동신과학고	16:11:00	BUS
34	대전동신과학고	16:36:00	BUS
35	대전동신과학고	16:58:00	BUS
36	대전동신과학고	17:20:00	BUS
37	대전동신과학고	17:46:00	BUS
38	대전동신과학고	18:10:00	BUS
39	대전동신과학고	18:32:00	BUS
40	대전동신과학고	18:54:00	BUS
41	대전동신과학고	19:16:00	BUS
42	대전동신과학고	19:38:00	BUS
43	대전동신과학고	20:00:00	BUS
44	대전동신과학고	20:22:00	BUS
45	대전동신과학고	20:44:00	BUS
46	대전동신과학고	21:06:00	BUS
47	대전동신과학고	21:28:00	BUS
48	대전동신과학고	21:50:00	BUS
49	대전동신과학고	22:12:00	BUS
50	대전동신과학고	22:35:00	BUS
51	배재대학교 종점	05:40:00	BUS
52	배재대학교 종점	06:05:00	BUS
53	배재대학교 종점	06:30:00	BUS
54	배재대학교 종점	06:56:00	BUS
55	배재대학교 종점	07:22:00	BUS
56	배재대학교 종점	07:48:00	BUS
57	배재대학교 종점	08:14:00	BUS
58	배재대학교 종점	08:40:00	BUS
59	배재대학교 종점	09:06:00	BUS
60	배재대학교 종점	09:32:00	BUS
61	배재대학교 종점	09:57:00	BUS
62	배재대학교 종점	10:22:00	BUS
63	배재대학교 종점	10:47:00	BUS
64	배재대학교 종점	11:12:00	BUS
65	배재대학교 종점	11:37:00	BUS
66	배재대학교 종점	12:05:00	BUS
67	배재대학교 종점	12:33:00	BUS
68	배재대학교 종점	13:01:00	BUS
69	배재대학교 종점	13:29:00	BUS
70	배재대학교 종점	13:57:00	BUS
71	배재대학교 종점	14:25:00	BUS
72	배재대학교 종점	14:52:00	BUS
73	배재대학교 종점	15:19:00	BUS
74	배재대학교 종점	15:46:00	BUS
75	배재대학교 종점	16:13:00	BUS
76	배재대학교 종점	16:40:00	BUS
77	배재대학교 종점	17:07:00	BUS
78	배재대학교 종점	17:34:00	BUS
79	배재대학교 종점	18:02:00	BUS
80	배재대학교 종점	18:30:00	BUS
81	배재대학교 종점	18:58:00	BUS
82	배재대학교 종점	19:25:00	BUS
83	배재대학교 종점	19:52:00	BUS
84	배재대학교 종점	20:19:00	BUS
85	배재대학교 종점	20:46:00	BUS
86	배재대학교 종점	21:12:00	BUS
87	배재대학교 종점	21:38:00	BUS
88	배재대학교 종점	22:04:00	BUS
89	배재대학교 종점	22:30:00	BUS
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.category (c_id, type, etc) FROM stdin;
1	편의점	\N
2	ATM	\N
3	프린터	\N
\.


--
-- Data for Name: floor; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.floor (f_id, floor, etc, p_id) FROM stdin;
C02	2	\\N	C
C03	3	\\N	C
C04	4	\\N	C
C05	5	\\N	C
SP01	1	\\N	SP
SP02	2	\\N	SP
SP03	3	\\N	SP
SP04	4	\\N	SP
SP05	5	\\N	SP
SPB1	B1	\\N	SP
\.


--
-- Data for Name: place; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.place (alias, name, type, lat, lng, etc, "floor-info", "major-info", category_id) FROM stdin;
A_ATM	KB 국민은행 & 우체국	ATM	36.318773000	127.366732000	A관 정문 (ATM)			2
D_ATM	KB 국민은행	ATM	36.320719000	127.364471000	기숙사 CU 정문 (ATM)			2
P_ATM	KB 국민은행(지점)	ATM	36.322001000	127.367589000	21세기관(P) 1F (ATM & 지점)			2
D_편의점	CU	편의점	36.320459000	127.364314000	PA, PB 기숙사 중앙 B1			1
P_편의점	emart24	편의점	36.322055000	127.367374000	21세기관(P) 1F			1
SP_편의점	emart24	편의점	36.319298000	127.367022000	스마트 배재관(SP) B1			1
A_프린터	프린터(큐브)	프린터	36.318736000	127.366813000	A관 정문 앞			3
D_프린터	프린터(큐브)	프린터	36.320719000	127.364471000	기숙사 ATM 바로 옆			3
L_프린터	프린터(큐브)	프린터	36.319742000	127.365174000	도서관 3층			3
P_프린터	프린터(큐브)	프린터	36.322035000	127.367503000	P관 1층 emart24 옆			3
A	아펜젤러관	강의실	36.318770000	127.366420000		[1F] 배재인공지능체험관, MAKER SPACE, IT교육1/2/3/4실\\n[2F] 배양영재실\\n[4F] 한국어교육원 강의실, 기관생명윤리위원회, 한국-시베리아센터\\n[5F] 한국어교육원		\N
AM	아펜젤러기념관	강의실	36.322603000	127.365162000	채플 및 주말 예배	[1F] 교목실, 대학교회(채플실), 기독교사회복지학과 사무실	기독교사회복지학과	\N
B	백산관	강의실	36.321151000	127.366144000	동아리방& 우체국 & 식당	[2F] 신기술혁신공유대학사업단\\n[4F] 국제처, 우체국, 서점, 문구점, 안경점, 꽃과선물, 시민버거, 배재대학교 총동창회 사무실\\n[5F] 동아리 사무실		\N
C	정보과학관	강의실	36.317603000	127.367763000		[1F] 전기전자공학과 사무실, 소프트웨어공학부 사무실	전기전자공학과\\n\n소프트웨어공학부 컴퓨터공학전공\\n\n소프트웨어공학부 소프트웨어학전공\\n\n소프트웨어공학부 정보보안학전공\\n\n소프트웨어공학부 게임공학전공	\N
G	국제교류관	강의실	36.321787000	127.366036000		[1F] 입학처, 아트컨벤션홀\\n\n[2F] 광고사진영상학과 사무실, 배재미디어센터, 소극장\\n\n[3F] 레저스포츠학부 사무실, 보건의료복지학과 사무실, 미디어콘텐츠학과 사무실\\n\n[4F] 일반대학원, 관광축제한류대학원, 교육대학원\\n\n[5F] 스마트ICT융합인재양성센터, 평생교육원	레저스포츠학부\\n\n광고사진영상학과\\n\n보건의료복지학과\\n\n미디어콘텐츠학과	\N
H	하워드관	강의실	36.317612000	127.367244000				\N
HM	하워드기념관	강의실	36.319822000	127.367890000		[1F] 어린이집\\n\n[3F] 유아교육과\\n\n[4F] 보육교사교육원	유아교육과	\N
J	자연과학관	강의실	36.318175000	127.366354000		[1F] 장애학생지원실, 식품영양학과 사무실, 스마트ICT융합인재양성센터 세미나실\\n\n[2F] 조경학과 사무실, 스마트ICT융합인재양성센터 연구실\\n\n[3F] 원예산림학과 사무실, 외식조리학과 사무실\\n\n[4F] 생명공학과 사무실	생명공학과\\n\n식품영양학과\\n\n원예산림학과\\n\n외식조리학과\\n\n조경학과	\N
MC	하워드관	강의실	36.317463000	127.367044000		[2F] 국방정책대학원, 드론로봇공학과 사무실\\n\n[3F] 스마트배터리학과 사무실\\n\n[4F] 철도건설공학과 사무실\\n\n[6F] 간호학과 사무실	드론로봇공학과\\n\n국방정책대학원\\n\n스마트배터리학과\\n\n철도건설공학과\\n\n간호학과	\N
P	21세기관 대학본부	강의실	36.321791000	127.367221000		[B1] 스포렉스홀\\n\n[1F] 콘서트홀, 시설안전처, P-lounge, 고트빈, 이마트24, 국민은행\\n\n[2F] 총장실, 소통협력본부, 교무처, 기획처, 학생성장센터(사회봉사지원실, 학생성장지원팀), 학생복지팀, 사무처, 국책사업총괄관리단, 대학혁신지원사업단\\n\n[3F] 호텔항공경영학과 사무실, 경찰법학과 사무실, 의류패션학과 사무실, 관광경영학과 사무실\\n\n[4F] 일본학과 사무실, 영어과 사무실, 중국통상학과 사무실, 스페인어중남미학과 사무실, 대학발전기금본부\\n\n[5F] 행정학과 사무실, 경영학과 사무실, 글로벌비즈니스학과 사무실, IT경영정보학과 사무실	일본학과\\n\n경찰법학과\\n\n행정학과\\n\n의류패션학과\\n\n경영학과\\n\nIT경영정보학과\\n\n관광경영학과\\n\n호텔항공경영학과\\n\n글로벌비즈니스학과	\N
S	소월관	강의실	36.317986000	127.368219000		[5F] 항공서비스학과	항공서비스학과	\N
SP	스마트배재관	강의실	36.319253000	127.367020000		[1F] 학생처 학생성장센터 학생상담실, 대학평생교육지원사업단\\n\n[2F] 취창업지원처, 건강증진실(보건실), 대학평생교육지원사업단\\n\n[3F] 뷰티케어학과 사무실, 대학교육혁신원\\n\n[4F] 주시경교양대학, 아펜젤러공유대학, 채움 비교과 Lounge\\n\n[5F] AISW중심대학사업단, IPP사업단	뷰티케어학과	\N
W	우남관	강의실	36.319507000	127.366000000		[B1] 산학협력단\\n\n[1F] 교직부, 다문화가족지원센터, 대전광역새일센터\\n\n[2F] 국어국문한국어교육과 사무실, 심리상담학과 사무실	국어국문한국어교육과\\n\n심리상담학과	\N
Y	예술관	강의실	36.323262000	127.366273000		[4F] 건축학과 사무실, 실내건축학과 사무실, 공연예술학과 사무실, 아트앤웹툰학부 사무실, 디자인학부 사무실	건축학과\\n\n실내건축학과\\n\n공연예술학과\\n\n아트앤웹툰학부\\n\n디자인학부	\N
K	김옥균관	ROTC	36.318357000	127.368066000	\N		\N	\N
L	중앙도서관	도서관	36.319742000	127.365180000	\N	[1F] 참고열람실, 마이크로자료실, 북카페, 정보관리팀\\n\n[2F] 대출실\\n\n[3F] 정기간행물실, 특수자료실, 전자정보실, 자료보존실, 인터넷플라자, 프린트존\\n\n[4F] 박물관, 학술정보지원팀, 보존서고, 미니스터디룸, 이용자교육장\\n\n[5F] 열람실, 매점, 옥외휴게실	\N	\N
BUS	버스정류장	정류장	36.323124000	127.367216000	\N		\N	\N
\.


--
-- Data for Name: room_number; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.room_number (r_id, num, etc, f_id) FROM stdin;
56	401	AC채움 비교과 Lounge	SP04
57	401-1	Achievement+	SP04
58	401-2	Achievement	SP04
59	401-3	Creativity	SP04
60	401-4	Development	SP04
61	401-5	Growth	SP04
62	402	나섬인성교육센터	SP04
63	403	융복합교육센터	SP04
64	404	주시경교육대학\\n-교학과\\n-기초교육부\\n-교양교육부\\n-글로벌교육부\\n-융복합교육부	SP04
65	405-1	나눔학습지도실	SP04
66	405-2	섬김학습지도실	SP04
67	405-3	상상학습지도실	SP04
68	405-4	창의학습지도실	SP04
69	406	주시경교양대학장실, 회의실	SP04
70	407	주시경연구소	SP04
71	501	학생창의공간, 인터넷카페	SP05
72	501-1	SW실습실	SP05
73	501-2	AI.SW실습실	SP05
74	501-3	AI.SW단장실, 회의실	SP05
75	501-4	AI.SW중심대학사업단	SP05
76	501-5	AI.SW창의융합실습실	SP05
77	502	IPP사업단, IPP운영지원실, IPP전담교수실	SP05
78	503	IPP상담실	SP05
79	504	IPP사업단장실	SP05
80	505	IPP회의실	SP05
1	U101	계단식 강의실	SPB1
2	U102	편의점	SPB1
3	U103	헬스장	SPB1
4	U104	강의실	SPB1
5	101	학생상담실	SP01
6	101-1	학생상담실(사무실)	SP01
7	102	장애학생지원실	SP01
8	103	학생성장센터, 사회봉사지원실	SP01
9	201	대학일자리플러스본부	SP02
10	201-1	개별상담실	SP02
11	201-2	집단상담실	SP02
12	201-3	분석실	SP02
13	201-4	본부장실	SP02
14	201-5	자료보관실	SP02
15	202	건강증진실(보건실)	SP02
16	203	학생처장실	SP02
17	204	학생복지팀	SP02
18	301	수업전략컨설팅룸	SP03
19	301-1	수업전략컨설팅룸	SP03
20	302	대학교육혁신원 학습상담실	SP03
21	303	대학교육혁신원 학습상담실	SP03
22	304	학습지원실, 매체제작실	SP03
23	305	대학교육혁신원	SP03
24	306	대학교육혁신원장실	SP03
25	308	플렉서블 강의실	SP03
26	309	대학교육혁신원 학습상담실	SP03
27	310	세미나실	SP03
28	311	스튜디오	SP03
29	312	청년고용정책홍보실(취업동아리)	SP03
30	312-1	미국 K-Move스쿨 전용강의실	SP03
\.


--
-- Name: bus_time_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bus_time_id_seq', 1, false);


--
-- Name: category_c_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.category_c_id_seq', 3, true);


--
-- Name: room_number_r_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.room_number_r_id_seq', 80, true);


--
-- Name: bus_time bus_time_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bus_time
    ADD CONSTRAINT bus_time_pkey PRIMARY KEY (id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (c_id);


--
-- Name: floor floor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.floor
    ADD CONSTRAINT floor_pkey PRIMARY KEY (f_id);


--
-- Name: place place_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.place
    ADD CONSTRAINT place_pkey PRIMARY KEY (alias);


--
-- Name: room_number room_number_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_number
    ADD CONSTRAINT room_number_pkey PRIMARY KEY (r_id);


--
-- Name: bus_time bus_time_station_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bus_time
    ADD CONSTRAINT bus_time_station_fkey FOREIGN KEY (station) REFERENCES public.place(alias);


--
-- Name: floor floor_p_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.floor
    ADD CONSTRAINT floor_p_id_fkey FOREIGN KEY (p_id) REFERENCES public.place(alias);


--
-- Name: place place_category-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.place
    ADD CONSTRAINT "place_category-id_fkey" FOREIGN KEY (category_id) REFERENCES public.category(c_id);


--
-- Name: room_number room_number_f_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_number
    ADD CONSTRAINT room_number_f_id_fkey FOREIGN KEY (f_id) REFERENCES public.floor(f_id);


--
-- PostgreSQL database dump complete
--

