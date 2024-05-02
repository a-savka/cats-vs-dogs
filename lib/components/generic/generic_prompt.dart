import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GenericPrompt extends StatefulWidget {
  final String title;
  final String? initialValue;
  final void Function(String value) onConfirm;
  final VoidCallback onReject;

  const GenericPrompt({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.onConfirm,
    required this.onReject,
  }) : super(key: key);

  @override
  State<GenericPrompt> createState() => GenericPromptState();
}

class GenericPromptState extends State<GenericPrompt> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: const ColoredBox(
                color: Colors.grey,
                child: SizedBox(
                  height: 4,
                  width: 32,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 30, 70, 15),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: controller,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: widget.onReject,
                    child: Text(
                      'Cancel',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => widget.onConfirm(controller.text),
                    child: Text(
                      'OK',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
