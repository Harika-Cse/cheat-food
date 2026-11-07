import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../models/food_item_model.dart';
import '../../providers/admin_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/veg_nonveg_badge.dart';
import 'add_edit_food_screen.dart';

class ManageFoodsScreen extends StatelessWidget {
  const ManageFoodsScreen({super.key});

  void _confirmDelete(BuildContext context, AdminProvider admin, FoodItem food) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Food Item?'),
        content: Text('Are you sure you want to delete "${food.name}" from the street food menu?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              await admin.deleteFoodItem(food.id);
              if (context.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleted ${food.name}')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Food Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditFoodScreen()),
              );
            },
          ),
        ],
      ),
      body: admin.allFoods.isEmpty
          ? const Center(child: Text('No food items found.'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: admin.allFoods.length,
              itemBuilder: (context, index) {
                final food = admin.allFoods[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: CachedNetworkImage(
                            imageUrl: food.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: AppColors.surfaceWarm),
                            errorWidget: (_, __, ___) => const Icon(Icons.fastfood_rounded),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                VegNonVegBadge(isVeg: food.isVeg, size: 12),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    food.name,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${food.categoryName} • ${food.vendorName}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.format(food.price),
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),

                      // In Stock Toggle & Edit & Delete
                      Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                food.isAvailable ? 'In Stock' : 'Out',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: food.isAvailable ? AppColors.mintGreen : AppColors.error,
                                ),
                              ),
                              Switch(
                                value: food.isAvailable,
                                activeColor: AppColors.mintGreen,
                                onChanged: (val) {
                                  admin.toggleFoodAvailability(food.id);
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddEditFoodScreen(foodToEdit: food),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                                onPressed: () => _confirmDelete(context, admin, food),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditFoodScreen()),
          );
        },
      ),
    );
  }
}
