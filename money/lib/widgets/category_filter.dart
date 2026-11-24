import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../data/categories.dart';

class CategoryFilter extends StatelessWidget {
  final Category? selectedCategory;
  final ValueChanged<Category?> onSelected;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: const Text('Բոլորը'),
                selected: selectedCategory == null,
                onSelected: (_) => onSelected(null),
              ),
            );
          }

          final category = categories[index - 1];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text('${category.emoji} ${category.title}'),
              selected: selectedCategory == category,
              onSelected: (_) => onSelected(category),
            ),
          );
        },
      ),
    );
  }
}
