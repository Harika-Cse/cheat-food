import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/food_item_model.dart';
import '../models/vendor_model.dart';
import '../models/review_model.dart';
import '../services/firestore_service.dart';

class FoodProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<CategoryModel> _categories = [];
  List<VendorModel> _vendors = [];
  List<FoodItem> _allFoods = [];
  final List<FoodItem> _recentlyViewed = [];

  bool _isLoading = false;
  String? _selectedCategoryId; // null means 'All'
  String _searchQuery = '';
  bool _filterVegOnly = false;
  String? _filterSpiceLevel; // null or Mild / Medium / Fiery Spicy
  double? _filterMaxPrice;
  double? _filterMinRating;
  String _sortBy = 'Popularity'; // 'Popularity', 'Rating', 'Price: Low to High', 'Price: High to Low'

  // Getters
  List<CategoryModel> get categories => _categories;
  List<VendorModel> get vendors => _vendors;
  List<FoodItem> get allFoods => _allFoods;
  List<FoodItem> get recentlyViewed => _recentlyViewed;
  bool get isLoading => _isLoading;
  String? get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  bool get filterVegOnly => _filterVegOnly;
  String? get filterSpiceLevel => _filterSpiceLevel;
  double? get filterMaxPrice => _filterMaxPrice;
  double? get filterMinRating => _filterMinRating;
  String get sortBy => _sortBy;

  // Filtered foods for Home screen (by selected category)
  List<FoodItem> get homeDisplayFoods {
    if (_selectedCategoryId == null || _selectedCategoryId!.isEmpty) {
      return _allFoods;
    }
    return _allFoods
        .where((f) => f.categoryId == _selectedCategoryId)
        .toList();
  }

  // Section collections
  List<FoodItem> get trendingFoods =>
      _allFoods.where((f) => f.isTrending && f.isAvailable).toList();

  List<FoodItem> get bestSellingFoods =>
      _allFoods.where((f) => f.isBestSeller && f.isAvailable).toList();

  List<FoodItem> get recommendedFoods =>
      _allFoods.where((f) => f.isRecommended && f.isAvailable).toList();

  // Search filtered foods
  List<FoodItem> get searchResults {
    List<FoodItem> results = List.from(_allFoods);

    // 1. Text Query (Food Name, Category, or Vendor)
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      results = results.where((f) {
        final matchesName = f.name.toLowerCase().contains(q);
        final matchesCat = f.categoryName.toLowerCase().contains(q);
        final matchesVendor = f.vendorName.toLowerCase().contains(q);
        final matchesDesc = f.description.toLowerCase().contains(q);
        return matchesName || matchesCat || matchesVendor || matchesDesc;
      }).toList();
    }

    // 2. Veg Only filter
    if (_filterVegOnly) {
      results = results.where((f) => f.isVeg).toList();
    }

    // 3. Category filter
    if (_selectedCategoryId != null && _selectedCategoryId!.isNotEmpty) {
      results = results.where((f) => f.categoryId == _selectedCategoryId).toList();
    }

    // 4. Spice Level filter
    if (_filterSpiceLevel != null && _filterSpiceLevel!.isNotEmpty) {
      results = results.where((f) => f.spiceLevel == _filterSpiceLevel).toList();
    }

    // 5. Max Price filter
    if (_filterMaxPrice != null && _filterMaxPrice! > 0) {
      results = results.where((f) => f.effectivePrice <= _filterMaxPrice!).toList();
    }

    // 6. Min Rating filter
    if (_filterMinRating != null) {
      results = results.where((f) => f.rating >= _filterMinRating!).toList();
    }

    // 7. Sorting
    switch (_sortBy) {
      case 'Rating':
        results.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Price: Low to High':
        results.sort((a, b) => a.effectivePrice.compareTo(b.effectivePrice));
        break;
      case 'Price: High to Low':
        results.sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice));
        break;
      case 'Popularity':
      default:
        results.sort((a, b) => b.ratingCount.compareTo(a.ratingCount));
        break;
    }

    return results;
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final catsFuture = _firestoreService.getCategories();
      final vendorsFuture = _firestoreService.getVendors();
      final foodsFuture = _firestoreService.getFoods();

      final results = await Future.wait([catsFuture, vendorsFuture, foodsFuture]);
      _categories = results[0] as List<CategoryModel>;
      _vendors = results[1] as List<VendorModel>;
      _allFoods = results[2] as List<FoodItem>;
    } catch (e) {
      debugPrint('[FoodProvider loadInitialData Error] $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String? categoryId) {
    if (_selectedCategoryId == categoryId) {
      _selectedCategoryId = null; // Toggle off to show All
    } else {
      _selectedCategoryId = categoryId;
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setVegOnlyFilter(bool value) {
    _filterVegOnly = value;
    notifyListeners();
  }

  void setSpiceLevelFilter(String? level) {
    _filterSpiceLevel = level;
    notifyListeners();
  }

  void setMaxPriceFilter(double? price) {
    _filterMaxPrice = price;
    notifyListeners();
  }

  void setMinRatingFilter(double? rating) {
    _filterMinRating = rating;
    notifyListeners();
  }

  void setSortBy(String sortOption) {
    _sortBy = sortOption;
    notifyListeners();
  }

  void clearSearchFilters() {
    _searchQuery = '';
    _filterVegOnly = false;
    _filterSpiceLevel = null;
    _filterMaxPrice = null;
    _filterMinRating = null;
    _sortBy = 'Popularity';
    notifyListeners();
  }

  void recordRecentlyViewed(FoodItem item) {
    _recentlyViewed.removeWhere((f) => f.id == item.id);
    _recentlyViewed.insert(0, item);
    if (_recentlyViewed.length > 8) {
      _recentlyViewed.removeLast();
    }
    notifyListeners();
  }

  Future<List<ReviewModel>> getReviews(String foodId) async {
    return _firestoreService.getReviews(foodId);
  }

  Future<void> submitReview(ReviewModel review) async {
    await _firestoreService.addReview(review);
    notifyListeners();
  }
}
