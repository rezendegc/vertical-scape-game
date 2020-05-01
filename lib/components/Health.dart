import 'package:flame/components/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lava_scape/world.dart';

class HealthDisplay extends Component {
  Rect currentHealthRect;
  TextPainter textPainter;
  Offset textPosition;
  VulcanWorld world;

  bool first = true;

  int priority() => 100;

  HealthDisplay(this.world) {
    currentHealthRect = Rect.fromLTWH(0, 0, world.viewport.size.width, 20);

    textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: "HEALTH",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );

    textPainter.layout();

    textPosition = Offset((world.viewport.size.width / 2) - (textPainter.width / 2), 0);
  }

  void update(dt) {
    final healthPercentage = world.player.currentHealth / world.player.maxHealth;

    currentHealthRect =
        Rect.fromLTWH(0, 0, healthPercentage * world.viewport.size.width, 20);
  }

  void render(canvas) {
    canvas.drawRect(currentHealthRect, Paint()..color = Colors.redAccent);
    textPainter.paint(canvas, textPosition);
  }

  bool isHud() => true;
}
