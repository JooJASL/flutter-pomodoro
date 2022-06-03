import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/pomodoro_controller.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  final workTextEditingController = TextEditingController();
  final restTextEditingController = TextEditingController();
  final longRestTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      actionsAlignment: MainAxisAlignment.center,
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldForDigits(
                controller: workTextEditingController,
                label: 'Work',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldForDigits(
                controller: restTextEditingController,
                label: 'Rest',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldForDigits(
                controller: longRestTextEditingController,
                label: 'Long Rest',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        const SizedBox(
          width: 3,
        ),
        OutlinedButton(
            onPressed: () => confirm(context), child: const Text("Confirm")),
      ],
    );
  }

  void confirm(BuildContext context) {
    if (workTextEditingController.text.isNotEmpty) {
      ref.read(pomodoroProvider.notifier).workDuration =
          int.parse(workTextEditingController.text);
    }

    if (restTextEditingController.text.isNotEmpty) {
      ref.read(pomodoroProvider.notifier).restDuration =
          int.parse(restTextEditingController.text);
    }

    if (longRestTextEditingController.text.isNotEmpty) {
      ref.read(pomodoroProvider.notifier).longRestDuration =
          int.parse(longRestTextEditingController.text);
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    workTextEditingController.dispose();
    restTextEditingController.dispose();
    longRestTextEditingController.dispose();
    super.dispose();
  }
}

class TextFieldForDigits extends StatelessWidget {
  final String label;

  /// This widget DOES NOT dispose of the controller by itself.
  final TextEditingController controller;
  const TextFieldForDigits({
    Key? key,
    required this.controller,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
            onPressed: () {
              constrainDigits();

              controller.text = (int.parse(controller.text) + 1).toString();
            },
            icon: const Icon(Icons.add)),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: (text) {
              if (text.length > 2) controller.text = 100.toString();
              if (controller.text == '0') controller.text = 1.toString();
            },
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                label: Center(
                  child: Text(
                    label,
                  ),
                )),
          ),
        ),
        IconButton(
            onPressed: () {
              constrainDigits();

              if (int.parse(controller.text) <= 1) return;
              controller.text = (int.parse(controller.text) - 1).toString();
            },
            icon: const Icon(Icons.remove)),
      ],
    );
  }

  void constrainDigits() {
    if (controller.text.isEmpty) controller.text = 1.toString();
    if (controller.text.length > 2) controller.text = 99.toString();
    if (int.parse(controller.text) - 1 == 0) controller.text = 1.toString();
  }
}
