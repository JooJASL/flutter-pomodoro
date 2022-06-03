import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PomodoroState { work, rest, longRest, resetting }

final pomodoroProvider =
    StateNotifierProvider<PomodoroController, PomodoroState>((ref) {
  return PomodoroController(ref);
});

class PomodoroController extends StateNotifier<PomodoroState> {
  int workDuration;
  int restDuration;
  int longRestDuration;
  bool isPaused = true;

  int get currentDuration {
    switch (state) {
      case PomodoroState.work:
        return workDuration;
      case PomodoroState.rest:
        return restDuration;
      case PomodoroState.longRest:
        return longRestDuration;
      case PomodoroState.resetting:
        return 0;
    }
  }

  final Ref ref;
  PomodoroController(
    this.ref, {
    this.workDuration = 25,
    this.restDuration = 5,
    this.longRestDuration = 10,
  }) : super(PomodoroState.work);

  set pomodoroState(value) {
    state = value;
    ref.read(isPausedProvider.notifier).state = true;
  }

  void startTimer() => ref.read(isPausedProvider.notifier).state = false;

  void pauseTimer() => ref.read(isPausedProvider.notifier).state = true;

  void resumeTimer() => ref.read(isPausedProvider.notifier).state = false;

  void resetTimer() {
    ref.read(isPausedProvider.notifier).state = true;

    // I know this is hacky, but Riverpod does not allow cyclic dependencies.
    // I.e., I can't just access the timerDurationProvider directly.
    final current = state;
    state = PomodoroState.resetting;
    state = current;
  }
}

final isPausedProvider = StateProvider<bool>((ref) => true);

class Timing {
  final int minutes;
  final int seconds;
  const Timing(this.minutes, this.seconds);
}

final timerDurationProvider = StateProvider<Timing>(
  (ref) {
    ref.watch(pomodoroProvider);
    final minutes = ref.read(pomodoroProvider.notifier).currentDuration;
    return Timing(minutes, 0);
  },
);
