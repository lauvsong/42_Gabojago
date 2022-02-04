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

insert into greenDB.tiers (id, name, value)
values  (1, 'seed', 0),
        (2, 'sprout', 50),
        (3, 'leaf', 100),
        (4, 'grass', 150),
        (5, 'tree', 200),
        (6, 'forest', 250);

insert into greenDB.categories (id, name)
values  (1, '기타'),
        (2, '의류'),
        (3, '생활용품'),
        (4, '가방'),
        (5, '식가공품'),
        (6, '부엌');

insert into greenDB.products (id, category_id, name, hit, info, bacode)
values  (1, 1, '하이트진로', 0, '{
    "company": "하이트진로",
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
        (2, 1, '보령 메디앙스 B&B 사각 면봉 200P', 0, '{
    "company": "보령 메디앙스",
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
        (3, 1, '맥심 T.O.P 에스프레소 마스터 라떼 275ml', 0, '{
    "company": "동서식품",
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
        (4, 1, '(주)일동엘앤비 새싹이100매 390G x 1EA', 0, '{
    "company": "(주)일동엘앤비",
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
        (5, 1, '(주)크리오 휴대용 센스R+M치약 x 1EA', 0, '{
    "company": "(주)크리오",
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
        (6, 1, '후레쉬 장갑 50매', 0, '{
    "company": "한국쓰리엠(주)",
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
        (7, 1, '깨끗한나라 보솜이 13무안심 캡60매
', 0, '{
    "company": "깨끗한나라",
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
        (9, 1, '해태 후렌치파이 딸기 192g', 0, '{
    "company": "해태제과",
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
        (10, 1, '청우식품 브루느와 브라우니 쿠키 165G', 0, '{
    "company": "청우식품",
    "mark": [
      {
        "name": "환경표지",
        "cert_id": 100009,
        "cert_state": true,
        "cert_start_timestamp": "2020-11-21",
        "cert_end_timestamp": "2023-07-29"
      }
    ]
 }', '8801204204452');