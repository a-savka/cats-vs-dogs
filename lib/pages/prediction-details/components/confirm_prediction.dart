import 'package:flutter/material.dart';

class ConfirmPrediction extends StatelessWidget {
  final void Function(bool isValid) onConfirmed;
  const ConfirmPrediction({
    Key? key,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text('Am i right?'),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => onConfirmed(true),
              child: const Text('Right'),
            ),
            ElevatedButton(
              onPressed: () => onConfirmed(false),
              child: const Text('Wrong'),
            ),
          ],
        ),
      ],
    );
  }
}
