class ComicReview {
  final int? reviewId;
  final String? userName;
  final String? userAvatar;
  final DateTime? createdAt;
  final String? comment;
  final int? rating;

  ComicReview({
    this.reviewId,
    this.userName,
    this.userAvatar,
    this.createdAt,
    this.comment,
    this.rating,
  });

  // Factory constructor to create a ComicReview instance from a JSON map
  factory ComicReview.fromJson(Map<String, dynamic> json) {
    return ComicReview(
      reviewId: json['reviewId'] as int?,
      userName: json['userName'] as String?,
      userAvatar: json['userAvatar'] as String?,
      createdAt: DateTime.parse(json['createdAt']),
      comment: json['comment'] as String?,
      rating: json['rating'] as int?,
    );
  }

  ComicReview copyWith({
    int? reviewId,
    String? userName,
    String? userAvatar,
    DateTime? createdAt,
    String? comment,
    int? rating,
  }) =>
      ComicReview(
        reviewId: reviewId ?? this.reviewId,
        userName: userName ?? this.userName,
        userAvatar: userAvatar ?? this.userAvatar,
        createdAt: createdAt ?? this.createdAt,
        comment: comment ?? this.comment,
        rating: rating ?? this.rating,
      );
}
