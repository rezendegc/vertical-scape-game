import 'dart:ui';
import 'package:flame/box2d/box2d_game.dart';
import 'package:flame/flame.dart';
import 'package:flame/gestures.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';
import 'package:lava_scape/components/Score.dart';
import 'package:lava_scape/world.dart';

TextConfig regular = TextConfig(color: Colors.white);

class LavaGame extends Box2DGame with TapDetector {
  VulcanWorld world;

  LavaGame(this.world) : super(world) {
    initialize();
  }

  void initialize() async {
    final size = await Flame.util.initialDimensions();
    resize(size);
    world.initializeWorld();
    add(ScoreDisplay(world));
  }

  void resize(Size size) {
    super.resize(size);
    world.resize(size);
  }

  void onTapDown(TapDownDetails details) {
    world.handleTap();
  }
}
