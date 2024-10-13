import 'package:flutter/material.dart';

class InputCard extends StatefulWidget {
  const InputCard({
    super.key,
    required this.title,
    required this.onValueSubmitted,
  });

  final String title;
  final Function(int) onValueSubmitted;

  @override
  State<InputCard> createState() => _InputCardState();
}

class _InputCardState extends State<InputCard> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter a value',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () {
                widget.onValueSubmitted(int.parse(_controller.text));
                _controller.clear();
              },
              child: const Text('Submit')),
        ],
      ),
    ));
  }
}
