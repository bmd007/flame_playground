import 'dart:async' as async;
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'bullet.dart';
import 'my_girl_kanui.dart';

class Enemy extends BodyComponent with ContactCallbacks {
  SpriteAnimationData runningAnimationDate =
  SpriteAnimationData.sequenced(amount: 5, stepTime: 0.03, textureSize: Vector2(286 / 6, 48.0));
  SpriteAnimationData idleAnimationData =
  SpriteAnimationData.sequenced(amount: 4, stepTime: 0.03, textureSize: Vector2(240.0 / 5, 48));
  SpriteAnimationData jumpingAnimationData =
  SpriteAnimationData.sequenced(amount: 1, stepTime: 0.03, textureSize: Vector2(96.0 / 2, 48.0));
  SpriteAnimationData dyingAnimationData =
      SpriteAnimationData.sequenced(amount: 7, stepTime: 0.03, textureSize: Vector2(384.0 / 8, 48.0));
  late SpriteAnimation runningAnimation;
  late SpriteAnimation idleAnimation;
  late SpriteAnimation jumpingAnimation;
  late SpriteAnimation dyingAnimation;
  bool lookingTowardRight = true;
  bool landedSinceLastElevation = false;
  final double speed = 20;
  final Vector2 initialPosition;
  late SpriteAnimationComponent component;
  late async.Timer timer;

  Enemy(this.initialPosition);

  void move(double dt, JoystickDirection direction, Vector2 relativeDelta) {
    if (direction == JoystickDirection.down) {
      component.animation = idleAnimation;
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
      component.animation = runningAnimation;
    } else if (direction == JoystickDirection.downRight || direction == JoystickDirection.right) {
      if (!lookingTowardRight) {
        component.flipHorizontally();
      }
      lookingTowardRight = true;
      if (body.linearVelocity.y == 0) {
        body.linearVelocity = Vector2(relativeDelta.x * speed, body.linearVelocity.y);
      }
      component.animation = runningAnimation;
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
    JoystickDirection.downRight,
    JoystickDirection.downRight,
    JoystickDirection.downRight,
    JoystickDirection.downRight,
    JoystickDirection.downRight,
    JoystickDirection.downRight,
    JoystickDirection.downRight,
    JoystickDirection.downRight,
    JoystickDirection.downRight,
    JoystickDirection.downRight,
    JoystickDirection.downRight,
    JoystickDirection.downLeft,
    JoystickDirection.downLeft,
    JoystickDirection.downLeft,
  ];

  @override
  void update(double dt) {
    super.update(dt);
    landedSinceLastElevation = body.linearVelocity.y == 0;

    if (body.linearVelocity.y == 0) {
      component.animation = idleAnimation;
    } else if (body.linearVelocity.y != 0) {
      component.animation = jumpingAnimation;
    }
    if (landedSinceLastElevation) {
      body.linearVelocity.x = 0;
      var direction = directions[Random.secure().nextInt(directions.length)];
      move(dt, direction, Vector2(1, 1));
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = true;
    runningAnimation = await gameRef.loadSpriteAnimation(
        "TeamGunner/CHARACTER_SPRITES/Green/Gunner_Green_Run.png", runningAnimationDate);
    idleAnimation = await gameRef.loadSpriteAnimation(
        "TeamGunner/CHARACTER_SPRITES/Green/Gunner_Green_Idle.png", idleAnimationData);
    jumpingAnimation = await gameRef.loadSpriteAnimation(
        "TeamGunner/CHARACTER_SPRITES/Green/Gunner_Green_Jump.png", jumpingAnimationData);
    dyingAnimation = await gameRef.loadSpriteAnimation(
        "TeamGunner/CHARACTER_SPRITES/Green/Gunner_Green_Death.png", dyingAnimationData);

    component = SpriteAnimationComponent()
      ..animation = idleAnimation
      ..size = Vector2.all(7)
      ..anchor = Anchor.center;
    add(component);

    timer = async.Timer.periodic(const Duration(seconds: 1), (timer) {
      shootBullet();
    });
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 2.5;
    final fixtureDefinition = FixtureDef(shape, density: 2, restitution: 0.1, friction: 2);
    final bodyDefinition = BodyDef(position: initialPosition, type: BodyType.dynamic)
      ..fixedRotation = true
      ..userData = this;
    return world.createBody(bodyDefinition)..createFixture(fixtureDefinition);
  }

  shootBullet() async {
    var positionDelta = lookingTowardRight ? Vector2(component.x + 4, 0) : Vector2(-component.x - 4, 0);
    Bullet bullet = Bullet(body.position + positionDelta);
    await parent?.add(bullet);
    if (!lookingTowardRight) {
      component.flipHorizontally();
    }
    bullet.body.linearVelocity.x = lookingTowardRight ? 40 : -40;
    bullet.body.linearVelocity.y = 0;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is MyGirlKanui) {
      timer.cancel();
      removeFromParent();
    }
  }
}
