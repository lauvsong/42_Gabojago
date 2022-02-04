const Sequelize = require("sequelize");

module.exports = class Product extends Sequelize.Model {
  static init(sequelize) {
    return super.init(
      {
        name: {
          type: Sequelize.STRING(50),
          allowNull: true,
        },
        barcode: {
          type: Sequelize.STRING(50),
        },
        info: {
          type: Sequelize.TEXT,
          allowNull: true,
          get: function () {
            return JSON.parse(this.getDataValue("value"));
          },
          set: function (value) {
            this.setDataValue("value", JSON.stringify(value));
          },
        },
        hit: {
          type: Sequelize.INTEGER.UNSIGNED,
          allowNull: false,
          defaultValue: 0,
        },
      },
      {
        sequelize,
        modelName: "Product",
        tableName: "products",
        paranoid: true,
        charset: "utf8mb4",
        collate: "utf8mb4_general_ci",
      }
    );
  }
  static associate(db) {
    db.Product.hasMany(db.Favorites, {
      foreignKey: "product_id",
      sourceKey: "id",
    }); //외래키 따로 지정X -> 모델명 + 기본키 = userId가 외래키로 생성됨.
    //belongsTo에서 외래키를 선정함.
    db.Product.belongsTo(db.Categories, {
      foreignKey: "category_id",
      targetKey: "id",
    }); //1:N관계의 N에게 해당-> 다른 모델의 정보가 들어가는 테이블에 사용. ex) User의 정보가 Comments에 들어가기 때문이다.
  }
};
