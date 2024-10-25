import 'package:anim_search/models/episode.dart';

class ComicDetail {
  final int? id;
  final String? title;
  final String? slug;
  final String? description;
  final String? poster;
  final int? releaseYear;
  final int? view;
  final double? rating;
  final String? type;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic publishedAt;
  final List<Episode>? episodes;
  final List<Review>? reviews;
  final List<Director>? directors;
  final List<Actor>? actors;
  final List<Genre>? genres;

  ComicDetail({
    required this.id,
    required this.title,
    required this.slug,
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
    required this.directors,
    required this.actors,
    required this.genres,
  });

  factory ComicDetail.fromJson(Map<String, dynamic> json) {
    return ComicDetail(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      poster: json['poster'],
      releaseYear: json['releaseYear'],
      view: json['view'],
      rating: json['rating'],
      type: json['type'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publishedAt: json['publishedAt'],
      episodes: (json['episodes'] as List).map((e) => Episode.fromJson(e)).toList(),
      reviews: (json['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
      directors: (json['directors'] as List).map((e) => Director.fromJson(e)).toList(),
      actors: (json['actors'] as List).map((e) => Actor.fromJson(e)).toList(),
      genres: (json['genres'] as List).map((e) => Genre.fromJson(e)).toList(),
    );
  }

  ComicDetail copyWith({
    int? id,
    String? title,
    String? slug,
    String? description,
    String? poster,
    int? releaseYear,
    int? view,
    double? rating,
    String? type,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic publishedAt,
    List<Episode>? episodes,
    List<Review>? reviews,
    List<Director>? directors,
    List<Actor>? actors,
    List<Genre>? genres,
  }) =>
      ComicDetail(
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        description: description ?? this.description,
        poster: poster ?? this.poster,
        releaseYear: releaseYear ?? this.releaseYear,
        view: view ?? this.view,
        rating: rating ?? this.rating,
        type: type ?? this.type,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        publishedAt: publishedAt ?? this.publishedAt,
        episodes: episodes ?? this.episodes,
        reviews: reviews ?? this.reviews,
        directors: directors ?? this.directors,
        actors: actors ?? this.actors,
        genres: genres ?? this.genres,
      );
}

class Actor {
  final int id;
  final String name;

  Actor({
    required this.id,
    required this.name,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'],
      name: json['name'],
    );
  }

  Actor copyWith({
    int? id,
    String? name,
  }) =>
      Actor(
        id: id ?? this.id,
        name: name ?? this.name,
      );
}

class Director {
  final int id;
  final String name;

  Director({
    required this.id,
    required this.name,
  });

  factory Director.fromJson(Map<String, dynamic> json) {
    return Director(
      id: json['id'],
      name: json['name'],
    );
  }

  Director copyWith({
    int? id,
    String? name,
  }) =>
      Director(
        id: id ?? this.id,
        name: name ?? this.name,
      );
}

class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }

  Genre copyWith({
    int? id,
    String? name,
  }) =>
      Genre(
        id: id ?? this.id,
        name: name ?? this.name,
      );
}

class Review {
  final int id;
  final String comment;
  final int rating;
  final int userId;
  final DateTime createdAt;
  final dynamic updatedAt;

  Review({
    required this.id,
    required this.comment,
    required this.rating,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      comment: json['comment'],
      rating: json['rating'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'],
    );
  }

  Review copyWith({
    int? id,
    String? comment,
    int? rating,
    int? userId,
    DateTime? createdAt,
    dynamic updatedAt,
  }) =>
      Review(
        id: id ?? this.id,
        comment: comment ?? this.comment,
        rating: rating ?? this.rating,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
