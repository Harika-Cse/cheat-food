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

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;
  final double width;

  const FoodCard({
    super.key,
    required this.food,
    required this.onTap,
    this.width = 220,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final favProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favProvider.isFavorite(food.id);

    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 14, bottom: 8, top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container with Badges
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: SizedBox(
                      height: 130,
                      width: double.infinity,
                      child: Hero(
                        tag: 'food_img_${food.id}',
                        child: CachedNetworkImage(
                          imageUrl: food.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.surfaceWarm,
                            child: const Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
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
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Veg/Non-veg Indicator
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          )
                        ],
                      ),
                      child: VegNonVegBadge(isVeg: food.isVeg, size: 14),
                    ),
                  ),

                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => favProvider.toggleFavorite(food),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            )
                          ],
                        ),
                        child: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 18,
                          color: isFav ? AppColors.secondary : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),

                  // Rating Badge
                  Positioned(
                    bottom: 8,
                    left: 10,
                    child: RatingBadge(rating: food.rating),
                  ),

                  // Preparation Time Tag
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer_outlined, size: 11, color: Colors.white),
                          const SizedBox(width: 3),
                          Text(
                            '${food.preparationTimeMinutes}m',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Content Details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vendor Name
                    Text(
                      food.vendorName,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Food Name
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Spice Level Badge
                    SpiceLevelBadge(level: food.spiceLevel),
                    const SizedBox(height: 8),

                    // Price & Add to Cart Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  const SizedBox(width: 5),
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
                          ],
                        ),

                        // Quick Add Button
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
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceWarm,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primary, width: 1.2),
                            ),
                            child: const Text(
                              'ADD',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
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
    );
  }
}
