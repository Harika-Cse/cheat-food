import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class VegNonVegBadge extends StatelessWidget {
  final bool isVeg;
  final double size;

  const VegNonVegBadge({
    super.key,
    required this.isVeg,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    final color = isVeg ? AppColors.veg : AppColors.nonVeg;

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
