import 'package:flutter/material.dart';
import '../models/food_item_model.dart';
import '../services/mock_data_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final MockDataService _mock = MockDataService();
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  FavoritesProvider() {
    _favoriteIds.addAll(_mock.favoriteIds);
  }

  bool isFavorite(String foodId) => _favoriteIds.contains(foodId);

  void toggleFavorite(FoodItem food) {
    if (_favoriteIds.contains(food.id)) {
      _favoriteIds.remove(food.id);
      _mock.toggleFavorite(food.id);
    } else {
      _favoriteIds.add(food.id);
      _mock.toggleFavorite(food.id);
    }
    notifyListeners();
  }

  List<FoodItem> getFavoriteFoods(List<FoodItem> allFoods) {
    return allFoods.where((f) => _favoriteIds.contains(f.id)).toList();
  }
}
