import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_memory_shared/value_card.dart';

import 'input_card.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MemoryDemo(),
    );
  }
}

class MemoryDemo extends StatefulWidget {
  const MemoryDemo({super.key});

  @override
  State<MemoryDemo> createState() => _MemoryDemoState();
}

class _MemoryDemoState extends State<MemoryDemo> {
  String _rootIsolateValue = 'n/a';
  String _childIsolateValue = 'n/a';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Shared Native Memory Example")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ValueCard(
                          title: 'Root Isolate Value',
                          value: _rootIsolateValue),
                    ),
                    Expanded(
                      child: ValueCard(
                          title: 'Child Isolate value',
                          value: _childIsolateValue),
                    ),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: InputCard(
                      title: 'Root Isolate',
                      onValueSubmitted: _onRootIsolateValueSubmitted,
                    ),
                  ),
                  Expanded(
                    child: InputCard(
                      title: 'Child Isolate',
                      onValueSubmitted: _onChildIsolateValueSubmitted,
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  void _onChildIsolateValueSubmitted(int value) async {
    await writeFromChildIsolate(value);
    await _refreshValues();
  }

  void _onRootIsolateValueSubmitted(int value) async {
    await writeFromRootIsolate(value);
    await _refreshValues();
  }

  Future<void> _refreshValues() async {
    final rootValue = await readFromRootIsolate();
    final childValue = await readFromChildIsolate();
    setState(() {
      _rootIsolateValue = rootValue.toString();
      _childIsolateValue = childValue.toString();
    });
  }
}

Future<void> writeFromRootIsolate(int value) async {
  const platform = MethodChannel('shared_memory_example');
  await platform.invokeMethod('writeData', {'value': value});
}

Future<int> readFromRootIsolate() async {
  const platform = MethodChannel('shared_memory_example');
  return await platform.invokeMethod('readData') as int;
}

Future<void> writeFromChildIsolate(int value) async {
  const platform = MethodChannel('shared_memory_example');
  final rootIsolateToken = RootIsolateToken.instance;
  await Isolate.run(() async {
    if (rootIsolateToken != null) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    }
    await platform.invokeMethod('writeData', {'value': value});
  });
}

Future<int> readFromChildIsolate() async {
  const platform = MethodChannel('shared_memory_example');
  final rootIsolateToken = RootIsolateToken.instance;
  return await Isolate.run(() async {
    if (rootIsolateToken != null) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    }
    return await platform.invokeMethod('readData') as int;
  });
}
