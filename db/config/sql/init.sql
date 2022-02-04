set names utf8;

create table categories
(
    id   int auto_increment
        primary key,
    name varchar(50) not null
);

create table products
(
    id          int auto_increment
        primary key,
    category_id int default 1                not null,
    name        varchar(100)                  not null,
    hit         int default 0                not null,
    info        longtext collate utf8mb4_bin not null,
    bacode      varchar(50)                  null,
    constraint products_category_id_fk
        foreign key (category_id) references categories (id)
);

create table tiers
(
    id    int auto_increment
        primary key,
    name  varchar(50)   not null,
    value int default 0 not null
);

create table users
(
    id       int auto_increment
        primary key,
    username varchar(50)   not null,
    pw       varchar(50)   not null,
    point    int default 0 not null,
    tier_id  int default 1 not null,
    constraint users_tier_id_fk
        foreign key (tier_id) references tiers (id)
);

create table favorites
(
    id         int auto_increment
        primary key,
    user_id    int not null,
    product_id int not null,
    constraint favorites_product_id_fk
        foreign key (product_id) references products (id),
    constraint favorites_user_id_fk
        foreign key (user_id) references users (id)
);

insert into greenDB.users (id, username, pw, point, tier_id)
values  (1, 'test1', 'test1', 0, 1),
        (2, 'test2', 'test1', 50, 2),
        (3, 'test3', 'test3', 100, 3),
        (4, 'test4', 'test4', 150, 4),
        (5, 'test5', 'test5', 200, 5),
        (6, 'test6', 'test6', 250, 6);

insert into greenDB.favorites (id, user_id, product_id)
values  (1, 1, 1),
        (2, 1, 2),
        (3, 2, 1),
        (4, 2, 2),
        (5, 2, 3);

