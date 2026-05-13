import 'package:flutter/material.dart';
import '../widgets/task_card.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleComplete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task title at the top
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // All task information
            _infoRow(Icons.description, 'Description', task.description),
            _infoRow(Icons.category, 'Category', task.category),
            _infoRow(Icons.flag, 'Priority', task.priority),
            _infoRow(
              Icons.calendar_today,
              'Due Date',
              '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
            ),
            _infoRow(
              Icons.check_circle,
              'Status',
              task.isCompleted ? 'Completed' : 'Pending',
            ),

            const SizedBox(height: 30),

            // Mark complete / incomplete button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  onToggleComplete();
                  Navigator.pop(context); // go back after toggling
                },
                icon: Icon(
                  task.isCompleted ? Icons.undo : Icons.check,
                ),
                label: Text(
                  task.isCompleted
                      ? 'Mark as Incomplete'
                      : 'Mark as Complete',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Edit button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context); // close detail screen first
                  onEdit(); // then open the edit form
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Task'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Delete button with confirmation dialog
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  // Show confirmation dialog before deleting
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete Task'),
                      content: const Text(
                        'Are you sure you want to delete this task?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  // Only delete if user confirmed
                  if (confirm == true) {
                    onDelete();
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  'Delete Task',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to display one info row
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 20),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}