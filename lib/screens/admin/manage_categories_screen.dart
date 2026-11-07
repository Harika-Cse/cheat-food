import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../providers/admin_provider.dart';

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Categories'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: admin.categories.length,
        itemBuilder: (context, index) {
          final cat = admin.categories[index];
          final itemCount = admin.allFoods.where((f) => f.categoryId == cat.id).length;

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CachedNetworkImage(
                      imageUrl: cat.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppColors.surfaceWarm),
                      errorWidget: (_, __, ___) => const Icon(Icons.category_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(cat.iconEmoji, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            cat.name,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        cat.description,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$itemCount delicacies in menu',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWarm,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
