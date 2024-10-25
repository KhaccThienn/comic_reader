class Genre {
  final int? id;
  final String? name;
  final String? slug;
  final dynamic createdAt;
  final dynamic updatedAt;

  Genre({
    this.id,
    this.name,
    this.slug,
    this.createdAt,
    this.updatedAt,
  });

  // CopyWith method to create a new instance with modified fields
  Genre copyWith({
    int? id,
    String? name,
    String? slug,
    dynamic createdAt,
    dynamic updatedAt,
  }) =>
      Genre(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  // Factory method to create a Genre from JSON
  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // Method to convert Genre to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
