import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CoinBody extends BodyComponent {
  Offset offset;
  Alignment alignment;
  Rect rect;
  bool shouldDestroy = false;

  bool first = true;

  CoinBody(
      Box2DComponent box, this.alignment, this.offset)
      : super(box) {
    _createBody();
  }

  void renderCircle(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = Colors.yellowAccent);
  }

  bool destroy() => shouldDestroy;

  void _createBody() {
    double radius = viewport.size.width * 0.02;

    double x = alignment.x * (viewport.width) + (offset.dx * viewport.width);
    double y = (-alignment.y) * (viewport.height) + (offset.dy * viewport.height);

    final shape = CircleShape();
    shape.radius = radius;

    final fixtureDef = FixtureDef();
    fixtureDef.shape = shape;
    fixtureDef.userData = 'coin';
    fixtureDef.isSensor = true;

    final bodyDef = BodyDef();
    bodyDef.position = Vector2(x, y);
    bodyDef.type = BodyType.STATIC;

    Body groundBody = world.createBody(bodyDef);
    groundBody.createFixtureFromFixtureDef(fixtureDef);
    this.body = groundBody;
    body.userData = this;
  }
}