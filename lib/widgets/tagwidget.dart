import 'package:flutter/material.dart';

class Tags extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final void Function(String) onSelected;

  const Tags({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        final isSelected = selectedItem == item;
        return ChoiceChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (v) => onSelected(item),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
          selectedColor: const Color(0xFF2E2929),
          backgroundColor: const Color(0xFFE9E9E9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      }).toList(),
    );
  }
}
