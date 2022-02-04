'use strict'

require('dotenv').config()

const cls = require('cls-hooked')
const namespace = cls.createNamespace('gabojago-namespace')
const Sequelize = require('sequelize')
const env = process.env.NODE_ENV || 'development';
const config = require('../config')[env]
const db = {}

Sequelize.useCLS(namespace);
const sequelize = new Sequelize(config.database, config.username, config.password, config)

db.Favorites = require('./favorites')(sequelize, Sequelize);
db.Categories = require('./categories')(sequelize, Sequelize);
db.Product = require('./product')(sequelize, Sequelize);
db.User = require('./user')(sequelize, Sequelize);
db.Tiers = require('./tiers')(sequelize, Sequelize);

Object.keys(db).forEach((modelName) => {
    if (db[modelName].associate) {
        db[modelName].associate(db)
    }
})

db.sequelize = sequelize
db.Sequelize = Sequelize

module.exports = db
