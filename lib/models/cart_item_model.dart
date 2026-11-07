import 'food_item_model.dart';

class CartItemModel {
  final String id;
  final FoodItem food;
  int quantity;
  final List<String> selectedOptions;
  final double extraPricePerUnit;
  final String? specialInstructions;

  CartItemModel({
    required this.id,
    required this.food,
    this.quantity = 1,
    this.selectedOptions = const [],
    this.extraPricePerUnit = 0.0,
    this.specialInstructions,
  });

  double get unitPrice => food.effectivePrice + extraPricePerUnit;
  double get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodId': food.id,
      'foodName': food.name,
      'foodPrice': food.effectivePrice,
      'imageUrl': food.imageUrl,
      'isVeg': food.isVeg,
      'vendorId': food.vendorId,
      'vendorName': food.vendorName,
      'quantity': quantity,
      'selectedOptions': selectedOptions,
      'extraPricePerUnit': extraPricePerUnit,
      'specialInstructions': specialInstructions,
      'totalPrice': totalPrice,
    };
  }

  factory CartItemModel.fromFoodItem({
    required FoodItem food,
    int quantity = 1,
    List<String> selectedOptions = const [],
    double extraPricePerUnit = 0.0,
    String? specialInstructions,
  }) {
    final optionKey = selectedOptions.join('-');
    final uniqueId = '${food.id}_$optionKey';
    return CartItemModel(
      id: uniqueId,
      food: food,
      quantity: quantity,
      selectedOptions: selectedOptions,
      extraPricePerUnit: extraPricePerUnit,
      specialInstructions: specialInstructions,
    );
  }

  CartItemModel copyWith({
    int? quantity,
    List<String>? selectedOptions,
    double? extraPricePerUnit,
    String? specialInstructions,
  }) {
    return CartItemModel(
      id: id,
      food: food,
      quantity: quantity ?? this.quantity,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      extraPricePerUnit: extraPricePerUnit ?? this.extraPricePerUnit,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}
