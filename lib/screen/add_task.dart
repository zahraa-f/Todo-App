import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/taskmodel.dart';
import '../providers/taskprovider.dart';
import '../widgets/textfile.dart';
import '../widgets/tagwidget.dart';
import '../widgets/button.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _saving = false;
  final List<String> _categories = const [
    'HEALTH',
    'WORK',
    'MENTAL HEALTH',
    'OTHERS',
  ];
  String? _selectedCategory;
  final List<String> _priorities = const ['HIGH', 'MEDIUM', 'LOW'];
  String? _selectedPriority;

  @override
  void dispose() {
    _controller.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    // First pick date
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);

      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() => _selectedTime = pickedTime);
      }
    }
  }

  Future<void> _save() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final provider = context.read<TaskProvider>();
      DateTime? dateTime;
      if (_selectedDate != null) {
        if (_selectedTime != null) {
          dateTime = DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _selectedTime!.hour,
            _selectedTime!.minute,
          );
        } else {
          dateTime = DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
          );
        }
      }

      final task = Task(
        title: _controller.text.trim(),
        priority: _selectedPriority ?? 'MEDIUM',
        category: _selectedCategory ?? 'OTHERS',
        date: (dateTime ?? DateTime.now()).toIso8601String(),
      );
      await provider.addTask(task);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _controller.text.trim().isNotEmpty && !_saving;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    icon: const Icon(CupertinoIcons.xmark, size: 26),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            Expanded(
              child: TaskTextField(
                controller: _controller,
                focusNode: _textFocusNode,
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (_controller.text.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Tags(
                  items: _categories,
                  selectedItem: _selectedCategory,
                  onSelected: (c) {
                    setState(
                      () =>
                          _selectedCategory = _selectedCategory == c ? null : c,
                    );
                    _textFocusNode.requestFocus();
                  },
                ),
              ),
            if (_controller.text.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Tags(
                  items: _priorities,
                  selectedItem: _selectedPriority,
                  onSelected: (p) {
                    setState(() => _selectedPriority = p);
                    _textFocusNode.requestFocus();
                  },
                ),
              ),

            ButtonWidget(
              canSave: canSave,
              saving: _saving,
              onSave: _save,
              onPickDate: _pickDateTime,
              hasDate: _selectedDate != null || _selectedTime != null,
            ),
          ],
        ),
      ),
    );
  }
}
