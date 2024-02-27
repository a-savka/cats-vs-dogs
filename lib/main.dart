import 'package:cats_vs_dogs/initial_components.dart';
import 'package:cats_vs_dogs/main.data.dart';
import 'package:cats_vs_dogs/models/prediction.dart';
import 'package:cats_vs_dogs/pages/home/home.page.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PredictionAdapter());
  // Hive.registerAdapter(PredictionLabelAdapter());
  runApp(ProviderScope(
    overrides: [configureRepositoryLocalStorage()],
    child: const MyAppShell(),
  ));
}

class MyAppShell extends HookConsumerWidget {
  const MyAppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(repositoryInitializerProvider).when(
          data: (_) {
            return const MyApp();
          },
          error: (_, __) => const AppLoadingError(),
          loading: () => const AppLoading(),
        );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Cats vs Dogs'),
    );
  }
}
