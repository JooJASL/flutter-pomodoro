import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/pomodoro_controller.dart';
import 'package:tasks/pomodoro_timer.dart';

import 'settings.dart';

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(children: [
      Positioned(
          bottom: 20,
          right: 20,
          child: IconButton(
              onPressed: () => onSettingsButtonPressed(context),
              icon: const Icon(Icons.settings))),
      Material(
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              height: 75,
              child: FittedBox(
                child: IconButton(
                    onPressed: () => ref
                        .read(pomodoroProvider.notifier)
                        .pomodoroState = PomodoroState.work,
                    icon: const Icon(Icons.work)),
              ),
            ),
            SizedBox(
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
            )
          ],
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PomodoroTimer(
            fillLineColor: Theme.of(context).colorScheme.primary,
            backfillLineColor: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(height: 64),
          const _Buttons(),
        ],
      ),
    ]);
  }

  void onSettingsButtonPressed(BuildContext context) {
    showDialog(context: context, builder: (context) => const Settings());
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
        if (isPaused)
          ElevatedButton(
            onPressed: () => ref.read(pomodoroProvider.notifier).startTimer(),
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(250, 50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            child: const Text("Start"),
          ),
        if (isPaused == false)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () =>
                      ref.read(pomodoroProvider.notifier).pauseTimer(),
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
                  child: const Icon(Icons.pause)),
              ElevatedButton(
                  onPressed: () =>
                      ref.read(pomodoroProvider.notifier).resetTimer(),
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
                  child: const Icon(Icons.restore)),
            ],
          ),
      ],
    );
  }
}
