import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 118, 161, 237)),
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}

// Task model to represent individual tasks
class Task {
  String name;
  bool isCompleted;

  Task({required this.name, this.isCompleted = false});
}

// Main screen for task management
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final List<Task> _tasks = [];

  // Method to add a new task
  void _addTask() {
    setState(() {
      if (_taskController.text.isNotEmpty) {
        _tasks.add(Task(name: _taskController.text));
        _taskController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully!')),
        );
      }
    });
  }

  // Method to toggle the completion status of a task
  void _toggleCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  // Method to remove a task from the list, with confirmation dialog
  void _removeTask(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                setState(() {
                  _tasks.removeAt(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task deleted successfully')),
                  );
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text(style: TextStyle(color: Colors.white), 'Task Manager'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Input field and Add button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: 'Enter task here',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Task list
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks available. Start adding some!',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return TaskTile(
                          task: _tasks[index],
                          onComplete: () => _toggleCompletion(index),
                          onDelete: () => _removeTask(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for individual task tile
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback onDelete;

  const TaskTile({
    Key? key,
    required this.task,
    required this.onComplete,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (bool? value) {
            onComplete();
          },
        ),
        title: Text(
          task.name,
          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
