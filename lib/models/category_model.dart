class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String iconEmoji;
  final String imageUrl;
  final int displayOrder;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconEmoji,
    required this.imageUrl,
    this.displayOrder = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconEmoji': iconEmoji,
      'imageUrl': imageUrl,
      'displayOrder': displayOrder,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return CategoryModel(
      id: id ?? map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      iconEmoji: map['iconEmoji'] ?? '🍲',
      imageUrl: map['imageUrl'] ?? '',
      displayOrder: (map['displayOrder'] as num?)?.toInt() ?? 0,
    );
  }

  CategoryModel copyWith({
    String? name,
    String? description,
    String? iconEmoji,
    String? imageUrl,
    int? displayOrder,
  }) {
    return CategoryModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      imageUrl: imageUrl ?? this.imageUrl,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }
}
