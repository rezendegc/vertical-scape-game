import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WinZoneBody extends BodyComponent {
  Alignment alignment;
  Rect rect;
  TextPainter textPainter;

  int priority() => 1;

  WinZoneBody(Box2DComponent box, this.alignment, Offset offset) : super(box) {
    _createBody(offset);

    textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: "Reach here to win the level",
        style: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: 18,
        ),
      ),
    );

    textPainter.layout();
  }

  void renderPolygon(Canvas canvas, List<Offset> points) {
    canvas.drawRect(Rect.fromPoints(points.elementAt(0), points.elementAt(2)),
        Paint()..color = Colors.greenAccent.withOpacity(0.9));
  }

  void _createBody(Offset offset) {
    double width = viewport.size.width;
    double height = viewport.size.height;

    double x = alignment.x * (viewport.size.width - width) +
        (viewport.size.width * offset.dx);
    double y = (-alignment.y) * (viewport.size.height - height) +
        (viewport.size.height * offset.dy);

    final shape = PolygonShape();
    shape.setAsBoxXY(width / 2, height / 2);
    final fixtureDef = FixtureDef();
    fixtureDef.shape = shape;
    fixtureDef.restitution = 0.0;
    fixtureDef.friction = 0;
    fixtureDef.isSensor = true;
    fixtureDef.userData = 'winZone';

    final bodyDef = BodyDef();
    bodyDef.position = Vector2(x / 2, y / 2);
    bodyDef.type = BodyType.STATIC;
    Body groundBody = world.createBody(bodyDef);
    groundBody.createFixtureFromFixtureDef(fixtureDef);
    this.body = groundBody;
    body.userData = this;
  }
}
