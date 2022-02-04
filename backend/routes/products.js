var express = require("express");
const { sequelize } = require("../models");
var router = express.Router();

var Product = require("../models").product;
var Categories = require("../models").categories;
const { QueryTypes } = require("sequelize");

// 모든 제품 리스트 조회
router.get("/", async (req, res) => {
  let query = `
  SELECT p.*,c.name as category_name FROM products AS p
  LEFT JOIN categories AS c
  on p.category_id = c.id
  `;

  try {
    const products = await sequelize.query(query, {
      type: QueryTypes.SELECT,
      raw: true,
    });

    products.map((data) => (data.info = JSON.parse(data.info)));
    res.send(products);
  } catch (error) {
    console.error(error);
  }
});

// 모든 제품 리스트 조회 (조회수 내림차순 랭킹)
router.get("/rank", async (req, res) => {
  let query = `
  SELECT p.*,c.name as category_name FROM products AS p
  LEFT JOIN categories AS c
  on p.category_id = c.id
  ORDER BY hit DESC
  `;

  try {
    const products = await sequelize.query(query, {
      type: QueryTypes.SELECT,
      raw: true,
    });

    products.map((data) => (data.info = JSON.parse(data.info)));
    res.send(products);
  } catch (error) {
    console.error(error);
  }
});

// 특정 카테고리 제품 리스트 조회
router.get("/category/:category_id", async (req, res) => {
  let query = `
  SELECT p.*,c.name as category_name FROM products AS p
  LEFT JOIN categories AS c
  on p.category_id = c.id
  WHERE c.id = :category_id
  `;

  try {
    const products = await sequelize.query(query, {
      replacements: { category_id: req.params.category_id },
      type: QueryTypes.SELECT,
      raw: true,
    });

    products.map((data) => (data.info = JSON.parse(data.info)));
    res.send(products);
  } catch (error) {
    console.error(error);
  }
});

module.exports = router;
