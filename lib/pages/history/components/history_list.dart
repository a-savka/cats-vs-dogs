import 'package:cats_vs_dogs/main.data.dart';
import 'package:cats_vs_dogs/pages/history/components/history_list_item.dart';
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
    final predictionsData = ref.predictions.watchAll(remote: false);

    if (predictionsData.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!predictionsData.hasModel || predictionsData.model.isEmpty) {
      return const Center(
        child: Text('No predictions available'),
      );
    }

    return Scrollbar(
      child: ListView(
        children: [
          for (final prediction in predictionsData.model)
            HistoryListItem(prediction: prediction)
        ],
      ),
    );
  }
}
