create table products
(
    id       int auto_increment
        primary key,
    category int                          not null,
    info     longtext collate utf8mb4_bin not null,
    hit      int default 0                not null
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