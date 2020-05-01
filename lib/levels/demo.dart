import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/widgets.dart';
import 'package:lava_scape/components/Coin.dart';
import 'package:lava_scape/components/Obstacle.dart';
import 'package:lava_scape/components/WinZone.dart';

class DemoLevel {
  List<BodyComponent> _bodies = List();

  DemoLevel(Box2DComponent box) {
    _bodies.add(ObstacleBody(box, 0.1, 2, Alignment.bottomLeft, Offset(-0.2, 0))); // left-most wall.
    _bodies.add(ObstacleBody(box, 0.1, 2, Alignment.bottomRight, Offset(0.2, 0))); // right-most wall.
    _bodies.add(ObstacleBody(box, 1.0, 0.1, Alignment.bottomCenter, Offset(0, 0))); // bottom platform
    _bodies.add(WinZoneBody(box, Alignment.bottomCenter, Offset(0, 1.7))); // reach this to win
    // from here you should add the level obstacles
    _bodies.add(ObstacleBody(box, 0.2, 0.05, Alignment.bottomLeft, Offset(0, 0.3)));
    _bodies.add(ObstacleBody(box, 0.5, 0.03, Alignment.bottomRight, Offset(0, 0.4)));
    _bodies.add(CoinBody(box, Alignment.bottomRight, Offset(-0.2, 0.51)));
  }

  List<BodyComponent> get bodies => _bodies;
}
