import 'address_model.dart';
import 'cart_item_model.dart';

class OrderItemSnapshot {
  final String foodId;
  final String foodName;
  final double unitPrice;
  final int quantity;
  final double totalPrice;
  final String imageUrl;
  final bool isVeg;
  final List<String> selectedOptions;
  final String vendorName;

  const OrderItemSnapshot({
    required this.foodId,
    required this.foodName,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
    required this.imageUrl,
    required this.isVeg,
    this.selectedOptions = const [],
    this.vendorName = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'imageUrl': imageUrl,
      'isVeg': isVeg,
      'selectedOptions': selectedOptions,
      'vendorName': vendorName,
    };
  }

  factory OrderItemSnapshot.fromMap(Map<String, dynamic> map) {
    return OrderItemSnapshot(
      foodId: map['foodId'] ?? '',
      foodName: map['foodName'] ?? '',
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      isVeg: map['isVeg'] ?? true,
      selectedOptions: List<String>.from(map['selectedOptions'] ?? []),
      vendorName: map['vendorName'] ?? '',
    );
  }

  factory OrderItemSnapshot.fromCartItem(CartItemModel item) {
    return OrderItemSnapshot(
      foodId: item.food.id,
      foodName: item.food.name,
      unitPrice: item.unitPrice,
      quantity: item.quantity,
      totalPrice: item.totalPrice,
      imageUrl: item.food.imageUrl,
      isVeg: item.food.isVeg,
      selectedOptions: item.selectedOptions,
      vendorName: item.food.vendorName,
    );
  }
}

class OrderModel {
  final String id;
  final String userId;
  final String customerName;
  final String customerPhone;
  final AddressModel deliveryAddress;
  final List<OrderItemSnapshot> items;
  final double subtotal;
  final double deliveryFee;
  final double packagingFee;
  final double taxes;
  final double discountAmount;
  final String? appliedCouponCode;
  final double totalAmount;
  final String paymentMethod; // 'Cash on Delivery', 'UPI (Google Pay / PhonePe)', 'Credit/Debit Card'
  final String paymentStatus; // 'Pending', 'Paid', 'Failed'
  final String status; // 'Placed', 'Confirmed', 'Preparing', 'Out for Delivery', 'Delivered', 'Cancelled'
  final DateTime createdAt;
  final DateTime estimatedDeliveryTime;
  final String? deliveryInstructions;
  final String? cancellationReason;

  OrderModel({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.items,
    required this.subtotal,
    this.deliveryFee = 35.0,
    this.packagingFee = 15.0,
    this.taxes = 0.0,
    this.discountAmount = 0.0,
    this.appliedCouponCode,
    required this.totalAmount,
    this.paymentMethod = 'Cash on Delivery',
    this.paymentStatus = 'Pending',
    this.status = 'Placed',
    DateTime? createdAt,
    DateTime? estimatedDeliveryTime,
    this.deliveryInstructions,
    this.cancellationReason,
  })  : createdAt = createdAt ?? DateTime.now(),
        estimatedDeliveryTime = estimatedDeliveryTime ??
            DateTime.now().add(const Duration(minutes: 30));

  bool get isActive =>
      status != 'Delivered' && status != 'Cancelled';

  int get statusStepIndex {
    switch (status) {
      case 'Placed':
        return 0;
      case 'Confirmed':
        return 1;
      case 'Preparing':
        return 2;
      case 'Out for Delivery':
        return 3;
      case 'Delivered':
        return 4;
      case 'Cancelled':
        return -1;
      default:
        return 0;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryAddress': deliveryAddress.toMap(),
      'items': items.map((i) => i.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'packagingFee': packagingFee,
      'taxes': taxes,
      'discountAmount': discountAmount,
      'appliedCouponCode': appliedCouponCode,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'estimatedDeliveryTime': estimatedDeliveryTime.toIso8601String(),
      'deliveryInstructions': deliveryInstructions,
      'cancellationReason': cancellationReason,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return OrderModel(
      id: id ?? map['id'] ?? '',
      userId: map['userId'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      deliveryAddress: AddressModel.fromMap(
          Map<String, dynamic>.from(map['deliveryAddress'] ?? {})),
      items: (map['items'] as List<dynamic>?)
              ?.map((item) =>
                  OrderItemSnapshot.fromMap(Map<String, dynamic>.from(item)))
              .toList() ??
          [],
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 35.0,
      packagingFee: (map['packagingFee'] as num?)?.toDouble() ?? 15.0,
      taxes: (map['taxes'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (map['discountAmount'] as num?)?.toDouble() ?? 0.0,
      appliedCouponCode: map['appliedCouponCode'],
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: map['paymentMethod'] ?? 'Cash on Delivery',
      paymentStatus: map['paymentStatus'] ?? 'Pending',
      status: map['status'] ?? 'Placed',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      estimatedDeliveryTime: map['estimatedDeliveryTime'] != null
          ? DateTime.tryParse(map['estimatedDeliveryTime']) ?? DateTime.now()
          : DateTime.now().add(const Duration(minutes: 30)),
      deliveryInstructions: map['deliveryInstructions'],
      cancellationReason: map['cancellationReason'],
    );
  }

  OrderModel copyWith({
    String? status,
    String? paymentStatus,
    String? cancellationReason,
  }) {
    return OrderModel(
      id: id,
      userId: userId,
      customerName: customerName,
      customerPhone: customerPhone,
      deliveryAddress: deliveryAddress,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      packagingFee: packagingFee,
      taxes: taxes,
      discountAmount: discountAmount,
      appliedCouponCode: appliedCouponCode,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      status: status ?? this.status,
      createdAt: createdAt,
      estimatedDeliveryTime: estimatedDeliveryTime,
      deliveryInstructions: deliveryInstructions,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
}
