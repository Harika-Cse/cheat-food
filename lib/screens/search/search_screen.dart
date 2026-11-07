import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../providers/food_provider.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/food_card_compact.dart';
import '../../widgets/empty_state_widget.dart';
import '../food_details/food_details_screen.dart';

class SearchScreen extends StatefulWidget {
  final bool autoOpenFilter;

  const SearchScreen({super.key, this.autoOpenFilter = false});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final foodProvider = Provider.of<FoodProvider>(context, listen: false);
    _searchController.text = foodProvider.searchQuery;

    if (widget.autoOpenFilter) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showFilterModal(context);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Consumer<FoodProvider>(
          builder: (context, foodProv, child) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter & Sort Street Foods',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          foodProv.clearSearchFilters();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Reset All'),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Veg Only Switch
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Pure Veg Only (Green Dot)', style: TextStyle(fontWeight: FontWeight.w700)),
                    value: foodProv.filterVegOnly,
                    activeColor: AppColors.veg,
                    onChanged: (val) => foodProv.setVegOnlyFilter(val),
                  ),

                  const SizedBox(height: 12),

                  // Spice Level Filter
                  const Text('Spice Level', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildChip(
                        label: 'All Spices',
                        isSelected: foodProv.filterSpiceLevel == null,
                        onTap: () => foodProv.setSpiceLevelFilter(null),
                      ),
                      ...AppConstants.spiceLevels.map((lvl) {
                        return _buildChip(
                          label: lvl,
                          isSelected: foodProv.filterSpiceLevel == lvl,
                          onTap: () => foodProv.setSpiceLevelFilter(lvl),
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Sort By
                  const Text('Sort By', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Popularity',
                      'Rating',
                      'Price: Low to High',
                      'Price: High to Low',
                    ].map((sortOption) {
                      return _buildChip(
                        label: sortOption,
                        isSelected: foodProv.sortBy == sortOption,
                        onTap: () => foodProv.setSortBy(sortOption),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Min Rating
                  const Text('Rating', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildChip(
                        label: 'Any Rating',
                        isSelected: foodProv.filterMinRating == null,
                        onTap: () => foodProv.setMinRatingFilter(null),
                      ),
                      _buildChip(
                        label: '⭐ 4.5 & Above',
                        isSelected: foodProv.filterMinRating == 4.5,
                        onTap: () => foodProv.setMinRatingFilter(4.5),
                      ),
                      _buildChip(
                        label: '⭐ 4.8 & Above',
                        isSelected: foodProv.filterMinRating == 4.8,
                        onTap: () => foodProv.setMinRatingFilter(4.8),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Apply Filters (${foodProv.searchResults.length} Foods Found)',
                        style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceWarm,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final results = foodProvider.searchResults;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search & Explore'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: AppColors.primary),
            onPressed: () => _showFilterModal(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Input Bar
          SearchBarWidget(
            controller: _searchController,
            onChanged: (val) => foodProvider.setSearchQuery(val),
            onFilterTap: () => _showFilterModal(context),
            hintText: 'Search food, vendor (e.g. Sharma, Sardar, Dosa)...',
          ),

          // Active filter tags row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${results.length} Street Foods Found',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                if (foodProvider.filterVegOnly ||
                    foodProvider.filterSpiceLevel != null ||
                    foodProvider.filterMinRating != null ||
                    foodProvider.searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      foodProvider.clearSearchFilters();
                    },
                    child: const Text(
                      'Clear Filters',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Results list or Empty State
          Expanded(
            child: results.isEmpty
                ? EmptyStateWidget(
                    emoji: '🔍',
                    title: 'No Street Foods Match',
                    message: 'We could not find street food matching your query or active filters. Try searching for "Pani Puri", "Vada Pav", or reset filters.',
                    buttonText: 'Reset Filters',
                    onButtonPressed: () {
                      _searchController.clear();
                      foodProvider.clearSearchFilters();
                    },
                  )
                : ListView.builder(
                    itemCount: results.length,
                    padding: const EdgeInsets.only(bottom: 20),
                    itemBuilder: (context, index) {
                      final food = results[index];
                      return FoodCardCompact(
                        food: food,
                        onTap: () {
                          foodProvider.recordRecentlyViewed(food);
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
          ),
        ],
      ),
    );
  }
}
