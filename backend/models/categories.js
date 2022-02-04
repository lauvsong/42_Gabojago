const Sequelize = require('sequelize');

module.exports = class Categories extends Sequelize.Model {
    static init(sequelize) {
        return super.init({
            name: {
                type: Sequelize.STRING(50),
                allowNull: true
            }
        }, {
            sequelize,
            timestamps: true,
            modelName: 'Category',
            tableName: 'categories',
            paranoid: true,
            charset: 'utf8mb4',
            collate: 'utf8mb4_general_ci',
        });
    }
    static associate(db) {
        db.Categories.hasMany(db.Product, { foreignKey: 'category_id', sourceKey: 'id' });//외래키 따로 지정X -> 모델명 + 기본키 = userId가 외래키로 생성됨.
        //belongsTo에서 외래키를 선정함.
    }
};