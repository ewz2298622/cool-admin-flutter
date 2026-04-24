class LiveCommentEntity {
  int? id;
  int? liveId;
  int? userId;
  String? nickName;
  String? avatarUrl;
  String? content;
  String? createTime;

  LiveCommentEntity({
    this.id,
    this.liveId,
    this.userId,
    this.nickName,
    this.avatarUrl,
    this.content,
    this.createTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'liveId': liveId,
      'userId': userId,
      'nickName': nickName,
      'avatarUrl': avatarUrl,
      'content': content,
      'createTime': createTime,
    };
  }

  factory LiveCommentEntity.fromMap(Map<String, dynamic> map) {
    return LiveCommentEntity(
      id: map['id'],
      liveId: map['liveId'],
      userId: map['userId'],
      nickName: map['nickName'],
      avatarUrl: map['avatarUrl'],
      content: map['content'],
      createTime: map['createTime'],
    );
  }
}
