import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/pomodoro_page/pomodoro_controller.dart';
import 'package:tasks/pomodoro_page/pomodoro_timer.dart';

import '../settings.dart';
import '../tasks_page/tasks.dart';
import 'toolbar.dart';

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(children: const <Widget>[
      TasksButton(),
      SettingsButton(),
      Toolbar(),
      Content(),
    ]);
  }
}

class TasksButton extends StatelessWidget {
  const TasksButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () => onTasksButtonPressed(context),
              icon: const Icon(Icons.task)),
        ));
  }

  void onTasksButtonPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const TasksPage()));
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          onPressed: () => onSettingsButtonPressed(context),
          icon: const Icon(Icons.settings),
        ),
      ),
    );
  }

  void onSettingsButtonPressed(BuildContext context) {
    showDialog(context: context, builder: (context) => const Settings());
  }
}

class Content extends StatelessWidget {
  const Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 25),
            PomodoroTimer(
              fillLineColor: Theme.of(context).colorScheme.primary,
              backfillLineColor: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(height: 49),
            const Buttons(),
          ],
        ),
      ),
    );
  }
}

class Buttons extends ConsumerWidget {
  const Buttons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaused = ref.watch(isPausedProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isPaused) const StartButton(),
        if (isPaused == false)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              PauseButton(),
              ResetButton(),
            ],
          ),
      ],
    );
  }
}

class ResetButton extends ConsumerWidget {
  const ResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () => ref.read(pomodoroProvider.notifier).resetTimer(),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(125, 50)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(20),
            )),
          ),
        ),
        child: const Icon(Icons.restore));
  }
}

class StartButton extends ConsumerWidget {
  const StartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => ref.read(pomodoroProvider.notifier).startTimer(),
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(250, 50)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      child: const Text("Start"),
    );
  }
}

class PauseButton extends ConsumerWidget {
  const PauseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () => ref.read(pomodoroProvider.notifier).pauseTimer(),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(125, 50)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(00),
            )),
          ),
        ),
        child: const Icon(Icons.pause));
  }
}
