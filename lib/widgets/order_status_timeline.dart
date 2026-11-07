import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class OrderStatusTimeline extends StatelessWidget {
  final String currentStatus;

  const OrderStatusTimeline({
    super.key,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (currentStatus == AppConstants.statusCancelled) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.error, width: 1),
        ),
        child: const Row(
          children: [
            Icon(Icons.cancel_rounded, color: AppColors.error, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Cancelled',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.error,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'This order was cancelled. Any prepaid amount will be refunded within 24 hours.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final steps = [
      {'title': 'Order Placed', 'desc': 'Received by vendor', 'icon': Icons.receipt_long_rounded},
      {'title': 'Confirmed', 'desc': 'Accepted by stall', 'icon': Icons.check_circle_outline_rounded},
      {'title': 'Preparing', 'desc': 'Sizzling on tawa / kadai', 'icon': Icons.restaurant_rounded},
      {'title': 'Out for Delivery', 'desc': 'Rider is on the way', 'icon': Icons.delivery_dining_rounded},
      {'title': 'Delivered', 'desc': 'Enjoy your street feast!', 'icon': Icons.home_rounded},
    ];

    int activeStep = 0;
    switch (currentStatus) {
      case AppConstants.statusPlaced:
        activeStep = 0;
        break;
      case AppConstants.statusConfirmed:
        activeStep = 1;
        break;
      case AppConstants.statusPreparing:
        activeStep = 2;
        break;
      case AppConstants.statusOutForDelivery:
        activeStep = 3;
        break;
      case AppConstants.statusDelivered:
        activeStep = 4;
        break;
    }

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isCompleted = index < activeStep;
        final isCurrent = index == activeStep;
        final isUpcoming = index > activeStep;
        final isLast = index == steps.length - 1;

        Color iconColor;
        Color circleBg;
        if (isCompleted) {
          iconColor = Colors.white;
          circleBg = AppColors.mintGreen;
        } else if (isCurrent) {
          iconColor = Colors.white;
          circleBg = AppColors.primary;
        } else {
          iconColor = Colors.grey.shade400;
          circleBg = Colors.grey.shade200;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: circleBg,
                    shape: BoxShape.circle,
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check_rounded : (step['icon'] as IconData),
                    color: iconColor,
                    size: 20,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2.5,
                    height: 38,
                    color: isCompleted ? AppColors.mintGreen : Colors.grey.shade200,
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          step['title'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w700,
                            color: isUpcoming ? Colors.grey.shade400 : AppColors.textPrimary,
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceWarm,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.primary, width: 0.8),
                            ),
                            child: const Text(
                              'LIVE',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step['desc'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isUpcoming ? Colors.grey.shade400 : AppColors.textSecondary,
                      ),
                    ),
                    if (!isLast) const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
