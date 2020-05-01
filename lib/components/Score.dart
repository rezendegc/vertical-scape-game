import 'dart:ui';
import 'package:flame/components/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lava_scape/world.dart';

class ScoreDisplay extends Component {
  final VulcanWorld game;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  ScoreDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Colors.white,
      fontSize: 60,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xff000000),
          offset: Offset(2, 2),
        ),
      ],
    );

    position = Offset.zero;
  }

  bool isHud() => true;

  void render(Canvas canvas) {
    painter.paint(canvas, position);
  }

  void update(double t) {
    if ((painter.text?.toPlainText()) != game.score.toString()) {
      painter.text = TextSpan(
        text: game.score.toString(),
        style: textStyle,
      );

      painter.layout();

      position = Offset(
        (game.viewport.size.width / 2) - (painter.width / 2),
        64,
      );
    }
  }
}
