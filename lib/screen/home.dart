import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screen/add_task.dart';
import 'package:provider/provider.dart';
import '../providers/taskprovider.dart';
import '../screen/calendar.dart';
import '../models/taskmodel.dart';
import '../widgets/categorycard.dart';
import '../widgets/month.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, right: 4.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AddTaskPage()));
          },
          backgroundColor: const Color(0xFF2E2929),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(CupertinoIcons.add, color: Colors.white, size: 28),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: const [
            _Header(),
            SizedBox(height: 20),
            _CategoryGrid(),
            SizedBox(height: 20),
            _TasksFromProvider(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Today',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '  '),
                TextSpan(
                  text:
                      '${DateTime.now().day} ${getMonthName(DateTime.now().month)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black.withValues(alpha: 0.35),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const CalendarPage()));
          },
          child: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
            ),
            child: const Center(child: Icon(CupertinoIcons.calendar, size: 20)),
          ),
        ),
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid();

  int _getCategoryCount(List<Task> tasks, String category) {
    return tasks
        .where((task) => task.category.toUpperCase() == category.toUpperCase())
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / (size.height / 3);

    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final tasks = provider.tasks;

        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: aspectRatio,
          ),
          children: [
            CategoryCard(
              color: const Color(0xFFEFF2FF),
              icon: CupertinoIcons.heart_fill,
              iconColor: const Color(0xFF5E77FF),
              count: _getCategoryCount(tasks, 'HEALTH'),
              title: 'Health',
            ),
            CategoryCard(
              color: const Color(0xFFF0FFF6),
              icon: CupertinoIcons.square_fill,
              iconColor: const Color(0xFF3AD06B),
              count: _getCategoryCount(tasks, 'WORK'),
              title: 'Work',
            ),
            CategoryCard(
              color: const Color(0xFFF7EFFA),
              icon: CupertinoIcons.hand_thumbsup_fill,
              iconColor: const Color(0xFFB05CC2),
              count: _getCategoryCount(tasks, 'MENTAL HEALTH'),
              title: 'Mental Health',
            ),
            CategoryCard(
              color: const Color(0xFFF4F4F4),
              icon: CupertinoIcons.folder_fill,
              iconColor: const Color(0xFF9A9A9A),
              count: _getCategoryCount(tasks, 'OTHERS'),
              title: 'Others',
            ),
          ],
        );
      },
    );
  }
}

class _TasksFromProvider extends StatelessWidget {
  const _TasksFromProvider();

  Color _categoryBg(String category) {
    switch (category.toUpperCase()) {
      case 'WORK':
        return const Color(0xFFE4FFF0);
      case 'MENTAL HEALTH':
        return const Color(0xFFF7EFFA);
      case 'OTHERS':
        return const Color(0xFFF4F4F4);
      case 'HEALTH':
      default:
        return const Color(0xFFEFF2FF);
    }
  }

  Color _categoryText(String category) {
    switch (category.toUpperCase()) {
      case 'WORK':
        return const Color(0xFF3AD06B);
      case 'MENTAL HEALTH':
        return const Color(0xFFB05CC2);
      case 'OTHERS':
        return const Color(0xFF9A9A9A);
      case 'HEALTH':
      default:
        return const Color(0xFF5E77FF);
    }
  }

  Color _priorityBg(String priority) {
    switch (priority.toUpperCase()) {
      case 'HIGH':
        return const Color(0xFFFFE4E4);
      case 'MEDIUM':
        return const Color(0xFFFFF1D6);
      case 'LOW':
      default:
        return const Color(0xFFE8F5E9);
    }
  }

  Color _priorityText(String priority) {
    switch (priority.toUpperCase()) {
      case 'HIGH':
        return const Color(0xFFD32F2F);
      case 'MEDIUM':
        return const Color(0xFFEF6C00);
      case 'LOW':
      default:
        return const Color(0xFF2E7D32);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final tasks = [...provider.tasks]
          ..sort((a, b) {
            int rank(String p) {
              switch (p.toUpperCase()) {
                case 'HIGH':
                  return 0;
                case 'MEDIUM':
                  return 1;
                case 'LOW':
                  return 2;
                default:
                  return 3;
              }
            }

            return rank(a.priority).compareTo(rank(b.priority));
          });
        if (tasks.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'No tasks yet!',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.black54),
            ),
          );
        }

        return Column(
          children: [
            for (int i = 0; i < tasks.length; i++) ...[
              _TaskTile(
                title: tasks[i].title,
                tagText: tasks[i].category,
                tagColor: _categoryBg(tasks[i].category),
                tagTextColor: _categoryText(tasks[i].category),
                secondaryTagText: tasks[i].priority,
                secondaryTagColor: _priorityBg(tasks[i].priority),
                secondaryTagTextColor: _priorityText(tasks[i].priority),
                onToggle: () => provider.toggleTaskCompletion(tasks[i]),
                checked: tasks[i].isCompleted,
              ),
              if (i != tasks.length - 1) const Divider(height: 28),
            ],
          ],
        );
      },
    );
  }
}

class _TaskTile extends StatelessWidget {
  final String title;
  final String tagText;
  final Color tagColor;
  final Color tagTextColor;
  final String? secondaryTagText;
  final Color? secondaryTagColor;
  final Color? secondaryTagTextColor;
  final VoidCallback? onToggle;
  final bool checked;

  const _TaskTile({
    required this.title,
    required this.tagText,
    required this.tagColor,
    required this.tagTextColor,
    this.secondaryTagText,
    this.secondaryTagColor,
    this.secondaryTagTextColor,
    this.onToggle,
    this.checked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onToggle,
              child: _CheckboxBox(size: 22, checked: checked),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: checked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: checked
                          ? Colors.black.withValues(alpha: 0.4)
                          : Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _Tag(
                        text: tagText,
                        color: tagColor,
                        textColor: tagTextColor,
                      ),
                      if (secondaryTagText != null)
                        _Tag(
                          text: secondaryTagText!,
                          color: secondaryTagColor ?? Colors.black12,
                          textColor: secondaryTagTextColor ?? Colors.black87,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _Tag({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _CheckboxBox extends StatelessWidget {
  final double size;
  final bool checked;

  const _CheckboxBox({this.size = 22, this.checked = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: checked ? const Color(0xFF2E2929) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.15),
          width: 1.4,
        ),
      ),
      child: checked
          ? const Icon(CupertinoIcons.check_mark, color: Colors.white, size: 16)
          : null,
    );
  }
}
