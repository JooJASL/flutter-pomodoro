import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks/pomodoro_controller.dart';
import 'package:tasks/pomodoro_page.dart';
import 'package:yaru/yaru.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DesktopWindow.setMinWindowSize(const Size(590, 650));

  runApp(const ProviderScope(child: TasksApp()));
}

class TasksApp extends StatelessWidget {
  const TasksApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasks',
      home: YaruTheme(
        child: Homepage(),
      ),
    );
  }
}

class Homepage extends ConsumerWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SharedPreferences.getInstance().then(
      (prefs) {
        if (prefs.getInt('work') != null) {
          ref.read(pomodoroProvider.notifier).workDuration =
              prefs.getInt('work')!;
        }
        if (prefs.getInt('rest') != null) {
          ref.read(pomodoroProvider.notifier).restDuration =
              prefs.getInt('rest')!;
        }
        if (prefs.getInt('long-rest') != null) {
          ref.read(pomodoroProvider.notifier).longRestDuration =
              prefs.getInt('long-rest')!;
        }
        ref.refresh(pomodoroProvider);
      },
    );
    return const Scaffold(
      body: PomodoroPage(),
    );
  }
}
