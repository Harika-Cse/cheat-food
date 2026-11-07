import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/food_provider.dart';
import '../../widgets/food_card_compact.dart';
import '../../widgets/empty_state_widget.dart';
import '../food_details/food_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final foodProvider = Provider.of<FoodProvider>(context);

    final favoriteFoods = favProvider.getFavoriteFoods(foodProvider.allFoods);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Favorites'),
        elevation: 0,
      ),
      body: favoriteFoods.isEmpty
          ? const EmptyStateWidget(
              emoji: '❤️',
              title: 'No Favorites Saved Yet',
              message: 'Heart your favorite street foods like Pani Puri, Pav Bhaji, or Momos to easily reorder them anytime!',
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: favoriteFoods.length,
              itemBuilder: (context, index) {
                final food = favoriteFoods[index];
                return FoodCardCompact(
                  food: food,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FoodDetailsScreen(food: food),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
