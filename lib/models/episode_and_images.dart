import 'package:anim_search/models/chapter_image.dart';

class EpisodeAndImages {
  final int? id;
  final String? title;
  final int? displayOrder;
  final int? status;
  final DateTime? createdAt;
  final dynamic updatedAt;
  final dynamic publishedAt;
  final int? comicId;
  final dynamic comic;
  final List<ChapterImages>? images;

  EpisodeAndImages({
    this.id,
    this.title,
    this.displayOrder,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.comicId,
    this.comic,
    this.images,
  });

  factory EpisodeAndImages.fromJson(Map<String, dynamic> json) {
    return EpisodeAndImages(
      id: json['id'] as int?,
      title: json['title'] as String?,
      displayOrder: json['displayOrder'] as int?,
      status: json['status'] as int?,
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'],
      publishedAt: json['publishedAt'],
      comicId: json['comicId'] as int?,
      comic: json['comic'], // assuming it's dynamic, adjust if needed
      images: (json['images'] as List<dynamic>?)
          ?.map((image) => ChapterImages.fromJson(image as Map<String, dynamic>))
          .toList(),
    );
  }

  EpisodeAndImages copyWith({
    int? id,
    String? title,
    int? displayOrder,
    int? status,
    DateTime? createdAt,
    dynamic updatedAt,
    dynamic publishedAt,
    int? comicId,
    dynamic comic,
    List<ChapterImages>? images,
  }) =>
      EpisodeAndImages(
        id: id ?? this.id,
        title: title ?? this.title,
        displayOrder: displayOrder ?? this.displayOrder,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        publishedAt: publishedAt ?? this.publishedAt,
        comicId: comicId ?? this.comicId,
        comic: comic ?? this.comic,
        images: images ?? this.images,
      );
}

class ImageRelated {
  final int? id;
  final String? name;
  final String? url;
  final int? displayOrder;
  final DateTime? createdAt;
  final dynamic updatedAt;
  final int? episodeId;

  ImageRelated({
    this.id,
    this.name,
    this.url,
    this.displayOrder,
    this.createdAt,
    this.updatedAt,
    this.episodeId,
  });

  factory ImageRelated.fromJson(Map<String, dynamic> json) {
    return ImageRelated(
      id: json['id'] as int?,
      name: json['name'] as String?,
      url: json['url'] as String?,
      displayOrder: json['displayOrder'] as int?,
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'],
      episodeId: json['episodeId'] as int?,
    );
  }

  ImageRelated copyWith({
    int? id,
    String? name,
    String? url,
    int? displayOrder,
    DateTime? createdAt,
    dynamic updatedAt,
    int? episodeId,
  }) =>
      ImageRelated(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        displayOrder: displayOrder ?? this.displayOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        episodeId: episodeId ?? this.episodeId,
      );
}
