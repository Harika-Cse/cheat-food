import 'package:flutter/material.dart';
import '../models/food_item_model.dart';
import '../models/cart_item_model.dart';
import '../models/coupon_model.dart';
import '../constants/app_constants.dart';
import '../services/mock_data_service.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItemModel> _items = {};
  CouponModel? _appliedCoupon;
  String? _couponError;
  String? _specialInstructions;

  Map<String, CartItemModel> get items => _items;
  List<CartItemModel> get itemList => _items.values.toList();
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  CouponModel? get appliedCoupon => _appliedCoupon;
  String? get couponError => _couponError;
  String? get specialInstructions => _specialInstructions;

  // Financial Calculations
  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee {
    if (isEmpty) return 0.0;
    if (subtotal >= AppConstants.freeDeliveryThreshold) return 0.0;
    return AppConstants.standardDeliveryFee;
  }

  double get packagingFee => isEmpty ? 0.0 : AppConstants.restaurantPackagingFee;

  double get taxes => isEmpty ? 0.0 : (subtotal * AppConstants.gstRate);

  double get discountAmount {
    if (_appliedCoupon == null || isEmpty) return 0.0;
    return _appliedCoupon!.calculateDiscount(subtotal, deliveryFee);
  }

  double get finalTotal {
    if (isEmpty) return 0.0;
    final total = subtotal + deliveryFee + packagingFee + taxes - discountAmount;
    return total > 0 ? total : 0.0;
  }

  void addItem({
    required FoodItem food,
    int quantity = 1,
    List<String> selectedOptions = const [],
    double extraPricePerUnit = 0.0,
    String? specialInstructions,
  }) {
    final optionKey = selectedOptions.join('-');
    final key = '${food.id}_$optionKey';

    if (_items.containsKey(key)) {
      _items[key]!.quantity += quantity;
    } else {
      _items[key] = CartItemModel(
        id: key,
        food: food,
        quantity: quantity,
        selectedOptions: selectedOptions,
        extraPricePerUnit: extraPricePerUnit,
        specialInstructions: specialInstructions,
      );
    }
    _revalidateCoupon();
    notifyListeners();
  }

  void incrementQuantity(String cartItemId) {
    if (_items.containsKey(cartItemId)) {
      _items[cartItemId]!.quantity += 1;
      _revalidateCoupon();
      notifyListeners();
    }
  }

  void decrementQuantity(String cartItemId) {
    if (!_items.containsKey(cartItemId)) return;
    if (_items[cartItemId]!.quantity > 1) {
      _items[cartItemId]!.quantity -= 1;
    } else {
      _items.remove(cartItemId);
    }
    _revalidateCoupon();
    notifyListeners();
  }

  void removeItem(String cartItemId) {
    _items.remove(cartItemId);
    _revalidateCoupon();
    notifyListeners();
  }

  void setSpecialInstructions(String? instructions) {
    _specialInstructions = instructions;
    notifyListeners();
  }

  bool applyCoupon(String code) {
    _couponError = null;
    final cleanCode = code.trim().toUpperCase();
    final availableCoupons = MockDataService().coupons;

    final match = availableCoupons.firstWhere(
      (c) => c.code.toUpperCase() == cleanCode,
      orElse: () => const CouponModel(
        code: '',
        title: '',
        description: '',
        discountType: '',
        discountValue: 0,
        isActive: false,
      ),
    );

    if (match.code.isEmpty || !match.isActive) {
      _couponError = 'Invalid coupon code. Try CHEATDAY50 or STREET20.';
      notifyListeners();
      return false;
    }

    if (subtotal < match.minOrderAmount) {
      _couponError = 'Min order of ₹${match.minOrderAmount.toInt()} required for this coupon.';
      notifyListeners();
      return false;
    }

    _appliedCoupon = match;
    _couponError = null;
    notifyListeners();
    return true;
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _couponError = null;
    notifyListeners();
  }

  void _revalidateCoupon() {
    if (_appliedCoupon != null && subtotal < _appliedCoupon!.minOrderAmount) {
      _appliedCoupon = null;
      _couponError = 'Coupon removed: Cart below minimum required amount.';
    }
  }

  void clearCart() {
    _items.clear();
    _appliedCoupon = null;
    _couponError = null;
    _specialInstructions = null;
    notifyListeners();
  }
}
