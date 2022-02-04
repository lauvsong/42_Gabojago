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
    name        varchar(50)                  not null,
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

ALTER DATABASE categories CHARACTER SET utf8 COLLATE utf8mb4_general_ci;
ALTER DATABASE products CHARACTER SET utf8 COLLATE utf8mb4_general_ci;
ALTER DATABASE tiers CHARACTER SET utf8 COLLATE utf8mb4_general_ci;
ALTER DATABASE users CHARACTER SET utf8 COLLATE utf8mb4_general_ci;
ALTER DATABASE favorites CHARACTER SET utf8 COLLATE utf8mb4_general_ci;