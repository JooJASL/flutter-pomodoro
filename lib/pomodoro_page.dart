import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/pomodoro_controller.dart';
import 'package:tasks/pomodoro_timer.dart';
import 'package:tasks/tasks.dart';

import 'settings.dart';

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(children: const <Widget>[
      TasksButton(),
      SettingsButton(),
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Toolbar(),
          const SizedBox(height: 25),
          PomodoroTimer(
            fillLineColor: Theme.of(context).colorScheme.primary,
            backfillLineColor: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(height: 49),
          const _Buttons(),
        ],
      ),
    );
  }
}

class _Buttons extends ConsumerWidget {
  const _Buttons({Key? key}) : super(key: key);

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

class Toolbar extends ConsumerWidget {
  const Toolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const <Widget>[
          WorkButton(),
          RestButton(),
        ],
      ),
    );
  }
}

class WorkButton extends ConsumerWidget {
  const WorkButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 75,
      child: FittedBox(
        child: IconButton(
            onPressed: () => ref.read(pomodoroProvider.notifier).pomodoroState =
                PomodoroState.work,
            icon: const Icon(Icons.work)),
      ),
    );
  }
}

class RestButton extends ConsumerWidget {
  const RestButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 75,
      child: FittedBox(
        child: IconButton(
            onPressed: () {
              if (ref.read(pomodoroProvider) == PomodoroState.rest) {
                ref.read(pomodoroProvider.notifier).pomodoroState =
                    PomodoroState.longRest;
              } else {
                ref.read(pomodoroProvider.notifier).pomodoroState =
                    PomodoroState.rest;
              }
            },
            icon: const Icon(Icons.games_outlined)),
      ),
    );
  }
}
