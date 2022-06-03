import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo_model.dart';

class TodoTile extends ConsumerStatefulWidget {
  final Todo todo;

  const TodoTile({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoTileState();
}

class _TodoTileState extends ConsumerState<TodoTile> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        color: checked
            ? Theme.of(context).disabledColor
            : Theme.of(context).cardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    widget.todo.title,
                    style: TextStyle(
                        decoration: checked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.todo.description,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        decoration: checked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 50,
              child: Checkbox(
                  value: checked,
                  onChanged: (value) {
                    setState(
                      () {
                        checked = value ?? false;
                        widget.todo.done = value ?? false;
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    checked = widget.todo.done;
    super.initState();
  }
}
