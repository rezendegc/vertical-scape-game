import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ObstacleBody extends BodyComponent with ContactFilter {
  double widthPercent;
  double heightPercent;
  double width;
  double height;
  Offset offset;
  Alignment alignment;
  Rect rect;

  bool first = true;

  ObstacleBody(
      Box2DComponent box, this.widthPercent, this.heightPercent, this.alignment, this.offset)
      : super(box) {
    _createBody();
  }

  void _createBody() {
    width = viewport.size.width * widthPercent;
    height = viewport.size.height * heightPercent;

    double x = alignment.x * (viewport.size.width - width) + (viewport.size.width * offset.dx);
    double y = (-alignment.y) * (viewport.size.height - height) + (viewport.size.height * offset.dy);

    final shape = PolygonShape();
    shape.setAsBoxXY(width / 2, height / 2);
    final fixtureDef = FixtureDef();
    fixtureDef.shape = shape;
    fixtureDef.restitution = 0.0;
    fixtureDef.friction = 0;
    fixtureDef.userData = 'obstacle';

    final bodyDef = BodyDef();
    bodyDef.position = Vector2(x / 2, y / 2);
    bodyDef.type = BodyType.STATIC;
    Body groundBody = world.createBody(bodyDef);
    groundBody.createFixtureFromFixtureDef(fixtureDef);
    this.body = groundBody;
    body.userData = this;
  }

  @override
  bool shouldCollide(Fixture fixtureA, Fixture fixtureB) {
    if (fixtureA.userData == 'obstacle' && fixtureB.userData == 'obstacle') {
      return false;
    }
    return true;
  }
}