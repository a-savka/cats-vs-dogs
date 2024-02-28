import 'package:cats_vs_dogs/pages/history/components/history_list.dart';
import 'package:cats_vs_dogs/pages/statistics/components/statistics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Statistics'),
      ),
      body: Statistics(),
    );
  }
}
