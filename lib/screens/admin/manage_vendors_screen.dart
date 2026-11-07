import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../providers/admin_provider.dart';

class ManageVendorsScreen extends StatelessWidget {
  const ManageVendorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Street Stalls & Vendors'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: admin.vendors.length,
        itemBuilder: (context, index) {
          final vendor = admin.vendors[index];
          final itemCount = admin.allFoods.where((f) => f.vendorId == vendor.id).length;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
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
                    width: 70,
                    height: 70,
                    child: CachedNetworkImage(
                      imageUrl: vendor.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppColors.surfaceWarm),
                      errorWidget: (_, __, ___) => const Icon(Icons.storefront_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendor.name,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        vendor.speciality,
                        style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${vendor.locality}, ${vendor.city}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: AppColors.accent),
                          const SizedBox(width: 2),
                          Text(
                            '${vendor.rating} (${vendor.ratingCount} reviews)',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 8),
                          Text('• $itemCount items', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
