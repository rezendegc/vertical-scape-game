import 'dart:ui';
import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lava_scape/components/Coin.dart';
import 'package:lava_scape/components/Obstacle.dart';
import 'package:lava_scape/world.dart';

enum ContactSide { TOP, BOTTOM, LEFT, RIGHT }
const DISTANCE_TO_EDGE = 0.2;

class PlayerComponent extends BodyComponent implements ContactListener {
  VulcanWorld myWorld;
  double height = 0;
  double width = 0;
  bool forward = false;
  bool onAir = false;
  bool jumping = false;
  double maxHealth = 100;
  double currentHealth = 100;

  PlayerComponent(this.myWorld) : super(myWorld) {
    _createBody();
  }

  @override
  void update(double dt) {
    forward = body.linearVelocity.x >= 0.0;
    onAir = body.linearVelocity.y.abs() >= 0.001;
    final maxCameraDistance = viewport.size.height * 0.1 + height / 2;
    final cameraDistance =
        viewport.size.height - viewport.getWorldToScreen(body.worldCenter).y;
    final difference = maxCameraDistance - cameraDistance;

    body.linearVelocity = Vector2(myWorld.playerSpeed * (forward ? 1 : -1), body.linearVelocity.y);

    // moves camera to player when it reaches new platform
    if (difference > 0.4) {
      double step = -50 * dt;
      if (step.abs() > cameraDistance.abs()) step = -cameraDistance.abs();
      myWorld.translateCamera(0, step);
    } else if (difference < -0.4 && !onAir && !jumping) {
      double step = 50 * dt;
      if (step.abs() > cameraDistance.abs()) step = cameraDistance.abs();
      myWorld.translateCamera(0, step);
    }

    // for now it will lose health on time
    // currentHealth -= dt * 5;
    if (currentHealth < 0) {
      currentHealth = 0;
      myWorld.loseGame();
    }
  }

  void renderPolygon(Canvas canvas, List<Offset> points) {
    canvas.drawRect(Rect.fromPoints(points.elementAt(0), points.elementAt(2)),
        Paint()..color = Colors.red);
  }

  void _createBody() {
    width = viewport.size.width * 0.05;
    height = viewport.size.height * 0.05;

    double x = 0;
    double y = -viewport.size.height / 2 + height * 3;

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
      jumping = true;
      body.applyForceToCenter(
          Vector2(0, viewport.size.height / 8)..scale(10000));
    }
  }

  void interruptJump() {
    if (body.linearVelocity.y > 0) {
      body.applyLinearImpulse(
          Vector2(0, body.linearVelocity.y)
            ..scale(-15 * viewport.size.height / 600.0),
          center,
          true);
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

    if ((playerBottom - obstacleTop).abs() < DISTANCE_TO_EDGE) {         // bottom
      jumping = false;
    } else if ((playerTop - obstacleBottom).abs() < DISTANCE_TO_EDGE) {  // top
    } else if ((playerLeft - obstacleRight).abs() < DISTANCE_TO_EDGE) {  // left
    } else if ((playerRight - obstacleLeft).abs() < DISTANCE_TO_EDGE) {  // right
    }
  }

  void _solveCoinContact(CoinBody coinBody) {
    if (coinBody.shouldDestroy != true) {
      myWorld.score++;
      coinBody.shouldDestroy = true;
    }
  }

  void beginContact(contact) {
    Fixture fixture = contact.fixtureB.userData == 'player'
        ? contact.fixtureA
        : contact.fixtureB;

    if (fixture.userData == 'obstacle') {
      _solveObstacleContact(fixture.getBody().userData);
    } else if (fixture.userData == 'coin') {
      _solveCoinContact(fixture.getBody().userData);
    } else if (fixture.userData == 'winZone') {
      myWorld.winGame();
    }
  }

  void endContact(contact) {}

  void postSolve(contact, impulse) {}

  void preSolve(contact, oldManifold) {}
}
