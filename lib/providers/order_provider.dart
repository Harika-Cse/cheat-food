import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/order_model.dart';
import '../models/address_model.dart';
import '../models/cart_item_model.dart';
import '../models/coupon_model.dart';
import '../services/firestore_service.dart';
import '../constants/app_constants.dart';

class OrderProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  OrderModel? _lastPlacedOrder;
  String? _errorMessage;

  List<OrderModel> get orders => _orders;
  List<OrderModel> get activeOrders =>
      _orders.where((o) => o.isActive).toList();
  List<OrderModel> get pastOrders =>
      _orders.where((o) => !o.isActive).toList();
  bool get isLoading => _isLoading;
  OrderModel? get lastPlacedOrder => _lastPlacedOrder;
  String? get errorMessage => _errorMessage;

  Future<void> fetchOrders(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _firestoreService.getOrdersForUser(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<OrderModel?> placeOrder({
    required String userId,
    required String customerName,
    required String customerPhone,
    required AddressModel deliveryAddress,
    required List<CartItemModel> cartItems,
    required double subtotal,
    required double deliveryFee,
    required double packagingFee,
    required double taxes,
    required double discountAmount,
    CouponModel? appliedCoupon,
    required double totalAmount,
    required String paymentMethod,
    String? deliveryInstructions,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final orderNumber = const Uuid().v4().substring(0, 6).toUpperCase();
      final orderId = 'CF-$orderNumber';

      final itemSnapshots = cartItems
          .map((item) => OrderItemSnapshot.fromCartItem(item))
          .toList();

      final newOrder = OrderModel(
        id: orderId,
        userId: userId,
        customerName: customerName,
        customerPhone: customerPhone,
        deliveryAddress: deliveryAddress,
        items: itemSnapshots,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        packagingFee: packagingFee,
        taxes: taxes,
        discountAmount: discountAmount,
        appliedCouponCode: appliedCoupon?.code,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        paymentStatus: paymentMethod == 'Cash on Delivery' ? 'Pending' : 'Paid',
        status: AppConstants.statusPlaced,
        createdAt: DateTime.now(),
        estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 30)),
        deliveryInstructions: deliveryInstructions,
      );

      final savedOrder = await _firestoreService.placeOrder(newOrder);
      _orders.insert(0, savedOrder);
      _lastPlacedOrder = savedOrder;
      _isLoading = false;
      notifyListeners();
      return savedOrder;
    } catch (e) {
      _errorMessage = 'Failed to place order: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firestoreService.updateOrderStatus(orderId, AppConstants.statusCancelled);
      final idx = _orders.indexWhere((o) => o.id == orderId);
      if (idx != -1) {
        _orders[idx] = _orders[idx].copyWith(
          status: AppConstants.statusCancelled,
          cancellationReason: reason,
        );
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Demonstration tool: Advance order status sequentially
  Future<void> advanceDemoOrderStatus(String orderId) async {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;

    final currentStatus = _orders[idx].status;
    String nextStatus;
    switch (currentStatus) {
      case AppConstants.statusPlaced:
        nextStatus = AppConstants.statusConfirmed;
        break;
      case AppConstants.statusConfirmed:
        nextStatus = AppConstants.statusPreparing;
        break;
      case AppConstants.statusPreparing:
        nextStatus = AppConstants.statusOutForDelivery;
        break;
      case AppConstants.statusOutForDelivery:
        nextStatus = AppConstants.statusDelivered;
        break;
      default:
        return;
    }

    await _firestoreService.updateOrderStatus(orderId, nextStatus);
    _orders[idx] = _orders[idx].copyWith(status: nextStatus);
    if (_lastPlacedOrder?.id == orderId) {
      _lastPlacedOrder = _orders[idx];
    }
    notifyListeners();
  }

  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return _lastPlacedOrder?.id == orderId ? _lastPlacedOrder : null;
    }
  }
}
