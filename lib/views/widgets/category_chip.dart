import 'package:flutter/material.dart';
import '../../models/category_model.dart'
;
class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoryData = CategoryData.categories[category]!;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 12, bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: isSelected ? LinearGradient(
              colors: categoryData.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ) : null,
            color: isSelected ? null : Colors.white.withOpacity(0.9),
            border: Border.all(
              color: isSelected ? Colors.transparent : categoryData.color,
              width: 2,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: categoryData.color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                categoryData.icon,
                color: isSelected ? Colors.white : categoryData.color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : categoryData.color,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 4),
                const Icon(Icons.check, color: Colors.white, size: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}