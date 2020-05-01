import 'package:flutter/material.dart';

class WonScreen extends StatelessWidget {
  const WonScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pushNamed('/play'),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text("You Won", style: TextStyle(fontSize: 40)),
              const SizedBox(height: 100),
              Text("Type anywhere to restart..."),
            ],
          ),
        ),
      ),
    );
  }
}
