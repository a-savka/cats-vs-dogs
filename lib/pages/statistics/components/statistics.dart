import 'package:cats_vs_dogs/models/stats.dart';
import 'package:cats_vs_dogs/providers/stats_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Statistics extends HookConsumerWidget {
  const Statistics({
    Key? key,
  }) : super(key: key);

  Widget _makeRow(String title, String text) {
    return Row(
      children: [
        SizedBox(
          width: 160,
          child: Text(title),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(text),
      ],
    );
  }

  Widget _makeDataUi(Stats statsData) {
    return Container(
      padding: const EdgeInsets.all(40.0),
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _makeRow('Total: ', statsData.total.toString()),
          const SizedBox(
            height: 10,
          ),
          _makeRow('Confirmed: ', statsData.confirmed.toString()),
          const SizedBox(
            height: 10,
          ),
          _makeRow('Correct: ', statsData.correct.toString()),
          const SizedBox(
            height: 10,
          ),
          _makeRow('Accuracy: ', '${statsData.accuracy.toStringAsFixed(2)}%'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsData = ref.watch(statsProvider);

    return statsData.when(
      data: _makeDataUi,
      error: (_, __) {
        return const Center(
          child: Text('No statistics available'),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
