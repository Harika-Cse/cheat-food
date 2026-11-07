import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SpiceLevelBadge extends StatelessWidget {
  final String level;
  final bool compact;

  const SpiceLevelBadge({
    super.key,
    required this.level,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String peppers;

    switch (level) {
      case 'Fiery Spicy':
        bg = const Color(0xFFFFEBEE);
        text = AppColors.secondary;
        peppers = '🌶️🌶️🌶️';
        break;
      case 'Medium':
        bg = const Color(0xFFFFF3E0);
        text = AppColors.primaryDark;
        peppers = '🌶️🌶️';
        break;
      case 'Mild':
      default:
        bg = const Color(0xFFE8F5E9);
        text = AppColors.mintGreen;
        peppers = '🌶️';
        break;
    }

    if (compact) {
      return Text(
        peppers,
        style: const TextStyle(fontSize: 11),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(peppers, style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 4),
          Text(
            level,
            style: TextStyle(
              color: text,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
