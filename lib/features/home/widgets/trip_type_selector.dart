import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TripTypeSelector extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const TripTypeSelector({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final types = ['One way', 'Round', 'Multi-city'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: types.map((type) {
        final isSelected = selected == type;
        return GestureDetector(
          onTap: () => onSelect(type),
          child: Chip(
            label: Text(type),
            backgroundColor:
                isSelected ? AppColors.primary : Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.primary,
            ),
          ),
        );
      }).toList(),
    );
  }
}
