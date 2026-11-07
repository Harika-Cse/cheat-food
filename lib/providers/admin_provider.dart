import 'package:flutter/material.dart';
import '../models/food_item_model.dart';
import '../models/order_model.dart';
import '../models/category_model.dart';
import '../models/vendor_model.dart';
import '../services/firestore_service.dart';

class AdminProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<OrderModel> _allOrders = [];
  List<FoodItem> _allFoods = [];
  List<CategoryModel> _categories = [];
  List<VendorModel> _vendors = [];
  bool _isLoading = false;
  String? _statusMessage;

  List<OrderModel> get allOrders => _allOrders;
  List<FoodItem> get allFoods => _allFoods;
  List<CategoryModel> get categories => _categories;
  List<VendorModel> get vendors => _vendors;
  bool get isLoading => _isLoading;
  String? get statusMessage => _statusMessage;

  // Analytics Metrics
  double get totalRevenue =>
      _allOrders.where((o) => o.status != 'Cancelled').fold(0.0, (sum, o) => sum + o.totalAmount);

  int get totalOrderCount => _allOrders.length;
  int get pendingOrdersCount =>
      _allOrders.where((o) => o.status == 'Placed' || o.status == 'Confirmed' || o.status == 'Preparing').length;
  int get activeFoodsCount => _allFoods.where((f) => f.isAvailable).length;

  Future<void> loadAdminData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final ordersF = _firestoreService.getAllOrders();
      final foodsF = _firestoreService.getFoods();
      final catsF = _firestoreService.getCategories();
      final vendorsF = _firestoreService.getVendors();

      final results = await Future.wait([ordersF, foodsF, catsF, vendorsF]);
      _allOrders = results[0] as List<OrderModel>;
      _allFoods = results[1] as List<FoodItem>;
      _categories = results[2] as List<CategoryModel>;
      _vendors = results[3] as List<VendorModel>;
    } catch (e) {
      debugPrint('[AdminProvider Error] $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFoodItem(FoodItem food) async {
    _isLoading = true;
    notifyListeners();
    await _firestoreService.addFoodItem(food);
    _allFoods.insert(0, food);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateFoodItem(FoodItem food) async {
    _isLoading = true;
    notifyListeners();
    await _firestoreService.updateFoodItem(food);
    final idx = _allFoods.indexWhere((f) => f.id == food.id);
    if (idx != -1) {
      _allFoods[idx] = food;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteFoodItem(String foodId) async {
    _isLoading = true;
    notifyListeners();
    await _firestoreService.deleteFoodItem(foodId);
    _allFoods.removeWhere((f) => f.id == foodId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFoodAvailability(String foodId) async {
    await _firestoreService.toggleFoodAvailability(foodId);
    final idx = _allFoods.indexWhere((f) => f.id == foodId);
    if (idx != -1) {
      final cur = _allFoods[idx];
      _allFoods[idx] = cur.copyWith(isAvailable: !cur.isAvailable);
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _firestoreService.updateOrderStatus(orderId, newStatus);
    final idx = _allOrders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      _allOrders[idx] = _allOrders[idx].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  Future<void> seedInitialData() async {
    _isLoading = true;
    _statusMessage = 'Seeding initial Indian street food data...';
    notifyListeners();

    await _firestoreService.seedInitialDataToFirestore();
    await loadAdminData();

    _statusMessage = 'Initial database successfully populated!';
    _isLoading = false;
    notifyListeners();
  }
}
