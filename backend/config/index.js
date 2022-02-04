require('dotenv').config()

const env = process.env

const development = {
    "username": "root",
    "password": "root",
    "database": "greenDB",
    "host": "localhost",
    "dialect": "mysql",
    "port": env.DB_PORT,
    "define": {
        "underscored": false,
        "freezeTableName": false,
        "charset": "utf8",
        "dialectOptions": {
            "collate": "utf8_general_ci"
        },
        "timestamps": true,
        "paranoid": true
    }
}

const production = {
    "username": env.DB_USER,
    "password": env.DB_PW,
    "database": env.DB_NAME,
    "host": env.DB_HOST,
    "dialect": env.DB_TYPE,
    "port": env.DB_PORT,
    "define": {
        "underscored": false,
        "freezeTableName": false,
        "charset": "utf8",
        "dialectOptions": {
            "collate": "utf8_general_ci"
        },
        "timestamps": true,
        "paranoid": true
    }
}

module.exports = {
  development,
  production
}