// ignore_for_file: prefer_const_constructors

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/pomodoro_controller.dart';
import 'package:tasks/pomodoro_page.dart';
import 'package:yaru/yaru.dart';

Future<void> main() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    await DesktopWindow.setMinWindowSize(const Size(590, 650));
  }
  runApp(const ProviderScope(child: TasksApp()));
}

class TasksApp extends StatelessWidget {
  const TasksApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasks',
      home: YaruTheme(
        data: YaruThemeData(
          themeMode: ThemeMode.dark,
          variant: YaruVariant.kubuntuBlue,
        ),
        child: const Homepage(),
      ),
    );
  }
}

class Homepage extends ConsumerWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(prefsProvider).when(
      data: (prefs) {
        return const Scaffold(
          body: PomodoroPage(),
        );
      },
      error: (err, stack) {
        return ErrorWidget(err.toString());
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}
