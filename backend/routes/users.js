var express = require("express");
const { sequelize } = require("../models");
var router = express.Router();

const { QueryTypes } = require("sequelize");

// 모든 유저 조회
router.get("/", async (req, res) => {
  let query = `
  SELECT * from users
  `;

  try {
    const users = await sequelize.query(query, {
      type: QueryTypes.SELECT,
      raw: true,
    });

    res.send(users);
  } catch (error) {
    console.error(error);
  }
});

// 모든 유저 조회 (포인트 내림차순 랭킹)
router.get("/rank", async (req, res) => {
  let query = `
  SELECT * from users ORDER BY point DESC
  `;

  try {
    const users = await sequelize.query(query, {
      type: QueryTypes.SELECT,
      raw: true,
    });

    res.send(users);
  } catch (error) {
    console.error(error);
  }
});

// 유저 조회
router.get("/:id", async (req, res) => {
  let query = `
  SELECT * FROM users WHERE id = :id
  `;

  try {
    const users = await sequelize.query(query, {
      replacements: { id: req.params.id },
      type: QueryTypes.SELECT,
      raw: true,
    });

    res.send(users);
  } catch (error) {
    console.error(error);
  }
});

// 유저 조회
router.patch("/:id", async (req, res) => {
  let query = `
  UPDATE users SET 
  username=:username
  point=:point
  tier_id=:tier_id
  WHERE id=:id
  `;

  try {
    await sequelize.query(query, {
      replacements: {
        id: req.params.id,
        username: req.body.username,
        point: req.body.point,
        tier_id: req.body.tier_id,
      },
    });

    res.send();
  } catch (error) {
    console.error(error);
  }
});

// 유저 삭제
router.delete("/:id", async (req, res) => {
  let query = `
  DELETE FROM users WHERE id=:id
  `;

  try {
    await sequelize.query(query, {
      replacements: {
        id: req.params.id,
      },
    });

    res.send();
  } catch (error) {
    console.error(error);
  }
});

module.exports = router;
