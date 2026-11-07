import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final bool readOnly;
  final String hintText;

  const SearchBarWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
    this.onFilterTap,
    this.readOnly = false,
    this.hintText = 'Search Pani Puri, Vada Pav, Chaat, Vendors...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          suffixIcon: onFilterTap != null
              ? IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWarm,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  onPressed: onFilterTap,
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}
