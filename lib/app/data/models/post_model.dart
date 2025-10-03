class PostModel {
  final String id;
  final String userId;
  final String categoryId;
  final String description;
  final List<MediaItem> media;
  final List<String> tags;
  final List<String> mentions;
  final String? location;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final String privacy;
  final String status;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final bool isLiked;

  PostModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.description,
    required this.media,
    required this.tags,
    required this.mentions,
    this.location,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.privacy,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.isLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['userId'],
      categoryId: json['categoryId'],
      description: json['description'],
      media: (json['media'] as List)
          .map((item) => MediaItem.fromJson(item))
          .toList(),
      tags: List<String>.from(json['tags']),
      mentions: List<String>.from(json['mentions']),
      location: json['location'],
      likesCount: json['likesCount'],
      commentsCount: json['commentsCount'],
      sharesCount: json['sharesCount'],
      privacy: json['privacy'],
      status: json['status'],
      createdAt: Timestamp.fromJson(json['createdAt']),
      updatedAt: Timestamp.fromJson(json['updatedAt']),
      isLiked: json['isLiked'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'categoryId': categoryId,
        'description': description,
        'media': media.map((item) => item.toJson()).toList(),
        'tags': tags,
        'mentions': mentions,
        'location': location,
        'likesCount': likesCount,
        'commentsCount': commentsCount,
        'sharesCount': sharesCount,
        'privacy': privacy,
        'status': status,
        'createdAt': createdAt.toJson(),
        'updatedAt': updatedAt.toJson(),
        'isLiked': isLiked,
      };
}

class MediaItem {
  final String type;
  final String url;

  MediaItem({required this.type, required this.url});

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      type: json['type'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'url': url,
      };
}

class Timestamp {
  final int seconds;
  final int nanoseconds;

  Timestamp({required this.seconds, required this.nanoseconds});

  factory Timestamp.fromJson(Map<String, dynamic> json) {
    return Timestamp(
      seconds: json['_seconds'],
      nanoseconds: json['_nanoseconds'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_seconds': seconds,
        '_nanoseconds': nanoseconds,
      };
}
