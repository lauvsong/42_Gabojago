require('dotenv').config()

const env = process.env

const development = {
    "username": "admin",
    "password": "P@ssw0rd",
    "database": "nodejs",
    "host": "green-db",
    "dialect": "mariadb",
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
    "username": "admin",
    "password": "P@ssw0rd",
    "database": "nodejs",
    "host": "green-db",
    "dialect": "mariadb",
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