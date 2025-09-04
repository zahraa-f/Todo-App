import 'package:flutter/material.dart';

class TaskTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onChanged;
  final String? hintText;

  const TaskTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          maxLines: null,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText ?? 'Write a new task',
            border: InputBorder.none,
          ),
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.black.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
