class Episode {
  final int? id; // Nullable
  final String? title; // Nullable
  final int? displayOrder; // Nullable
  final int? status; // Nullable
  final DateTime? createdAt; // Nullable
  final DateTime? updatedAt; // Nullable
  final DateTime? publishedAt; // Nullable
  final int? comicId; // Nullable
  final dynamic comic; // Nullable
  final List<dynamic>? images; // Nullable List

  Episode({
    this.id, // Optional parameter
    this.title, // Optional parameter
    this.displayOrder, // Optional parameter
    this.status, // Optional parameter
    this.createdAt, // Optional parameter
    this.updatedAt, // Optional parameter
    this.publishedAt, // Optional parameter
    this.comicId, // Optional parameter
    this.comic, // Optional parameter
    this.images, // Optional parameter
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      title: json['title'],
      displayOrder: json['displayOrder'],
      status: json['status'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt']) : null,
      comicId: json['comicId'],
      comic: json['comic'],
      images: json['images'] != null ? List<dynamic>.from(json['images']) : null,
    );
  }

  Episode copyWith({
    int? id,
    String? title,
    int? displayOrder,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
    int? comicId,
    dynamic comic,
    List<dynamic>? images,
  }) =>
      Episode(
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