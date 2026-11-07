import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/food_item_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../constants/app_colors.dart';
import '../utils/currency_formatter.dart';
import 'veg_nonveg_badge.dart';
import 'spice_level_badge.dart';
import 'rating_badge.dart';

class FoodCardCompact extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;

  const FoodCardCompact({
    super.key,
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final favProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favProvider.isFavorite(food.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Food Image Stack
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 95,
                        height: 95,
                        child: CachedNetworkImage(
                          imageUrl: food.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.surfaceWarm,
                            child: const Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.surfaceWarm,
                            child: const Icon(
                              Icons.fastfood_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: VegNonVegBadge(isVeg: food.isVeg, size: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              food.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => favProvider.toggleFavorite(food),
                            child: Icon(
                              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 19,
                              color: isFav ? AppColors.secondary : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        food.vendorName,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          RatingBadge(rating: food.rating),
                          const SizedBox(width: 8),
                          SpiceLevelBadge(level: food.spiceLevel, compact: true),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                CurrencyFormatter.format(food.effectivePrice),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (food.hasDiscount) ...[
                                const SizedBox(width: 6),
                                Text(
                                  CurrencyFormatter.format(food.price),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade400,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              cartProvider.addItem(food: food);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added ${food.name} to cart!'),
                                  duration: const Duration(milliseconds: 1400),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColors.primaryDark,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceWarm,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.primary, width: 1.2),
                              ),
                              child: const Text(
                                'ADD',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
