const Sequelize = require('sequelize');
const Categories = require('./categories');
const Favorites = require('./favorites');
const Product = require('./product');
const Tiers = require('./tiers');
const User = require('./user');

const env = process.env.NODE_ENV || 'development';
const config = require('../config')[env]
const db = {};

const sequelize = new Sequelize(config.database, config.username, config.password, config)

db.sequelize = sequelize;
db.Categories = Categories;
db.Favorites = Favorites;
db.Product = Product;
db.Tiers = Tiers;
db.User = User;

//static.init메서드를 호출
Categories.init(sequelize);
Favorites.init(sequelize);
Product.init(sequelize);
Tiers.init(sequelize);
User.init(sequelize);

//다른 테이블과의 관계를 연결
Categories.associate(db);
Favorites.associate(db);
Product.associate(db);
Tiers.associate(db);
User.associate(db);

module.exports = db;