insert into greenDB.products (id, category_id, name, hit, info, bacode)
values  (1, 5, '하이트진로', 0, '{
    "company": "하이트진로",
    "image": "https://images.velog.io/images/wisepine/post/e72f1bf4-6a28-4889-9ecd-e91df121e331/image.png",
    "mark": [
      {
        "name": "string",
        "cert_id": 100000,
        "cert_state": true,
        "cert_start_timestamp": "2018-02-04",
        "cert_end_timestamp": "2022-04-09"
      }
    ]
 }', '8801001235123'),
        (2, 5, '보령 메디앙스 B&B 사각 면봉 200P', 0, '{
    "company": "보령 메디앙스",
    "image": "https://images.velog.io/images/wisepine/post/5df99d42-e6a1-4540-8659-87d2de71d7ba/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100001,
        "cert_state": true,
        "cert_start_timestamp": "2018-01-04",
        "cert_end_timestamp": "2022-04-10"
      }
    ]
 }', '8801092512615'),
        (3, 5, '맥심 T.O.P 에스프레소 마스터 라떼 275ml', 0, '{
    "company": "동서식품",
    "image": "https://images.velog.io/images/wisepine/post/1bde8063-b9fc-46a2-9ee7-9088c240ac5f/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100002,
        "cert_state": true,
        "cert_start_timestamp": "2019-08-02",
        "cert_end_timestamp": "2022-06-10"
      }
    ]
 }', '8801037087543'),
        (4, 3, '(주)일동엘앤비 새싹이100매 390G x 1EA', 0, '{
    "company": "(주)일동엘앤비",
    "image": "https://images.velog.io/images/wisepine/post/63d4440e-e168-4c15-b82e-0e62e26fdcf9/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100003,
        "cert_state": true,
        "cert_start_timestamp": "2020-04-20",
        "cert_end_timestamp": "2022-10-29"
      }
    ]
 }', '8809180747659'),
        (5, 3, '(주)크리오 휴대용 센스R+M치약 x 1EA', 0, '{
    "company": "(주)크리오",
    "image": "https://images.velog.io/images/wisepine/post/752de4b3-8b5d-4c3c-bba4-e147a4a0b9d5/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100004,
        "cert_state": true,
        "cert_start_timestamp": "2021-04-12",
        "cert_end_timestamp": "2022-10-06"
      }
    ]
 }', '8801441006253'),
        (6, 3, '후레쉬 장갑 50매', 0, '{
    "company": "한국쓰리엠(주)",
    "image": "https://images.velog.io/images/wisepine/post/752b4105-1372-43c1-a026-5de1259f603c/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100005,
        "cert_state": true,
        "cert_start_timestamp": "2019-12-23",
        "cert_end_timestamp": "2023-01-01"
      }
    ]
 }', '8801230131098'),
        (7, 3, '깨끗한나라 보솜이 13무안심 캡60매
', 0, '{
    "company": "깨끗한나라",
    "image": "https://images.velog.io/images/wisepine/post/f82bf6fe-4f9c-4cce-ab70-9e5a36932d8c/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100006,
        "cert_state": true,
        "cert_start_timestamp": "2021-08-09",
        "cert_end_timestamp": "2023-07-02"
      }
    ]
 }', '8801260607839'),
        (8, 1, '거짓말 탐지기', 0, '{
    "company": "아트박스",
    "image": "https://images.velog.io/images/wisepine/post/791c9610-7ae1-4588-b8ef-bc56abcaab35/image.png)",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100007,
        "cert_state": true,
        "cert_start_timestamp": "2021-08-09",
        "cert_end_timestamp": "2023-07-02"
      }
    ]
 }', '8809600769605'),
        (9, 5, '해태 후렌치파이 딸기 192g', 0, '{
    "company": "해태제과",
    "image": "https://images.velog.io/images/wisepine/post/07e6eff8-df62-4c41-b6f1-2eb7a3d8fa20/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100008,
        "cert_state": true,
        "cert_start_timestamp": "2020-11-21",
        "cert_end_timestamp": "2023-02-24"
      }
    ]
 }', '8801019307133'),
        (10, 5, '청우식품 브루느와 브라우니 쿠키 165G', 0, '{
    "company": "청우식품",
    "image": "https://images.velog.io/images/wisepine/post/aa011e0a-5190-4004-91e9-45aa4a72004f/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100009,
        "cert_state": true,
        "cert_start_timestamp": "2020-11-21",
        "cert_end_timestamp": "2023-07-29"
      }
    ]
 }', '8801204204452'),
        (14, 1, '0', 0, '{"company":"string","image": "", "mark":[{"name":"string","cert_id":0,"cert_state":true,"cert_start_timestamp":"string","cert_end_timestamp":"string"}]}', 'string'),
        (16, 1, '0', 0, '{"company":"string","image": "", "mark":[{"name":"string","cert_id":0,"cert_state":true,"cert_start_timestamp":"string","cert_end_timestamp":"string"}]}', 'string'),
        (17, 5, '롯데제크오리지날100G', 0, '{
    "company": "롯데제과",
    "image": "https://images.velog.io/images/wisepine/post/a4320df9-89ab-4dea-8787-040e25060199/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100010,
        "cert_state": true,
        "cert_start_timestamp": "2020-04-19",
        "cert_end_timestamp": "2023-11-23"
      }
    ]
 }', '8801062521906'),
        (18, 5, '삼양식품(주) 수타면 120g', 0, '{
    "company": "삼양식품(주)",
    "image": "https://images.velog.io/images/wisepine/post/fc9be883-443c-494d-9c9d-a89bb0389271/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100011,
        "cert_state": true,
        "cert_start_timestamp": "2018-09-26",
        "cert_end_timestamp": "2022-02-28"
      }
    ]
 }', '8801073104136'),
        (19, 5, '크라운 스낵 크라운_빅카라멜콘_72g 72G x 1EA', 0, '{
    "company": "크라운",
	"image": "https://images.velog.io/images/wisepine/post/720fcfa6-f16c-4b5d-90a4-f47c946e67c6/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100012,
        "cert_state": true,
        "cert_start_timestamp": "2018-09-26",
        "cert_end_timestamp": "2022-02-28"
      }
    ]
 }', '8801111186834'),
        (20, 5, '오리온_오감자_50g', 0, '{
    "company": "(주)오리온",
	"image": "https://images.velog.io/images/wisepine/post/368874f9-1c77-4952-a4b7-dc2746db7b76/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100013,
        "cert_state": true,
        "cert_start_timestamp": "2020-01-17",
        "cert_end_timestamp": "2022-04-01"
      }
    ]
 }', '8801117752804'),
        (21, 5, '크라운제과 스낵 카라멜콘메이플 74G', 0, '{
    "company": "크라운제과",
	"image": "https://images.velog.io/images/wisepine/post/de486550-922b-4140-870f-cbddcb308826/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100014,
        "cert_state": true,
        "cert_start_timestamp": "2021-09-01",
        "cert_end_timestamp": "2022-06-02"
      }
    ]
 }', '8801111904292'),
        (22, 3, '엘지생활건강 페리오 키즈치약 버블75x2 75G x 2EA', 0, '{
    "company": "엘지생활건강",
    "image": "https://images.velog.io/images/wisepine/post/213f65f2-64e6-44d4-ad80-d26fcd0bf765/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100015,
        "cert_state": true,
        "cert_start_timestamp": "2021-09-01",
        "cert_end_timestamp": "2022-06-02"
      }
    ]
 }', '8801051055252'),
        (23, 3, 'LG생활건강 페리오 46cm 펌핑치약 구취 285G', 0, '{
    "company": "엘지생활건강",
	"image": "https://images.velog.io/images/wisepine/post/02190583-a553-4332-8d2f-e22ec3e2f52c/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100016,
        "cert_state": true,
        "cert_start_timestamp": "2021-03-02",
        "cert_end_timestamp": "2022-08-01"
      }
    ]
 }', '8801051065596'),
        (24, 3, 'LG생활건강 엘라스틴 인텐시브 데미지 케어 샴푸 780G x 1EA', 0, '{
    "company": "엘지생활건강",
	"image": "https://images.velog.io/images/wisepine/post/127b89ea-09e3-49d1-84d5-ab4f39848513/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100017,
        "cert_state": true,
        "cert_start_timestamp": "2021-05-21",
        "cert_end_timestamp": "2022-02-25"
      }
    ]
 }', '8801051148855'),
        (25, 3, 'LG생활건강 리엔 오리엔탈 리엔 백단향 샴푸 950G x 1EA', 0, '{
    "company": "엘지생활건강",
	"image": "https://images.velog.io/images/wisepine/post/62494e44-80a9-4fe2-abea-19a92e13c082/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100018,
        "cert_state": true,
        "cert_start_timestamp": "2021-11-12",
        "cert_end_timestamp": "2022-02-25"
      }
    ]
 }', '8801051160840'),
        (26, 3, '(주)엘지생활건강 아우라 퍼퓸섬유탈취제(홀리데이 판타지) 400ml', 0, '{
    "company": "엘지생활건강",
	"image": "https://images.velog.io/images/wisepine/post/910aaac6-6a56-4aec-98ce-ddf066e5c7dc/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100019,
        "cert_state": true,
        "cert_start_timestamp": "2021-01-12",
        "cert_end_timestamp": "2022-06-25"
      }
    ]
 }', '8801051332360'),
        (27, 3, 'LG생활건강 죽염 네츄럴프레쉬허브치약 160G x 3EA', 0, '{
    "company": "엘지생활건강",
	"image": "https://images.velog.io/images/wisepine/post/57918856-c7dd-4428-80b8-de9b2689fbff/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100020,
        "cert_state": true,
        "cert_start_timestamp": "2021-01-12",
        "cert_end_timestamp": "2022-09-01"
      }
    ]
 }', '8801051069372'),
        (28, 1, '(주)세신산업 라체나 세라믹 냄비24cm', 0, '{
    "company": "(주)세신산업",
	"image": "https://images.velog.io/images/wisepine/post/59606c13-0e10-4c9f-ae0d-9e735ca9ab4e/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100021,
        "cert_state": true,
        "cert_start_timestamp": "2021-01-12",
        "cert_end_timestamp": "2022-09-01"
      }
    ]
 }
 
 ', '8809231615470'),
        (29, 1, '실속형 인덕션 프라이팬 3종 세트', 0, '{
    "company": "(주)엠에이치앤코",
	"image": "https://images.velog.io/images/wisepine/post/3e1e18ee-d150-4267-afe4-2c1f7680b468/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100022,
        "cert_state": true,
        "cert_start_timestamp": "2021-09-12",
        "cert_end_timestamp": "2022-03-28"
      }
    ]
 }
 ', '8809677814581'),
        (30, 1, '그린팬 그레이블랙 프라이팬2P세트(24cm+28cm)', 0, '{
    "company": "더쿡웨어컴퍼니",
	"image": "https://images.velog.io/images/wisepine/post/ab6dc9d1-53c1-4bbe-adba-5b99aab09757/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100023,
        "cert_state": true,
        "cert_start_timestamp": "2021-10-23",
        "cert_end_timestamp": "2022-06-28"
      }
    ]
 }
 ', '8809664901157'),
        (31, 1, 'WOW 다이아몬드코팅 프라이팬 3P세트 _28F,28W+스탠드형 유리뚜껑', 0, '{
    "company": "(주)엠에이치앤코",
	"image": "https://images.velog.io/images/wisepine/post/ad615d52-d081-453a-89f5-9aa3776bb22e/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100024,
        "cert_state": true,
        "cert_start_timestamp": "2021-10-21",
        "cert_end_timestamp": "2022-06-12"
      }
    ]
 }', '8809735175821'),
        (32, 1, '이지쿡스 다용도 집게', 0, '{
    "company": "이지쿡스",
	"image": "https://images.velog.io/images/wisepine/post/be064e52-ec02-49a9-8de0-43fdeaf4241d/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100025,
        "cert_state": true,
        "cert_start_timestamp": "2021-04-21",
        "cert_end_timestamp": "2022-08-02"
      }
    ]
 }', '8809735175869'),
        (33, 1, '퍼파 수저세트 1EA', 0, '{
    "company": "(주)아성다이소",
	"image": "https://images.velog.io/images/wisepine/post/1170c76e-c0bc-4b5b-a571-fe8ee42700ee/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100026,
        "cert_state": true,
        "cert_start_timestamp": "2021-04-03",
        "cert_end_timestamp": "2023-01-02"
      }
    ]
 }', '8808739000108'),
        (34, 1, '0044명찰(자석)75*25', 0, '{
    "company": "(주)아트사인",
	"image": "https://images.velog.io/images/wisepine/post/554b9fda-2bfb-46d8-aba3-954e16bf7434/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100027,
        "cert_state": true,
        "cert_start_timestamp": "2021-03-05",
        "cert_end_timestamp": "2022-03-01"
      }
    ]
 }', '8809346167710'),
        (35, 1, '깔끔 실리콘 롱집게_ANZO', 0, '{
    "company": "(주)엠에이치앤코",
	"image": "https://images.velog.io/images/wisepine/post/6336d2e4-5a4e-4fc2-9b9b-f66d916acce9/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100028,
        "cert_state": true,
        "cert_start_timestamp": "2021-07-08",
        "cert_end_timestamp": "2022-03-24"
      }
    ]
 }', '8809677826959'),
        (36, 1, 'GTS5480-고랑몰라 다용도 컬러 클립(3cm)', 0, '{
    "company": "(주)트리",
	"image": "https://images.velog.io/images/wisepine/post/3829895b-49cb-458f-b8a4-d9b067d5adc9/image.png",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100028,
        "cert_state": true,
        "cert_start_timestamp": "2021-07-08",
        "cert_end_timestamp": "2022-09-02"
      }
    ]
 }', '8809404204234');