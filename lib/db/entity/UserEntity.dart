class UserEntity {
  int? id; // 主键
  String? createTime;
  String? updateTime;
  String? unionid;
  String? avatarUrl;
  String? nickName;
  String? phone;
  int? gender;
  int? status;
  int? loginType;
  String? password;
  int? userId;

  UserEntity({
    this.id,
    this.createTime,
    this.updateTime,
    this.unionid,
    this.avatarUrl,
    this.nickName,
    this.phone,
    this.gender,
    this.status,
    this.loginType,
    this.password,
    this.userId,
  });

  // 将实体类转换为Map，便于插入数据库
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createTime': createTime,
      'updateTime': updateTime,
      'unionid': unionid,
      'avatarUrl': avatarUrl,
      'nickName': nickName,
      'phone': phone,
      'gender': gender,
      'status': status,
      'loginType': loginType,
      'password': password,
      'userId': userId,
    };
  }

  // 从数据库查询结果中创建实体类
  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'],
      createTime: map['createTime'],
      updateTime: map['updateTime'],
      unionid: map['unionid'],
      avatarUrl: map['avatarUrl'],
      nickName: map['nickName'],
      phone: map['phone'],
      gender: map['gender'],
      status: map['status'],
      loginType: map['loginType'],
      password: map['password'],
      userId: map['userId'],
    );
  }
}
