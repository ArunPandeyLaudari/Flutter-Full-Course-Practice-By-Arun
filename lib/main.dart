import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To-Do List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TodoScreen(),
      ),
    );
  }
}

class TodoProvider extends ChangeNotifier {
  final List<TodoItem> _tasks = [];

  List<TodoItem> get tasks => _tasks;

  void addTask(String task) {
    _tasks.add(TodoItem(task: task));
    notifyListeners();
  }

  void toggleTask(int index) {
    _tasks[index].isDone = !_tasks[index].isDone;
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}

class TodoItem {
  String task;
  bool isDone;

  TodoItem({required this.task, this.isDone = false});
}

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(),
                    decoration: const InputDecoration(
                      labelText: 'Enter a task',
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        Provider.of<TodoProvider>(context, listen: false)
                            .addTask(value);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Not needed as we handle onSubmitted
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                return ListView.builder(
                  itemCount: todoProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = todoProvider.tasks[index];
                    return ListTile(
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (value) {
                          todoProvider.toggleTask(index);
                        },
                      ),
                      title: Text(
                        task.task,
                        style: TextStyle(
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          todoProvider.removeTask(index);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
