import 'package:cats_vs_dogs/main.data.dart';
import 'package:cats_vs_dogs/pages/history/components/history_list_item.dart';
import 'package:cats_vs_dogs/providers/ordered_predictions_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HistoryList extends StatefulHookConsumerWidget {
  const HistoryList({
    super.key,
  });

  @override
  ConsumerState<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends ConsumerState<HistoryList> {
  @override
  Widget build(BuildContext context) {
    final predictionsData = ref.watch(orderedPredictionsProvider);

    if (predictionsData.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!predictionsData.hasValue || predictionsData.value!.isEmpty) {
      return const Center(
        child: Text('No predictions available'),
      );
    }

    return Scrollbar(
      child: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          for (final prediction in predictionsData.value!)
            HistoryListItem(prediction: prediction),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
