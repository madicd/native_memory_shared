import 'package:flutter/material.dart';

class ValueCard extends StatelessWidget {
  const ValueCard({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          Text(value, style: Theme.of(context).textTheme.displayLarge),
        ],
      ),
    ));
  }
}
