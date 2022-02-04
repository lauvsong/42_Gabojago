var express = require("express");
var router = express.Router();

var Product = require("../../models").product;
var Categories = require("../../models").categories;

// 모든 제품 리스트 조회
router.get("/", async (req, res, next) => {
  try {
    const products = await Product.findAll(
      {include: [{
        model: 
      }]}
    );
    console.log(products);
    res.send(products);
  } catch (error) {
    console.error(error);
    next(error);
  }
});

// 모든 제품 리스트 조회 (조회수 내림차순 랭킹)
router.get("/rank", async (req, res, next) => {
  try {
    const products = await Product.findAll();
    console.log(products);
    res.send(products);
  } catch (error) {
    console.error(error);
    next(error);
  }
});

module.exports = router;
