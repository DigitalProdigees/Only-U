class PostComment {
  final String id;
  final String userId;
  final String text;
  final int likesCount;
  final DateTime createdAt;

  PostComment({
    required this.id,
    required this.userId,
    required this.text,
    required this.likesCount,
    required this.createdAt,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    final timestamp = json['createdAt'];
    final seconds = timestamp['_seconds'] as int;
    final nanoseconds = timestamp['_nanoseconds'] as int;

    return PostComment(
      id: json['id'],
      userId: json['userId'],
      text: json['text'],
      likesCount: json['likesCount'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (seconds * 1000) + (nanoseconds ~/ 1000000),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'text': text,
      'likesCount': likesCount,
      'createdAt': {
        '_seconds': createdAt.millisecondsSinceEpoch ~/ 1000,
        '_nanoseconds': (createdAt.millisecondsSinceEpoch % 1000) * 1000000,
      },
    };
  }
}
