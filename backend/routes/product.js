var express = require("express");
const { sequelize } = require("../models");
var router = express.Router();

var Product = require("../models").product;
var Categories = require("../models").categories;
const { QueryTypes } = require("sequelize");

// 바코드를 통한 특정 제품 조회
router.get("/bacode/:bacode", async (req, res) => {
  let query = `
  SELECT p.*,c.name as category_name FROM products AS p
  LEFT JOIN categories AS c
  on p.category_id = c.id
  WHERE p.bacode = :bacode
  `;

  try {
    const products = await sequelize.query(query, {
      replacements: { bacode: req.params.bacode },
      type: QueryTypes.SELECT,
      raw: true,
    });

    products.map((data) => (data.info = JSON.parse(data.info)));
    res.send(products);
  } catch (error) {
    console.error(error);
  }
});

// 특정 제품 조회
router.get("/:id", async (req, res) => {
  let query = `
  SELECT p.*,c.name as category_name FROM products AS p
  LEFT JOIN categories AS c
  on p.category_id = c.id
  WHERE p.id = :id
  `;

  try {
    const products = await sequelize.query(query, {
      replacements: { id: req.params.id },
      type: QueryTypes.SELECT,
      raw: true,
    });

    products.map((data) => (data.info = JSON.parse(data.info)));
    res.send(products);
  } catch (error) {
    console.error(error);
  }
});

// 특정 제품 정보 전체 수정
router.put("/:id", async (req, res) => {
  let query = `
  UPDATE products SET 
  info = :info 
  category_id = :category_id
  name = :name
  bacode = :bacode
  hit = :hit
  WHERE id = :id
  `;

  try {
    await sequelize.query(query, {
      replacements: {
        id: req.params.id,
        category_id: req.body.category_id,
        name: req.body.name,
        bacode: req.body.bacode,
        hit: req.body.hit,
        info: JSON.stringify(req.body.info),
      },
    });
    res.send();
  } catch (error) {
    console.error(error);
  }
});

// 특정 제품 삭제
router.delete("/:id", async (req, res) => {
  let query = `
  DELETE FROM products WHERE id = :id
  `;

  try {
    await sequelize.query(query, {
      replacements: { id: req.params.id },
    });
    res.send();
  } catch (error) {
    console.error(error);
  }
});

// 특정 제품 조회수 +1 갱신
router.patch("/:id", async (req, res) => {
  let query = `
  UPDATE products SET hit = hit + 1 WHERE id = :id
  `;

  try {
    await sequelize.query(query, {
      replacements: { id: req.params.id },
    });
    res.send();
  } catch (error) {
    console.error(error);
  }
});

// 제품 등록
router.post("/register", async (req, res) => {
  let query = `
  INSERT INTO products (category_id, name, hit, info, bacode)
  values (:category_id, :name, :hit, :info, :bacode)
  `;

  try {
    await sequelize.query(query, {
      replacements: {
        category_id: req.body.category_id,
        name: req.body.name,
        hit: req.body.hit,
        info: JSON.stringify(req.body.info),
        bacode: req.body.bacode,
      },
    });
    res.send();
  } catch (error) {
    console.error(error);
  }
});

module.exports = router;
