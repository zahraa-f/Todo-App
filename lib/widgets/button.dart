import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final bool canSave;
  final bool saving;
  final VoidCallback onSave;
  final VoidCallback onPickDate;
  final bool hasDate;

  const ButtonWidget({
    super.key,
    required this.canSave,
    required this.saving,
    required this.onSave,
    required this.onPickDate,
    required this.hasDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPickDate,
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: hasDate ? const Color(0xFF2E2929) : const Color(0xFFE9E9E9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                CupertinoIcons.calendar,
                color: hasDate ? Colors.white : Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Opacity(
              opacity: canSave ? 1.0 : 0.5,
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: canSave ? onSave : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE9E9E9),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
