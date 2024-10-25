class History {
  final int? comicId;
  final String? comicName;
  final int? episodeId;
  final int? displayOrder;
  final String? episodeName;
  final String? imageUrl;
  final DateTime? updatedAt;

  History({
    this.comicId,
    this.comicName,
    this.episodeId,
    this.displayOrder,
    this.episodeName,
    this.imageUrl,
    this.updatedAt,
  });

  History copyWith({
    int? comicId,
    String? comicName,
    int? episodeId,
    String? episodeName,
    String? imageUrl,
    DateTime? updatedAt,
  }) =>
      History(
        comicId: comicId ?? this.comicId,
        comicName: comicName ?? this.comicName,
        episodeId: episodeId ?? this.episodeId,
        displayOrder: displayOrder ?? this.displayOrder,
        episodeName: episodeName ?? this.episodeName,
        imageUrl: imageUrl ?? this.imageUrl,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  // Method to convert from JSON
  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      comicId: json['comicId'] as int?,
      comicName: json['comicName'] as String?,
      episodeId: json['episodeId'] as int?,
      displayOrder: json['displayOrder'] as int?,
      episodeName: json['episodeName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
}
