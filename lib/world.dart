import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/rendering.dart';
import 'package:lava_scape/components/Player.dart';

import 'levels/demo.dart';

class VulcanWorld extends Box2DComponent {
  PlayerComponent player;
  int score = 0;
  double playerSpeed = 50;

  int priority() => 1;

  VulcanWorld() : super(gravity: -100);

  void initializeWorld() {
    player = PlayerComponent(this);
    addAll(DemoLevel(this).bodies);
    add(player);
  }

  void handleTap() {
    player.jump();
  }
}