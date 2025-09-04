import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/taskprovider.dart';
import '../models/taskmodel.dart';
import '../screen/task_detail.dart';
import '../widgets/weekwidgets.dart';
import '../widgets/month.dart';
import '../widgets/taskwidget.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  List<DateTime> _weekDates(DateTime anchor) {
    final start = anchor.subtract(Duration(days: anchor.weekday % 7));
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dates = _weekDates(_selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.xmark, size: 26),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Calendar',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedDate.day.toString().padLeft(2, '0')} ${getMonthName(_selectedDate.month)}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.black.withValues(alpha: 0.35),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            WeekWidget(
              dates: dates,
              selectedDate: _selectedDate,
              onDateSelected: (d) => setState(() => _selectedDate = d),
            ),

            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, provider, _) {
                  final tasksForDay = provider.tasks.where((t) {
                    final dt = DateTime.tryParse(t.date);
                    if (dt == null) return false;
                    return _isSameDate(dt, _selectedDate);
                  }).toList();

                  final Map<int, List<Task>> hourToTasks = {};
                  for (final t in tasksForDay) {
                    final dt = DateTime.tryParse(t.date);
                    if (dt == null) continue;
                    hourToTasks.putIfAbsent(dt.hour, () => []).add(t);
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: 24,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final hour = i;
                      final label = _formatHour(hour);
                      final items = hourToTasks[hour] ?? const <Task>[];

                      final sorted = [...items]
                        ..sort((a, b) {
                          final da =
                              DateTime.tryParse(a.date ?? '') ?? DateTime(0);
                          final db =
                              DateTime.tryParse(b.date ?? '') ?? DateTime(0);
                          return da.minute.compareTo(db.minute);
                        });
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 48,
                            child: Text(
                              label,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final task in sorted) ...[
                                  Dismissible(
                                    key: ValueKey(
                                      'cal_task_${task.id ?? task.title}_$hour',
                                    ),
                                    direction: DismissDirection.endToStart,
                                    confirmDismiss: (direction) async {
                                      final result = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Delete task?'),
                                          content: Text(
                                            'Are you sure you want to delete "${task.title}"?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(true),
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                      return result ?? false;
                                    },
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFE9E9),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Icon(
                                        CupertinoIcons.trash,
                                        color: Colors.red,
                                      ),
                                    ),
                                    onDismissed: (_) async {
                                      final provider = context
                                          .read<TaskProvider>();
                                      if (task.id != null) {
                                        await provider.deleteTask(task.id!);
                                      }
                                    },
                                    child: (() {
                                      final colors = _categoryColors(
                                        task.priority,
                                      );
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  TaskDetailPage(task: task),
                                            ),
                                          );
                                        },
                                        child: TaskWidget(
                                          title: task.title,
                                          bg: colors.$1,
                                          dot: colors.$2,
                                        ),
                                      );
                                    })(),
                                  ),
                                ],
                                Container(
                                  height: 1,
                                  color: Colors.black.withValues(alpha: 0.06),
                                  margin: const EdgeInsets.only(top: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  (Color, Color) _categoryColors(String priority) {
    switch (priority.toUpperCase()) {
      case 'WORK':
        return (const Color(0xFFF0FFF6), const Color(0xFF3AD06B));
      case 'MENTAL HEALTH':
        return (const Color(0xFFF7EFFA), const Color(0xFFB05CC2));
      case 'HEALTH':
        return (const Color(0xFFF7EFFA), const Color(0xFF5E77FF));
      case 'OTHER':
      default:
        return (const Color(0xFFEFF2FF), const Color(0xFFB0BEC5));
    }
  }

  String _formatHour(int hour24) {
    final padded = hour24.toString().padLeft(2, '0');
    return '$padded:00';
  }
}
