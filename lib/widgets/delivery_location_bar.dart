import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../constants/app_colors.dart';

class DeliveryLocationBar extends StatelessWidget {
  final VoidCallback onLocationTap;

  const DeliveryLocationBar({
    super.key,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final activeAddress = locationProvider.selectedAddress;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceWarm,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: onLocationTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        activeAddress?.label ?? 'Delivery Location',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  Text(
                    activeAddress != null
                        ? '${activeAddress.houseFlatBlock}, ${activeAddress.areaColonyStreet}'
                        : 'Tap to select delivery address',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
