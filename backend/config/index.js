require("dotenv").config();

const env = process.env;

const development = {
  username: "admin",
  password: "P@ssw0rd",
  database: "nodejs",
  host: env.DB_HOST,
  dialect: "mariadb",
  port: env.DB_PORT,
  define: {
    underscored: false,
    freezeTableName: false,
    charset: "utf8",
    dialectOptions: {
      collate: "utf8_general_ci",
    },
    timestamps: true,
    paranoid: true,
  },
};

const production = {
  username: env.DB_USER,
  password: env.DB_PASSWORD,
  database: env.DB_NAME,
  host: env.DB_HOST,
  dialect: "mariadb",
  port: env.DB_PORT,
  define: {
    underscored: false,
    freezeTableName: false,
    charset: "utf8",
    dialectOptions: {
      collate: "utf8_general_ci",
    },
    timestamps: true,
    paranoid: true,
  },
};

module.exports = {
  development,
  production,
};
