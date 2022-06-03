import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaru/yaru.dart';

import 'add_todo_dialog.dart';
import 'todo_model.dart';
import 'todo_view.dart';

final tasksProvider = StateProvider<List<Todo>>((ref) {
  return <Todo>[];
});

class TasksPage extends ConsumerWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return YaruTheme(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todos'),
          centerTitle: true,
        ),
        body: const TodoView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => clickedAddButton(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void clickedAddButton(BuildContext context) {
    showDialog(context: context, builder: (context) => const AddTodoDialog());
  }
}
