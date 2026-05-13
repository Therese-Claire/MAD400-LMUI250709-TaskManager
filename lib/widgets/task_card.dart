import 'package:flutter/material.dart';
import '../screens/task_detail_screen.dart';


class Task {
  String title;
  String description;
  String category;
  String priority;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
  });
}

// Returns a color based on priority level
Color priorityColor(String priority) {
  switch (priority) {
    case 'High':
      return Colors.red;
    case 'Medium':
      return Colors.orange;
    default:
      return Colors.green;
  }
}

// Returns an icon based on category
IconData categoryIcon(String category) {
  switch (category) {
    case 'School':
      return Icons.school;
    case 'Health':
      return Icons.favorite;
    case 'Work':
      return Icons.work;
    default:
      return Icons.person;
  }
}

// TaskCard Widget
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleComplete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Check if task is overdue — past due date and not completed
    final bool isOverdue =
        !task.isCompleted && task.dueDate.isBefore(DateTime.now());

    return Dismissible(
      // Swipe left to delete — Section 2, Task 2.2
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // Overdue tasks highlighted in red
        color: isOverdue ? Colors.red[50] : null,
        child: ListTile(
          leading: Icon(categoryIcon(task.category), color: Colors.teal),
          title: Text(
            task.title,
            style: TextStyle(
              // Strikethrough for completed tasks — Section 2, Task 2.2
              decoration:
              task.isCompleted ? TextDecoration.lineThrough : null,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '${task.category} • Due: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
            style: TextStyle(color: isOverdue ? Colors.red : null),
          ),
          trailing: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: priorityColor(task.priority).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              task.priority,
              style: TextStyle(
                color: priorityColor(task.priority),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          // Tap to navigate to Task Detail Screen
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TaskDetailScreen(
                  task: task,
                  onDelete: onDelete,
                  onToggleComplete: onToggleComplete,
                  onEdit: onEdit,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}