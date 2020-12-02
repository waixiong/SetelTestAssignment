import 'package:flutter/material.dart';

// This page is shown if there's an route error
class UndefinedPage extends StatelessWidget {
  final String name;
  const UndefinedPage({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name'),
      ),
      body: Center(
        child: Text('Route for $name is not defined'),
      ),
    );
  }
}
