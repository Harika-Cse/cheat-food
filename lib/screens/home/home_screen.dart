import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/food_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/delivery_location_bar.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/banner_slider.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/food_card.dart';
import '../../widgets/food_card_compact.dart';
import '../food_details/food_details_screen.dart';
import '../search/search_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/saved_addresses_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Consumer<LocationProvider>(
          builder: (context, loc, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Choose Delivery Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const Divider(),
                    if (loc.addresses.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('No saved addresses yet.'),
                      )
                    else
                      ...loc.addresses.map((addr) {
                        final isSelected = loc.selectedAddress?.id == addr.id;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            addr.label == 'Home'
                                ? Icons.home_rounded
                                : (addr.label == 'Work' ? Icons.work_rounded : Icons.location_on_rounded),
                            color: isSelected ? AppColors.primary : Colors.grey.shade600,
                          ),
                          title: Text(
                            addr.label,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            '${addr.houseFlatBlock}, ${addr.areaColonyStreet}, ${addr.city}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                              : null,
                          onTap: () {
                            loc.selectAddress(addr);
                            Navigator.pop(ctx);
                          },
                        );
                      }),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.add_location_alt_outlined),
                        label: const Text('Manage or Add New Address'),
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SavedAddressesScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 16,
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('🍲', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CHEAT FOOD',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Indian Street Food Only',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Cart Icon with badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => foodProvider.loadInitialData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Location Selector Bar
              DeliveryLocationBar(
                onLocationTap: () => _showAddressBottomSheet(context),
              ),

              // Interactive Search Bar (tapping opens Search Screen)
              SearchBarWidget(
                readOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
                onFilterTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen(autoOpenFilter: true)),
                  );
                },
              ),
              const SizedBox(height: 6),

              // Promotional Banner Slider
              BannerSlider(
                onCouponTap: (code) {
                  cartProvider.applyCoupon(code);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Coupon "$code" copied & applied!'),
                      backgroundColor: AppColors.primaryDark,
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),

              // Street Food Categories Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Street Food Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (foodProvider.selectedCategoryId != null)
                      GestureDetector(
                        onTap: () => foodProvider.selectCategory(null),
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Categories Horizontal List
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: foodProvider.categories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final isAllSelected = foodProvider.selectedCategoryId == null;
                      return GestureDetector(
                        onTap: () => foodProvider.selectCategory(null),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isAllSelected ? AppColors.primary : AppColors.surfaceWarm,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isAllSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.15),
                              width: 1.2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '🇮🇳 All Street Foods',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isAllSelected ? FontWeight.w700 : FontWeight.w600,
                                color: isAllSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    final cat = foodProvider.categories[index - 1];
                    final isSelected = foodProvider.selectedCategoryId == cat.id;
                    return CategoryChip(
                      category: cat,
                      isSelected: isSelected,
                      onTap: () => foodProvider.selectCategory(cat.id),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Trending Street Foods
              _buildSectionHeader(
                context,
                title: '🔥 Trending Street Foods',
                subtitle: 'Most craved this week in your city',
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 275,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: foodProvider.trendingFoods.length,
                  itemBuilder: (context, index) {
                    final item = foodProvider.trendingFoods[index];
                    return FoodCard(
                      food: item,
                      onTap: () {
                        foodProvider.recordRecentlyViewed(item);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FoodDetailsScreen(food: item),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Best-Selling Foods
              _buildSectionHeader(
                context,
                title: '⭐ Best-Selling Indian Delicacies',
                subtitle: 'All-time crowd favorites with 4.8+ ratings',
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 275,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: foodProvider.bestSellingFoods.length,
                  itemBuilder: (context, index) {
                    final item = foodProvider.bestSellingFoods[index];
                    return FoodCard(
                      food: item,
                      onTap: () {
                        foodProvider.recordRecentlyViewed(item);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FoodDetailsScreen(food: item),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Recently Viewed (if any)
              if (foodProvider.recentlyViewed.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  title: '👀 Recently Viewed',
                  subtitle: 'Jump back to items you were checking out',
                ),
                const SizedBox(height: 10),
                ...foodProvider.recentlyViewed.take(3).map((item) {
                  return FoodCardCompact(
                    food: item,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FoodDetailsScreen(food: item),
                        ),
                      );
                    },
                  );
                }),
                const SizedBox(height: 16),
              ],

              // Recommended For You
              _buildSectionHeader(
                context,
                title: '✨ Recommended For You',
                subtitle: 'Handpicked street snacks matching your taste',
              ),
              const SizedBox(height: 10),
              ...foodProvider.recommendedFoods.map((item) {
                return FoodCardCompact(
                  food: item,
                  onTap: () {
                    foodProvider.recordRecentlyViewed(item);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FoodDetailsScreen(food: item),
                      ),
                    );
                  },
                );
              }),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
