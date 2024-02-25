import 'package:flutter/material.dart';

class ConfirmPrediction extends StatelessWidget {
  const ConfirmPrediction({
    Key? key,
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
              onPressed: () {},
              child: const Text('Right'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Wrong'),
            ),
          ],
        ),
      ],
    );
  }
}
