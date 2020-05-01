import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:lava_scape/game.dart';
import 'package:lava_scape/screens/Home.dart';
import 'package:lava_scape/screens/Lost.dart';
import 'package:lava_scape/screens/Won.dart';
import 'package:lava_scape/world.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
  
  Util flameUtil = Util();
  flameUtil.fullScreen();
  flameUtil.setOrientation(DeviceOrientation.portraitUp);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First Flutter/Flame Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => Home(),
        '/lost': (context) => LostScreen(),
        '/won': (context) => WonScreen(),
        '/play': (context) {
          VulcanWorld world = VulcanWorld((String name) => Navigator.of(context).pushReplacementNamed(name));
          LavaGame game = LavaGame(world);
          return game.widget;
        }
      },
    );
  }
}