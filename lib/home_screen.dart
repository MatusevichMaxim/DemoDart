import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/counter'),
            child: Text('Open Screen'),
          ),
        ),
      );
}