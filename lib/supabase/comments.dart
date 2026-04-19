class Comments {
  final String id;
  final String userId;
  final String username;
  final String videoId;
  final String comment;
  final DateTime createdAt;

  Comments({
    required this.id,
    required this.userId,
    required this.username,
    required this.videoId,
    required this.comment,
    required this.createdAt,
  });

  // fromJson
  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['id'],
      userId: json['user_id'],
      username: json['username'],
      videoId: json['video_id'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
