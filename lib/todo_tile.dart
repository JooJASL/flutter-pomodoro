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
  @override
  Widget build(BuildContext context) {
    final checked = ValueNotifier<bool>(widget.todo.done);
    return ValueListenableBuilder<bool>(
      valueListenable: checked,
      child: TodoContents(
        widget.todo,
        checked,
      ),
      builder: (context, isChecked, todoContents) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Card(
              color: isChecked
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).cardColor,
              // child: todoContents,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      for (var i = 0; i < widget.todo.difficulty; i++)
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: FittedBox(
                            child: Icon(Icons.arrow_back_ios_rounded,
                                color: isChecked
                                    ? Theme.of(context).disabledColor
                                    : Theme.of(context).primaryColor),
                          ),
                        ),
                    ],
                  ),
                  todoContents!,
                ],
              ),
            ));
      },
    );
  }
}

class TodoContents extends StatefulWidget {
  final Todo todo;
  final ValueNotifier<bool> checked;
  const TodoContents(this.todo, this.checked, {Key? key}) : super(key: key);

  @override
  _TodoContentsState createState() => _TodoContentsState();
}

class _TodoContentsState extends State<TodoContents> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              // Extra space so they match.
              widget.todo.title,
              style: TextStyle(
                  decoration: widget.checked.value
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
            const SizedBox(height: 8),
            Text(
              widget.todo.description,
              style: Theme.of(context).textTheme.caption!.copyWith(
                  decoration: widget.checked.value
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 50,
        child: Checkbox(
          value: widget.checked.value,
          onChanged: (value) {
            setState(() {
              widget.checked.value = value ?? false;
              widget.todo.done = value ?? false;
            });
          },
        ),
      ),
    ]);
  }
}
