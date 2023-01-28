import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Mahdi<MyForge2DFlameGame> extends BodyComponent with ContactCallbacks {
  bool lookingTowardRight = true;
  bool landedSinceLastElevation = false;
  final double speed = 20;
  final Vector2 initialPosition;
  late final SpriteComponent component;

  Mahdi(this.initialPosition);

  @override
  void update(double dt) {
    super.update(dt);
    landedSinceLastElevation = body.linearVelocity.y == 0;
    if (landedSinceLastElevation) {
      body.linearVelocity.x = 0;
      var direction = directions[Random.secure().nextInt(directions.length)];
      move(dt, direction, Vector2(1, 1));
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    component = SpriteComponent()
      ..sprite = await gameRef.loadSprite("mahdi/mahdi_head.png")
      ..size = Vector2.all(9)
      ..anchor = Anchor.center;
    add(component);
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 3.6;
    final fixtureDefinition = FixtureDef(shape, density: 2, restitution: 0.1, friction: 2);
    final bodyDefinition = BodyDef(position: initialPosition, type: BodyType.dynamic)
      ..fixedRotation = true
      ..userData = this;
    return world.createBody(bodyDefinition)..createFixture(fixtureDefinition);
  }


  void move(double dt, JoystickDirection direction, Vector2 relativeDelta) {
    if (direction == JoystickDirection.down) {
      if (landedSinceLastElevation) {
        body.linearVelocity.x = 0;
      }
    } else if (direction == JoystickDirection.downLeft || direction == JoystickDirection.left) {
      if (lookingTowardRight) {
        component.flipHorizontally();
      }
      lookingTowardRight = false;
      if (body.linearVelocity.y == 0) {
        body.linearVelocity = Vector2(relativeDelta.x * -speed, body.linearVelocity.y);
      }
    } else if (direction == JoystickDirection.downRight || direction == JoystickDirection.right) {
      if (!lookingTowardRight) {
        component.flipHorizontally();
      }
      lookingTowardRight = true;
      if (body.linearVelocity.y == 0) {
        body.linearVelocity = Vector2(relativeDelta.x * speed, body.linearVelocity.y);
      }
    } else if (direction == JoystickDirection.up && landedSinceLastElevation) {
      landedSinceLastElevation = false;
      body.applyLinearImpulse(Vector2(0, relativeDelta.x * -50));
    } else if (direction == JoystickDirection.upLeft && landedSinceLastElevation) {
      if (lookingTowardRight) {
        component.flipHorizontally();
      }
      lookingTowardRight = false;
      landedSinceLastElevation = false;
      body.linearVelocity.x = 0;
      body.applyLinearImpulse(Vector2(relativeDelta.x * 50, relativeDelta.y * 50));
    } else if (direction == JoystickDirection.upRight && landedSinceLastElevation) {
      if (!lookingTowardRight) {
        component.flipHorizontally();
      }
      lookingTowardRight = true;
      body.linearVelocity.x = 0;
      landedSinceLastElevation = false;
      body.applyLinearImpulse(Vector2(relativeDelta.x * 50, relativeDelta.y * 50));
    }
  }

  List<JoystickDirection> directions = [
    JoystickDirection.upLeft,
    JoystickDirection.upRight,
    JoystickDirection.up,
    JoystickDirection.up,
    JoystickDirection.up,
    JoystickDirection.up,
    JoystickDirection.up,
    JoystickDirection.up,
    JoystickDirection.up,
    JoystickDirection.up,
    JoystickDirection.up,
    JoystickDirection.up,
    JoystickDirection.up,
    JoystickDirection.up,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.upRight,
    JoystickDirection.downRight,
    JoystickDirection.downRight,
    JoystickDirection.downRight,
    JoystickDirection.downLeft,
    JoystickDirection.downLeft,
    JoystickDirection.downLeft,
    JoystickDirection.downLeft,
    JoystickDirection.downLeft,
    JoystickDirection.downLeft,
    JoystickDirection.downLeft,
    JoystickDirection.downLeft,
    JoystickDirection.downLeft,
  ];
}
