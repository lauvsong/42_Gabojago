const Sequelize = require('sequelize');

module.exports = class User extends Sequelize.Model {//알아서 id를 기본키로 연결해주기에 적어줄 필요가 없다.
    static init(sequelize) {
        return super.init({
            username: {
                type: Sequelize.STRING(50),//varchar(20)
                allowNull: false,
                unique: true,
            },
            pw: {
                type: Sequelize.STRING(50),//varchar(50)
                allowNull: false,
            },
            salt: {
                type: Sequelize.STRING(128),//varchar(50)
                allowNull: false,
            },
            point: {
                type: Sequelize.INTEGER.UNSIGNED,//int unsigned
                allowNull: true,
            }
        }, {//테이블 옵션
            sequelize,
            timestamps: true, //로우가 생성/수정될때 시간이 자동으로 입력된다.
            underscored: false, //테이블명 & 컬럼명을 스네이크 케이스로 바꿈(creaㄷted_at)
            modelName: 'User', //모델 이름 설정
            tableName: 'users', //테이블 명(소문자로 만듦)
            paranoid: true, //true -> deletedAt이라는 컬럼이 생성됨 .여기에 지운 시각이 기록됨. => 로우 복원 가능
            charset: 'utf8',
            collate: 'utf8_general_ci', //한글 입력
        });
    }
    static associate(db) {
        //1:N관계의 n에게 해당
        db.User.belongsTo(db.Tiers, { foreignKey: 'tier_id', targetKey: 'id' });//1:N관계의 N에게 해당-> 다른 모델의 정보가 들어가는 테이블에 사용. ex) User의 정보가 Comments에 들어가기 때문이다.
        db.User.hasMany(db.Favorites, { foreignKey: 'user_id', sourceKey: 'id' });//외래키 따로 지정X -> 모델명 + 기본키 = userId가 외래키로 생성됨.
    }
};

