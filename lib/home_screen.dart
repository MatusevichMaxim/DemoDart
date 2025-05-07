import 'package:flutter/material.dart';
import 'counter_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CounterScreen())),
            child: Text('Open Screen'),
          ),
        ),
      );
}