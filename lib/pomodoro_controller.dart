import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PomodoroState { work, rest, longRest, resetting }

final pomodoroProvider =
    StateNotifierProvider<PomodoroController, PomodoroState>((ref) {
  return PomodoroController(ref);
});

final prefsProvider = FutureProvider<SharedPreferences>((ref) async {
  final instance = await SharedPreferences.getInstance();

  return instance;
});

class PomodoroController extends StateNotifier<PomodoroState> {
  final Ref ref;
  PomodoroController(this.ref) : super(PomodoroState.work) {
    ref.read(prefsProvider).when(
        data: (value) {
          prefs = value;
        },
        error: (err, stack) {},
        loading: () {});
  }

  SharedPreferences? prefs;

  int? _workDuration;

  int get workDuration {
    _workDuration = prefs!.getInt('work');
    return _workDuration ?? 25;
  }

  set workDuration(int workDuration) {
    _workDuration = workDuration;
    prefs!.setInt('work', _workDuration ?? 25);
  }

  int? _restDuration;

  int get restDuration {
    _restDuration = prefs!.getInt('rest');
    return _restDuration ?? 5;
  }

  set restDuration(int restDuration) {
    _restDuration = restDuration;
    prefs!.setInt('rest', _restDuration ?? 5);
  }

  int? _longRestDuration;

  int get longRestDuration {
    _longRestDuration = prefs!.getInt('long-rest');
    return _longRestDuration ?? 10;
  }

  set longRestDuration(int longRestDuration) {
    _longRestDuration = longRestDuration;
    prefs!.setInt('long-rest', _longRestDuration ?? 10);
  }

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
