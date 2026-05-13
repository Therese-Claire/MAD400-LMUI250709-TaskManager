import 'package:flutter/material.dart';
import '../widgets/task_card.dart';
import 'profile_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Master list of all tasks
  final List<Task> _tasks = [];

  // Bottom nav index — 0 = Tasks, 1 = Profile
  int _currentIndex = 0;

  // Filter state — All, Pending, Completed
  String _filter = 'All';

  // Search state
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Sort state
  String _sortBy = 'Due Date';

  // Returns filtered + sorted list of tasks
  List<Task> get _filteredTasks {
    List<Task> result = _tasks.where((task) {
      // Check filter match
      final matchesFilter = _filter == 'All' ||
          (_filter == 'Completed' && task.isCompleted) ||
          (_filter == 'Pending' && !task.isCompleted);
      // Check search match
      final matchesSearch = task.title
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    // Sort the result
    result.sort((a, b) {
      if (_sortBy == 'Due Date') {
        return a.dueDate.compareTo(b.dueDate);
      }
      // Priority sort: High=0, Medium=1, Low=2
      const order = {'High': 0, 'Medium': 1, 'Low': 2};
      return (order[a.priority] ?? 1).compareTo(order[b.priority] ?? 1);
    });

    return result;
  }

  // Opens bottom sheet for adding or editing a task
  void _openTaskForm({Task? existingTask}) {
    final titleController =
    TextEditingController(text: existingTask?.title ?? '');
    final descController =
    TextEditingController(text: existingTask?.description ?? '');
    String category = existingTask?.category ?? 'School';
    String priority = existingTask?.priority ?? 'Medium';
    DateTime dueDate = existingTask?.dueDate ?? DateTime.now();

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            width: 500,
            child: StatefulBuilder(
              builder: (ctx, setModalState) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          existingTask == null ? 'Add Task' : 'Edit Task',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: descController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: category,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: ['School', 'Personal', 'Health', 'Work']
                              .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ))
                              .toList(),
                          onChanged: (val) =>
                              setModalState(() => category = val!),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: priority,
                          decoration: const InputDecoration(
                            labelText: 'Priority',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Low', 'Medium', 'High']
                              .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p),
                          ))
                              .toList(),
                          onChanged: (val) =>
                              setModalState(() => priority = val!),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: ctx,
                                  initialDate: dueDate,
                                  firstDate: DateTime(2024),
                                  lastDate: DateTime(2030),
                                );
                                if (picked != null) {
                                  setModalState(() => dueDate = picked);
                                }
                              },
                              icon: const Icon(Icons.calendar_today),
                              label: const Text('Pick Date'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (titleController.text.trim().isEmpty ||
                                  descController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill in all fields'),
                                  ),
                                );
                                return;
                              }
                              setState(() {
                                if (existingTask == null) {
                                  _tasks.add(Task(
                                    title: titleController.text.trim(),
                                    description: descController.text.trim(),
                                    category: category,
                                    priority: priority,
                                    dueDate: dueDate,
                                  ));
                                } else {
                                  existingTask.title =
                                      titleController.text.trim();
                                  existingTask.description =
                                      descController.text.trim();
                                  existingTask.category = category;
                                  existingTask.priority = priority;
                                  existingTask.dueDate = dueDate;
                                }
                              });
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              existingTask == null
                                  ? 'Add Task'
                                  : 'Save Changes',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Statistics for the stats bar
    final int completed =
        _tasks.where((t) => t.isCompleted).length;
    final int total = _tasks.length;
    final double progress = total == 0 ? 0.0 : completed / total;

    // The two pages for bottom navigation
    final List<Widget> pages = [
      // ── PAGE 0: Tasks ──
      Column(
        children: [
          // Statistics bar
          if (_tasks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statChip('Total', total, Colors.teal),
                      _statChip('Done', completed, Colors.green),
                      _statChip(
                          'Pending', total - completed, Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Linear progress indicator
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    color: Colors.teal,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}% complete',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

          // Filter buttons
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: ['All', 'Pending', 'Completed'].map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: _filter == f,
                    selectedColor: Colors.teal,
                    labelStyle: TextStyle(
                      color: _filter == f
                          ? Colors.white
                          : Colors.black,
                    ),
                    onSelected: (_) =>
                        setState(() => _filter = f),
                  ),
                );
              }).toList(),
            ),
          ),

          // Task list
          Expanded(
            child: _filteredTasks.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.checklist,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks here!',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Tap + to add a new task'),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _filteredTasks.length,
              itemBuilder: (_, i) {
                final task = _filteredTasks[i];
                return TaskCard(
                  task: task,
                  onDelete: () =>
                      setState(() => _tasks.remove(task)),
                  onToggleComplete: () => setState(
                          () => task.isCompleted = !task.isCompleted),
                  onEdit: () =>
                      _openTaskForm(existingTask: task),
                );
              },
            ),
          ),
        ],
      ),

      // ── PAGE 1: Profile ──
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        // Search mode changes the title to a text field
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search tasks...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (val) =>
              setState(() => _searchQuery = val),
        )
            : const Text('MemberMe'),
        actions: [
          // Search toggle
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchQuery = '';
                _searchController.clear();
              }
            }),
          ),

          // Sort menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (val) => setState(() => _sortBy = val),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'Due Date',
                child: Text('Sort by Due Date'),
              ),
              const PopupMenuItem(
                value: 'Priority',
                child: Text('Sort by Priority'),
              ),
            ],
          ),

          // Clear all — Section 4, Task 4.2
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Clear All Tasks'),
                  content: const Text(
                    'This will delete every task. Are you sure?',
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
                        'Clear All',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                setState(() => _tasks.clear());
              }
            },
          ),
        ],
      ),

      // IndexedStack keeps both pages alive when switching tabs
      body: IndexedStack(index: _currentIndex, children: pages),

      // FAB only shows on Tasks tab
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        onPressed: () => _openTaskForm(),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Helper widget for the statistics bar
  Widget _statChip(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}