import 'package:flutter/material.dart';

class DataLine extends StatelessWidget {
  final String caption;
  final String data;

  const DataLine({
    required this.caption,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: _getColor(context), fontSize: 12);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Text(
            caption,
            style: textStyle,
          ),
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Text(
            data,
            style: textStyle,
          ),
        )
      ],
    );
  }

  Color _getColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }
}
