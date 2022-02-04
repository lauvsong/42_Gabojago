'use strict'

require('dotenv').config()

const Sequelize = require('sequelize')
const env = process.env.NODE_ENV || 'development';
const config = require('../config')[env]
const db = {}

Sequelize.useCLS(namespace);
const sequelize = new Sequelize(config.database, config.username, config.password, config)

db.DownloadLog = require('./downloadLog')(sequelize, Sequelize);
db.Os = require('./os')(sequelize, Sequelize);
db.Product = require('./product')(sequelize, Sequelize);
db.User = require('./user')(sequelize, Sequelize);
db.Page = require('./page')(sequelize, Sequelize);
db.File = require('./file')(sequelize, Sequelize);
db.Template = require('./template')(sequelize, Sequelize);

Object.keys(db).forEach((modelName) => {
    if (db[modelName].associate) {
        db[modelName].associate(db)
    }
})

db.sequelize = sequelize
db.Sequelize = Sequelize

module.exports = db
