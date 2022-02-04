module.exports = (sequelize, DataTypes) => {
    const user = sequelize.define('user', {
        username: {
            type: DataTypes.STRING(50),
            allowNull: false,
            unique: true
        },
        pw: {
            type: DataTypes.STRING(50),
            allowNull: false
        },
        salt: {
            type: DataTypes.STRING(128),
            allowNull: false
        },
        point: {
            type: DataTypes.INTEGER,
            allowNull: false,
            defaultValue: 0
        },
        tier_id: {
            type: DataTypes.INTEGER,
            allowNull: false
        },
    }, {})
    user.associate = (models) => {
        user.hasMany(models.File);
        user.hasOne(models.Page);
    };
    return user
}
