import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks/pomodoro_page/pomodoro_controller.dart';
import 'package:tasks/pomodoro_page/textfield_for_digits.dart';

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
    if (workTextEditingController.text.isEmpty &&
        restTextEditingController.text.isEmpty &&
        longRestTextEditingController.text.isEmpty) return;

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

    ref.read(pomodoroProvider.notifier).resetTimer();

    SharedPreferences.getInstance().then((prefs) async {
      await prefs.setInt(
          'work', ref.read(pomodoroProvider.notifier).workDuration);
      await prefs.setInt(
          'rest', ref.read(pomodoroProvider.notifier).restDuration);
      await prefs.setInt(
          'long-rest', ref.read(pomodoroProvider.notifier).longRestDuration);
    });

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
