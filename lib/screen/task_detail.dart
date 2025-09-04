import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/taskmodel.dart';
import '../providers/taskprovider.dart';
import '../widgets/textfile.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TextEditingController _titleController;
  late FocusNode _focusNode;
  bool _canSave = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _saveTitle() async {
    final provider = context.read<TaskProvider>();
    final newTitle = _titleController.text.trim();
    if (newTitle.isEmpty) return;
    widget.task.title = newTitle;
    await provider.updateTask(widget.task);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Task updated')));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.check_mark),
            onPressed: _canSave ? _saveTitle : null,
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TaskTextField(
                  controller: _titleController,
                  focusNode: _focusNode,
                  onChanged: (value) {
                    setState(() {
                      _canSave = value.trim().isNotEmpty;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
