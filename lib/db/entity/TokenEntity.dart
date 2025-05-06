class TokenEntity {
  int? id; // 主键
  String? createTime;
  String? updateTime;
  int? expire;
  String? token;
  int? refreshExpire;
  String? refreshToken;

  TokenEntity({
    this.id,
    this.createTime,
    this.updateTime,
    this.expire,
    this.token,
    this.refreshExpire,
    this.refreshToken,
  });

  // 将实体类转换为Map，便于插入数据库
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createTime': createTime,
      'updateTime': updateTime,
      'expire': expire,
      'token': token,
      'refreshExpire': refreshExpire,
      'refreshToken': refreshToken,
    };
  }

  // 从数据库查询结果中创建实体类
  factory TokenEntity.fromMap(Map<String, dynamic> map) {
    return TokenEntity(
      id: map['id'],
      createTime: map['createTime'],
      updateTime: map['updateTime'],
      expire: map['expire'],
      token: map['token'],
      refreshExpire: map['refreshExpire'],
      refreshToken: map['refreshToken'],
    );
  }
}
