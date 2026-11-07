class FoodCustomizationOption {
  final String name;
  final double extraPrice;

  const FoodCustomizationOption({
    required this.name,
    this.extraPrice = 0.0,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'extraPrice': extraPrice,
      };

  factory FoodCustomizationOption.fromMap(Map<String, dynamic> map) =>
      FoodCustomizationOption(
        name: map['name'] ?? '',
        extraPrice: (map['extraPrice'] as num?)?.toDouble() ?? 0.0,
      );
}

class FoodCustomization {
  final String title;
  final bool isMultipleChoice;
  final bool isRequired;
  final List<FoodCustomizationOption> options;

  const FoodCustomization({
    required this.title,
    this.isMultipleChoice = false,
    this.isRequired = false,
    required this.options,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'isMultipleChoice': isMultipleChoice,
        'isRequired': isRequired,
        'options': options.map((o) => o.toMap()).toList(),
      };

  factory FoodCustomization.fromMap(Map<String, dynamic> map) =>
      FoodCustomization(
        title: map['title'] ?? '',
        isMultipleChoice: map['isMultipleChoice'] ?? false,
        isRequired: map['isRequired'] ?? false,
        options: (map['options'] as List<dynamic>?)
                ?.map((item) => FoodCustomizationOption.fromMap(
                    Map<String, dynamic>.from(item)))
                .toList() ??
            [],
      );
}

class FoodItem {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String categoryName;
  final double price;
  final double? discountPrice;
  final String imageUrl;
  final bool isVeg;
  final String spiceLevel; // 'Mild', 'Medium', 'Fiery Spicy'
  final String vendorId;
  final String vendorName;
  final double rating;
  final int ratingCount;
  final int preparationTimeMinutes;
  final bool isAvailable;
  final bool isBestSeller;
  final bool isTrending;
  final bool isRecommended;
  final List<FoodCustomization> customizations;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.price,
    this.discountPrice,
    required this.imageUrl,
    this.isVeg = true,
    this.spiceLevel = 'Medium',
    required this.vendorId,
    required this.vendorName,
    this.rating = 4.5,
    this.ratingCount = 20,
    this.preparationTimeMinutes = 15,
    this.isAvailable = true,
    this.isBestSeller = false,
    this.isTrending = false,
    this.isRecommended = false,
    this.customizations = const [],
  });

  double get effectivePrice => discountPrice ?? price;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;
  int get discountPercentage => hasDiscount
      ? (((price - discountPrice!) / price) * 100).round()
      : 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'price': price,
      'discountPrice': discountPrice,
      'imageUrl': imageUrl,
      'isVeg': isVeg,
      'spiceLevel': spiceLevel,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'rating': rating,
      'ratingCount': ratingCount,
      'preparationTimeMinutes': preparationTimeMinutes,
      'isAvailable': isAvailable,
      'isBestSeller': isBestSeller,
      'isTrending': isTrending,
      'isRecommended': isRecommended,
      'customizations': customizations.map((c) => c.toMap()).toList(),
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map, {String? id}) {
    return FoodItem(
      id: id ?? map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (map['discountPrice'] as num?)?.toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      isVeg: map['isVeg'] ?? true,
      spiceLevel: map['spiceLevel'] ?? 'Medium',
      vendorId: map['vendorId'] ?? '',
      vendorName: map['vendorName'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 0,
      preparationTimeMinutes:
          (map['preparationTimeMinutes'] as num?)?.toInt() ?? 15,
      isAvailable: map['isAvailable'] ?? true,
      isBestSeller: map['isBestSeller'] ?? false,
      isTrending: map['isTrending'] ?? false,
      isRecommended: map['isRecommended'] ?? false,
      customizations: (map['customizations'] as List<dynamic>?)
              ?.map((item) =>
                  FoodCustomization.fromMap(Map<String, dynamic>.from(item)))
              .toList() ??
          [],
    );
  }

  FoodItem copyWith({
    String? name,
    String? description,
    String? categoryId,
    String? categoryName,
    double? price,
    double? discountPrice,
    String? imageUrl,
    bool? isVeg,
    String? spiceLevel,
    String? vendorId,
    String? vendorName,
    double? rating,
    int? ratingCount,
    int? preparationTimeMinutes,
    bool? isAvailable,
    bool? isBestSeller,
    bool? isTrending,
    bool? isRecommended,
    List<FoodCustomization>? customizations,
  }) {
    return FoodItem(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      isVeg: isVeg ?? this.isVeg,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      preparationTimeMinutes:
          preparationTimeMinutes ?? this.preparationTimeMinutes,
      isAvailable: isAvailable ?? this.isAvailable,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      isTrending: isTrending ?? this.isTrending,
      isRecommended: isRecommended ?? this.isRecommended,
      customizations: customizations ?? this.customizations,
    );
  }
}
