import 'dart:async';
import 'package:desktop_notifications/desktop_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/pomodoro_controller.dart';

class PomodoroTimer extends ConsumerStatefulWidget {
  final Color fillLineColor;
  final Color backfillLineColor;
  final Size size;
  const PomodoroTimer({
    Key? key,
    this.fillLineColor = Colors.blue,
    this.backfillLineColor = Colors.white,
    this.size = const Size(250, 250),
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PomdoroTimerState();
}

class _PomdoroTimerState extends ConsumerState<PomodoroTimer> {
  late final Timer timer;
  final notifClient = NotificationsClient();

  @override
  Widget build(BuildContext context) {
    final currentDuration = ref.watch(timerDurationProvider);

    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Center(
              child: SizedBox(
                height: 250,
                width: 250,
                child: CircularProgressIndicator(
                  value: 1,
                  color: widget.fillLineColor,
                ),
              ),
            ),
          ),
          Positioned(
            child: Center(
              child: SizedBox(
                height: 250,
                width: 250,
                child: CircularProgressIndicator(
                  value: 1 -
                      (currentDuration.minutes * 60 + currentDuration.seconds) /
                          (ref
                                  .watch(pomodoroProvider.notifier)
                                  .currentDuration *
                              60),
                  color: widget.backfillLineColor,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              getFormattedTime(
                  currentDuration.minutes, currentDuration.seconds),
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ],
      ),
    );
  }

  void reachedEnd() {
    notifClient.notify('Period ended!', appName: 'Tasks');
    SystemSound.play(SystemSoundType.alert);
    ref.read(pomodoroProvider.notifier).resetTimer();
  }

  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => setState(
        () {
          if (ref.watch(isPausedProvider)) return;

          var minutes = ref.read(timerDurationProvider).minutes;
          var seconds = ref.read(timerDurationProvider).seconds;

          seconds--;
          if (seconds < 0) {
            seconds = 59;
            minutes--;
            if (minutes < 0) reachedEnd();
          }
          ref.read(timerDurationProvider.notifier).state =
              Timing(minutes, seconds);
        },
      ),
    );

    super.initState();
  }

  String getFormattedTime(int minutes, int seconds) {
    if (minutes < 0 || seconds < 0) return '00:00';

    final fMinutes = minutes < 10 ? '0$minutes' : minutes.toString();
    final fSeconds = seconds < 10 ? '0$seconds' : seconds.toString();

    return '$fMinutes:$fSeconds';
  }

  @override
  void dispose() {
    notifClient.close();
    super.dispose();
  }
}
