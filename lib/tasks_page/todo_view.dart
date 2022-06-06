import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tasks.dart';
import 'todo_tile.dart';

class TodoView extends ConsumerWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(tasksProvider);

    if (todos.isEmpty) {
      return Center(
        child: Text(
          'No Todos, Yet.',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      );
    }

    return ListView.builder(
      itemCount: todos.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            ref.read(tasksProvider.notifier).state = [
              for (final todo in todos)
                if (todo != todos[index]) todo
            ];
          },
          child: TodoTile(todo: todos[index]),
        );
      },
    );
  }
}
