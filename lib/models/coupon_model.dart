class CouponModel {
  final String code;
  final String title;
  final String description;
  final String discountType; // 'percentage' or 'flat' or 'free_delivery'
  final double discountValue; // e.g. 50 for 50%, or 35 for flat ₹35
  final double maxDiscountAmount;
  final double minOrderAmount;
  final bool isActive;

  const CouponModel({
    required this.code,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    this.maxDiscountAmount = 100.0,
    this.minOrderAmount = 149.0,
    this.isActive = true,
  });

  double calculateDiscount(double subtotal, double deliveryFee) {
    if (subtotal < minOrderAmount) return 0.0;

    if (discountType == 'free_delivery') {
      return deliveryFee;
    } else if (discountType == 'flat') {
      return discountValue > subtotal ? subtotal : discountValue;
    } else if (discountType == 'percentage') {
      final calculated = (subtotal * discountValue) / 100.0;
      return calculated > maxDiscountAmount ? maxDiscountAmount : calculated;
    }
    return 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'title': title,
      'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'maxDiscountAmount': maxDiscountAmount,
      'minOrderAmount': minOrderAmount,
      'isActive': isActive,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      code: map['code'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      discountType: map['discountType'] ?? 'percentage',
      discountValue: (map['discountValue'] as num?)?.toDouble() ?? 0.0,
      maxDiscountAmount:
          (map['maxDiscountAmount'] as num?)?.toDouble() ?? 100.0,
      minOrderAmount: (map['minOrderAmount'] as num?)?.toDouble() ?? 0.0,
      isActive: map['isActive'] ?? true,
    );
  }
}
