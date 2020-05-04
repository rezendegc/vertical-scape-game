import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/rendering.dart';
import 'package:lava_scape/components/Player.dart';

import 'levels/demo.dart';

class VulcanWorld extends Box2DComponent {
  PlayerComponent player;
  bool initialized = false;
  int score = 0;
  double playerSpeed = 100;
  Offset _cameraOffset;
  Function(String) navigate;
  bool pause = false;

  VulcanWorld(this.navigate) : super(gravity: -100);

  void initializeWorld() {
    player = PlayerComponent(this);
    _cameraOffset = Offset(viewport.size.width/2, viewport.size.height/2);
    addAll(DemoLevel(this).bodies);
    add(player);

    initialized = true;
  }

  void update(double dt) {
    if (pause) return;
    if (initialized) {
      viewport.setCamera(_cameraOffset?.dx, _cameraOffset?.dy, 1);
    }
    super.update(dt);
  }

  void translateCamera(double x, double y) {
    _cameraOffset = _cameraOffset.translate(x, y);
  }

  Offset get cameraOffset => _cameraOffset;

  void handleTap() {
    player.jump();
  }

  void handleFinishTap() {
    player.interruptJump();
  }

  void winGame() {
    pause = true;
    navigate('/won');
  }

  void loseGame() {
    pause = true;
    navigate('/lost');
  }
}