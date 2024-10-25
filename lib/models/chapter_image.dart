class ChapterImages {
  final int? id;
  final String? name;
  final String? url;
  final int? displayOrder;
  final DateTime? createdAt;
  final dynamic updatedAt;
  final int? episodeId;
  final dynamic episode;

  ChapterImages({
    this.id,
    this.name,
    this.url,
    this.displayOrder,
    this.createdAt,
    this.updatedAt,
    this.episodeId,
    this.episode,
  });

  // Phương thức fromJson để tạo đối tượng từ JSON
  factory ChapterImages.fromJson(Map<String, dynamic> json) {
    return ChapterImages(
      id: json['id'] as int?,
      name: json['name'] as String?,
      url: json['url'] as String?,
      displayOrder: json['displayOrder'] as int?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'], // Nếu có thể null, không cần parse lại
      episodeId: json['episodeId'] as int?,
      episode: json['episode'], // Nếu có thể null
    );
  }

  // Phương thức copyWith để tạo bản sao đối tượng
  ChapterImages copyWith({
    int? id,
    String? name,
    String? url,
    int? displayOrder,
    DateTime? createdAt,
    dynamic updatedAt,
    int? episodeId,
    dynamic episode,
  }) {
    return ChapterImages(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      episodeId: episodeId ?? this.episodeId,
      episode: episode ?? this.episode,
    );
  }
}
