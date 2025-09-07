import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myapp/api/todos_api.dart';
import 'package:myapp/main.dart';
import 'package:myapp/providers/todo_provider.dart';
import 'package:myapp/screens/auth_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showAddTodoDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    // default 1hr from now
    DateTime selectedDateTime = DateTime.now().add(const Duration(hours: 1));

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('New Todo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deadline:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      // show selected date/time
                      Expanded(
                        child: Text(
                          DateFormat.yMMMd().add_jm().format(selectedDateTime),
                        ),
                      ),
                      // btn to open pickers
                      IconButton(
                        icon: const Icon(Icons.edit_calendar_outlined),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDateTime,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );

                          if (pickedDate == null) return; // cancelled

                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                              selectedDateTime,
                            ),
                          );

                          if (pickedTime == null) return; // cancelled

                          setState(() {
                            selectedDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty) {
                      await ref.read(todosApiProvider).addTodo(
                        title: titleController.text,
                        // use selected datetime
                        deadline: selectedDateTime,
                      );

                      ref.refresh(todosProvider);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context,
      WidgetRef ref,
      int todoId,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Todo'),
          content: const Text('Are you sure you want to delete this todo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                await ref.read(todosApiProvider).deleteTodo(todoId);
                ref.refresh(todosProvider);
                Navigator.of(context).pop(); // close dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTodoDialog(
      BuildContext context,
      WidgetRef ref,
      Map<String, dynamic> todo,
      ) {
    final titleController = TextEditingController(text: todo['title']);
    // use existing deadline
    DateTime selectedDateTime = DateTime.parse(todo['deadline']);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Todo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  const Text('Deadline:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: Text(DateFormat.yMMMd()
                            .add_jm()
                            .format(selectedDateTime)),
                      ),
                      // btn for pickers
                      IconButton(
                        icon: const Icon(Icons.edit_calendar_outlined),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDateTime,
                            firstDate: DateTime.now(),
                            lastDate:
                            DateTime.now().add(const Duration(days: 365)),
                          );

                          if (pickedDate == null) return; // cancelled

                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime:
                            TimeOfDay.fromDateTime(selectedDateTime),
                          );

                          if (pickedTime == null) return; // cancelled

                          setState(() {
                            selectedDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty) {
                      await ref.read(todosApiProvider).updateTodo(
                        id: todo['id'],
                        title: titleController.text,
                        deadline: selectedDateTime,
                      );

                      ref.refresh(todosProvider);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsyncValue = ref.watch(todosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                'Welcome, ${supabase.auth.currentUser?.userMetadata?['full_name'] ?? 'User'}',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                supabase.auth.currentUser?.userMetadata?['avatar_url'] ?? '',
              ),
              radius: 18,
            ),
          ),
          IconButton(
            onPressed: () => ref.read(authApiProvider).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
      body: todosAsyncValue.when(
        data: (todos) {
          if (todos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('All clear!',
                      style: TextStyle(fontSize: 22, color: Colors.grey)),
                  Text('Add a new todo to get started.',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              final deadline = DateTime.parse(todo['deadline']);
              final isCompleted = todo['is_completed'] as bool;

              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                elevation: 2,
                child: CheckboxListTile(
                  value: isCompleted,
                  onChanged: (newValue) async {
                    await ref
                        .read(todosApiProvider)
                        .updateTodo(id: todo['id'], isCompleted: newValue!);
                    ref.refresh(todosProvider);
                  },
                  title: Text(
                    todo['title'],
                    style: TextStyle(
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: isCompleted ? Colors.grey : null,
                    ),
                  ),
                  subtitle: Text(
                    'Due: ${DateFormat.yMMMd().add_jm().format(deadline)}',
                  ),
                  secondary: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _showEditTodoDialog(context, ref, todo),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red.shade300),
                        onPressed: () {
                          _showDeleteConfirmationDialog(
                              context, ref, todo['id']);
                        },
                      ),
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}