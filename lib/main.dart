import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:lava_scape/game.dart';
import 'package:lava_scape/world.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  VulcanWorld world = VulcanWorld();
  LavaGame game = LavaGame(world);

  runApp(game.widget);
  
  Util flameUtil = Util();
  flameUtil.fullScreen();
  flameUtil.setOrientation(DeviceOrientation.portraitUp);
}