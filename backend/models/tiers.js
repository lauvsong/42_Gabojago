const Sequelize = require('sequelize');

module.exports = class Tiers extends Sequelize.Model {//commenter가 없음. 뭔가 이상함 -> commenter은 foreignKey로 사용되었기 때문이다.
    static init(sequelize) {
        return super.init({
            name: {
                type: Sequelize.STRING(50),
                allowNull: true,
            },
            value: {
                type: Sequelize.INTEGER.UNSIGNED,
                allowNull: false,
                defaultValue: 0
            }
        }, {
            sequelize,
            timestamps: true,
            modelName: 'Tier',
            tableName: 'tiers',
            paranoid: true,
            charset: 'utf8mb4',
            collate: 'utf8mb4_general_ci',
        });
    }
    static associate(db) {
        db.Tiers.hasMany(db.User, { foreignKey: 'tier_id', sourceKey: 'id' });//외래키 따로 지정X -> 모델명 + 기본키 = userId가 외래키로 생성됨.
        //belongsTo에서 외래키를 선정함.
    }
};