var createError = require("http-errors");
var express = require("express");
var path = require("path");
var cookieParser = require("cookie-parser");
var logger = require("morgan");
const nunjucks = require('nunjucks');
require("dotenv").config();

const { sequelize } = require('./models');

var indexRouter = require("./routes/index");
var userRouter = require("./routes/user/user");
var usersRouter = require("./routes/user/users");
var productRouter = require("./routes/product");
var productsRouter = require("./routes/products");

var app = express();
app.set('port', process.env.Port || 3001);

// view engine setup
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "pug");
nunjucks.configure('views', {
  express: app,
  watch: true,
});

sequelize.sync({ force: false })
  .then(() => {
    console.log('데이터베이스 연결 성공');
  })
  .catch((err) => {
    console.error(err);
  })
app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));

app.use("/", indexRouter);
app.use("/user", userRouter);
app.use("/users", usersRouter);
app.use("/product", productRouter);
app.use("/products", productsRouter);

// catch 404 and forward to error handler
app.use(function (req, res, next) {
  next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get("env") === "development" ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render("error");
});

app.listen(app.get('port'), () => {
  console.log(app.get('port'), '번 포트에서 대기 중');
})

module.exports = app;
