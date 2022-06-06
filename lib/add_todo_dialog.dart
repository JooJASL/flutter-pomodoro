import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaru/yaru.dart';

import 'tasks.dart';
import 'todo_model.dart';

class AddTodoDialog extends ConsumerStatefulWidget {
  const AddTodoDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends ConsumerState<AddTodoDialog> {
  final titleEditingController = TextEditingController();
  final descriptionEditingController = TextEditingController();
  double difficulty = 1;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      // ignore: prefer_const_constructors
      data: YaruThemeData(
        themeMode: ThemeMode.dark,
        variant: YaruVariant.kubuntuBlue,
      ),
      child: AlertDialog(
        title: const Center(child: Text("Create new task.")),
        actionsAlignment: MainAxisAlignment.center,
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: titleEditingController,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please write a title for task.';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: descriptionEditingController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Slider(
                min: 1,
                max: 5,
                divisions: 5,
                value: difficulty,
                onChanged: (value) {
                  setState(() {
                    difficulty = value;
                  });
                },
              ),
            ],
          ),
        ),
        actions: <TextButton>[
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => acceptedDialog(), child: const Text('Accept')),
        ],
      ),
    );
  }

  void acceptedDialog() {
    if (formKey.currentState!.validate() == false) {
      return;
    }

    ref.read(tasksProvider.state).state = [
      ...ref.read(tasksProvider),
      Todo(
        title: titleEditingController.text,
        description: descriptionEditingController.text.isNotEmpty
            ? descriptionEditingController.text
            : 'No description',
        difficulty: difficulty.toInt(),
      )
    ];

    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleEditingController.dispose();
    descriptionEditingController.dispose();
    super.dispose();
  }
}
