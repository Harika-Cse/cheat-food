class ReviewModel {
  final String id;
  final String foodId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final String? userProfileImage;

  const ReviewModel({
    required this.id,
    required this.foodId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.userProfileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodId': foodId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'userProfileImage': userProfileImage,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return ReviewModel(
      id: id ?? map['id'] ?? '',
      foodId: map['foodId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Street Foodie',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      comment: map['comment'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      userProfileImage: map['userProfileImage'],
    );
  }
}
