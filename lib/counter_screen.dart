import 'package:flutter/material.dart';

class CounterModel {
  int _value = 0;
  int get value => _value;

  set value(int newValue) {
    if (newValue >= 0) {
      _value = newValue;
    } else {
      _value = 0;
    }
  }

  void increment() => value = _value + 1;
  void decrement() => value = _value - 1;
  void incrementByWeek() => value = _value + 7;
  void decrementByWeek() => value = _value - 7;
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

  void _incrementBy7() {
    setState(() => _counter.incrementByWeek());
  }

  void _decrement() {
    setState(() => _counter.decrement());
  }

  void _decrementBy7() {
    setState(() => _counter.decrementByWeek());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Counter')),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _decrementBy7, child: Text('-7')),
              SizedBox(width: 10),
              ElevatedButton(onPressed: _decrement, child: Text('-')),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('${_counter.value}', style: TextStyle(fontSize: 24)),
              ),
              ElevatedButton(onPressed: _increment, child: Text('+')),
              SizedBox(width: 10),
              ElevatedButton(onPressed: _incrementBy7, child: Text('+7')),
            ],
          ),
        ),
      );
}