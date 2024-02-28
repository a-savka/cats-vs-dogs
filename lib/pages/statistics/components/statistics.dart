import 'package:cats_vs_dogs/providers/stats_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Statistics extends HookConsumerWidget {
  Statistics({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsData = ref.watch(statsProvider);

    if (statsData.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!statsData.hasValue) {
      return const Center(
        child: Text('No statistics available'),
      );
    }

    return Container(
      padding: const EdgeInsets.all(40.0),
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _makeRow('Total: ', statsData.value!.total.toString()),
          const SizedBox(
            height: 10,
          ),
          _makeRow('Confirmed: ', statsData.value!.confirmed.toString()),
          const SizedBox(
            height: 10,
          ),
          _makeRow('Correct: ', statsData.value!.correct.toString()),
          const SizedBox(
            height: 10,
          ),
          _makeRow(
              'Accuracy: ', statsData.value!.accuracy.toStringAsFixed(2) + '%'),
        ],
      ),
    );
  }
}
