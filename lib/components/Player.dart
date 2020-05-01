import 'dart:ui';
import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lava_scape/components/Obstacle.dart';
import 'package:lava_scape/world.dart';

enum ContactSide { TOP, BOTTOM, LEFT, RIGHT }
const DISTANCE_TO_EDGE = 0.2;

class PlayerComponent extends BodyComponent implements ContactListener {
  VulcanWorld myWorld;
  double height = 0;
  double width = 0;
  bool forward = false;

  PlayerComponent(this.myWorld) : super(myWorld) {
    _createBody();
  }

  @override
  void update(double dt) {
    forward = body.linearVelocity.x >= 0.0;

    /* this line was added to prevent player from stop from falls/jumps */
    // body.linearVelocity = Vector2(myWorld.playerSpeed * (forward ? 1 : -1), body.linearVelocity.y);
  }

  void renderPolygon(Canvas canvas, List<Offset> points) {
    canvas.drawRect(Rect.fromPoints(points.elementAt(0), points.elementAt(2)),
        Paint()..color = Colors.red);
  }

  void _createBody() {
    width = viewport.size.width * 0.05;
    height = viewport.size.height * 0.05;

    double x = 0;
    double y = -viewport.size.height / 2 + height * 8; // change this to height*3 to make it dont stop on start fall

    final shape = new PolygonShape();
    shape.setAsBoxXY(width / 2, height / 2);

    final activeFixtureDef = FixtureDef();
    activeFixtureDef.shape = shape;
    activeFixtureDef.restitution = 0.0;
    activeFixtureDef.density = 0.05;
    activeFixtureDef.friction = 0.0;
    activeFixtureDef.userData = 'player';
    FixtureDef fixtureDef = activeFixtureDef;

    final activeBodyDef = BodyDef();
    activeBodyDef.linearVelocity = Vector2(myWorld.playerSpeed, 0);
    activeBodyDef.position = Vector2(x, y);
    activeBodyDef.type = BodyType.DYNAMIC;
    activeBodyDef.active = true;
    activeBodyDef.fixedRotation = true;
    BodyDef bodyDef = activeBodyDef;

    this.body = world.createBody(bodyDef)
      ..createFixtureFromFixtureDef(fixtureDef);
    body.userData = this;

    myWorld.world.setContactListener(this);
  }

  void jump() {
    if (body.linearVelocity.y.abs() <= 0.01) {
      body.linearVelocity.y = 0; // this line doesn't made any difference, can commit it
      body.applyForceToCenter(Vector2(0, 200)..scale(10000));
    }
  }

  void _solveObstacleContact(ObstacleBody obstacleBody) {
    final obstacleCenter = obstacleBody.body.worldCenter;
    final obstacleHeight = obstacleBody.height;
    final obstacleWidth = obstacleBody.width;
    final obstacleBottom = (obstacleCenter.y - obstacleHeight / 2);
    final obstacleTop = (obstacleCenter.y + obstacleHeight / 2);
    final obstacleLeft = (obstacleCenter.x - obstacleWidth / 2);
    final obstacleRight = (obstacleCenter.x + obstacleWidth / 2);

    final playerBottom = (body.worldCenter.y - height / 2);
    final playerTop = (body.worldCenter.y + height / 2);
    final playerLeft = (body.worldCenter.x - width / 2);
    final playerRight = (body.worldCenter.x + width / 2);

    // this solves from where the collision came from..
    // obviously not 100%, but should work for my purposes
    if ((playerBottom - obstacleTop).abs() < DISTANCE_TO_EDGE) {         // bottom
    }
    if ((playerTop - obstacleBottom).abs() < DISTANCE_TO_EDGE) {  // top
    }
    if ((playerLeft - obstacleRight).abs() < DISTANCE_TO_EDGE) {  // left
      body.linearVelocity.x *= -1;
    }
    if ((playerRight - obstacleLeft).abs() < DISTANCE_TO_EDGE) {  // right
      body.linearVelocity.x *= -1;
    }
  }

  void beginContact(contact) {
    Fixture fixture = contact.fixtureB.userData == 'player'
        ? contact.fixtureA
        : contact.fixtureB;

    if (fixture.userData == 'obstacle') {
      _solveObstacleContact(fixture.getBody().userData);
    }
  }

  void endContact(contact) {}

  void postSolve(contact, impulse) {}

  void preSolve(contact, oldManifold) {}
}
