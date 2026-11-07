import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class RatingBadge extends StatelessWidget {
  final double rating;
  final int? count;

  const RatingBadge({
    super.key,
    required this.rating,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.mintGreen,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 13, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 2),
            Text(
              ' ($count)',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
