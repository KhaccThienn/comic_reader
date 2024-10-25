class Comic {
  final int id;
  final String title;
  final String? slug;
  final String description;
  final String poster;
  final int releaseYear;
  final int view;
  final double rating;
  final String type;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic publishedAt;
  final List<dynamic> episodes;
  final List<dynamic> reviews;

  Comic({
    required this.id,
    required this.title,
    this.slug,
    required this.description,
    required this.poster,
    required this.releaseYear,
    required this.view,
    required this.rating,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.episodes,
    required this.reviews,
  });

  // Factory constructor to create a Comic instance from JSON
  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      poster: json['poster'],
      releaseYear: json['releaseYear'],
      view: json['view'],
      rating: (json['rating'] as num).toDouble(),
      type: json['type'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publishedAt: json['publishedAt'],
      episodes: json['episodes'] ?? [],
      reviews: json['reviews'] ?? [],
    );
  }
}


class ImageData {
  final int id;
  final String name;
  final String url;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int episodeId;
  final String episode;

  ImageData({
    required this.id,
    required this.name,
    required this.url,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.episodeId,
    required this.episode,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      displayOrder: json['displayOrder'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      episodeId: json['episodeId'],
      episode: json['episode'],
    );
  }
}

class Review {
  final int id;
  final String comment;
  final double rating;
  final int userId;
  final int comicId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String comic;
  final User user;

  Review({
    required this.id,
    required this.comment,
    required this.rating,
    required this.userId,
    required this.comicId,
    required this.createdAt,
    required this.updatedAt,
    required this.comic,
    required this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      comment: json['comment'],
      rating: json['rating'].toDouble(),
      userId: json['userId'],
      comicId: json['comicId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      comic: json['comic'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "comment": comment,
      "rating": rating,
      "userId": userId,
      "comicId": comicId,
      "createdAt": createdAt.toIso8601String(), // Convert DateTime to ISO string
      "updatedAt": updatedAt.toIso8601String(),
      "comic": comic,
      "user": user.toMap(), // Convert User object to a Map
    };
  }

}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final String? avatar;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Review>? reviews;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.avatar,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.reviews,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] != null ? json['id'] as int : null,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      avatar: json['avatar'] as String?,
      role: json['role'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      reviews: json['reviews'] != null
          ? List<Review>.from(json['reviews'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id?.toString() ?? "0", // Handling null case with "0"
      "name": name,
      "email": email,
      "password": password,
      "avatar": avatar,
      "role": role,
      "createdAt": createdAt?.toIso8601String(), // Converts DateTime to String
      "updatedAt": updatedAt?.toIso8601String(),
      "reviews": reviews != null
          ? reviews!.map((review) => review.toMap()).toList()
          : [], // Convert List<Review> to List<Map>
    };
  }
}
