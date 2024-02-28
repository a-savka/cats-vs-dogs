import 'package:flutter/material.dart';

class ConfirmDelete extends StatelessWidget {
  final void Function(bool confirmed) onConfirmed;

  const ConfirmDelete({
    Key? key,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Center(
          child: Text(
            'Delete this prediction?',
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          leading: const Icon(Icons.check_circle_outline),
          title: const Text('Yes'),
          onTap: () async {
            NavigatorState navigator = Navigator.of(context);
            navigator.pop();
            onConfirmed(true);
          },
        ),
        ListTile(
          leading: const Icon(Icons.cancel_outlined),
          title: const Text('No'),
          onTap: () async {
            NavigatorState navigator = Navigator.of(context);
            navigator.pop();
            onConfirmed(false);
          },
        ),
      ],
    );
  }
}
