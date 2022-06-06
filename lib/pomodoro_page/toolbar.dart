import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pomodoro_controller.dart';

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
