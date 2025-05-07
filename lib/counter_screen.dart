import 'package:flutter/material.dart';

class CounterModel {
  int _value = 0;
  int get value => _value;

  void increment() => _value++;
  void decrement() {
    if (_value > 0) _value--;
  }
}

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final CounterModel _counter = CounterModel();

  void _increment() {
    setState(() => _counter.increment());
  }

  void _decrement() {
    setState(() => _counter.decrement());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Counter')),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _decrement, child: Text('-')),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('${_counter.value}', style: TextStyle(fontSize: 24)),
              ),
              ElevatedButton(onPressed: _increment, child: Text('+')),
            ],
          ),
        ),
      );
}