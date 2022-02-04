const response = require("../response");
var express = require("express");
var router = express.Router();
const { User, Favorites, Categories, Tiers, Product } = require('../models');

//get('/user/:id/favorites')
router.get("/:id/favorites", async (req, res, next) => {
  var id = req.params.id;
  const favorites = await Favorites.findAll({
    include: [{
      model: Product,
      required: true, // inner join
    }],
    where: { user_id: id }
  }).catch((err) => {
    console.error(err);
    return next(err);
  });
  if (!favorites) {
    return response(res, 400, 'cannot find favorites');
  }
  return res.json(favorites);
});

//post('/user/:id/favorites')
router.post("/:id/favorites", async (req, res, next) => {
  var id = req.params.id;
  const favorite = await Favorites.create({
    user_id: id,
    product_id: req.body.product_id
  }).catch((err) => {
    console.error(err);
    return next(err);
  });

  return response(res, 201, favorite);
});

//delete('/user/:id/favorites')
router.delete("/:id/favorites", async (req, res, next) => {
  const id = req.params.id;

  const result = Favorites.destroy({
    where: { user_id: id },
  }).catch((e) => {
    console.error(err);
    return next(err);
  });

  if (!result) return response(res, 400, 'cannot find id');
  return response(res, 200);
});

//get(/user/{id}/favorites/groups)
router.get("/:id/favorites/groups", async (req, res, next) => {
  var id = req.params.id;
  const categories = await Categories.findAll({
    include: [{
      model: Product,
      required: true, // inner join
      include: [{
        model: Favorites,
        required: true, // inner join
        where: { user_id: id }
      }],
    }],
  }).catch((err) => {
    console.error(err);
    return next(err);
  });
  if (!categories) {
    return response(res, 400, 'cannot find categories');
  }
  return res.json(categories);
});

//patch(/user/{id}/point)
router.patch("/:id/point", async (req, res, next) => {
  const result = await User.update({
    point: req.body.point,
  }, {
    where: { id: req.params.id },
  }).catch((err) => {
    console.error(err);
    return next(err);
  });

  if (!result) {
    return response(res, 400, 'point is not exist');
  }
  return response(res, 200, result);
});

//patch(/user/{id}/tier)
router.patch("/:id/point/tier", async (req, res, next) => {
  const result = await User.update({
    tier_id: req.body.tier_id,
  }, {
    where: { id: req.params.id },
  }).catch((err) => {
    console.error(err);
    return next(err);
  });

  if (!result) {
    return response(res, 400, 'tier_id is not exist');
  }
  return response(res, 200, result);
});
module.exports = router;