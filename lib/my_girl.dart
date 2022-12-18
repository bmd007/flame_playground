import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class MyGirl extends BodyComponent {
  SpriteAnimationData glidingAnimationData =
      SpriteAnimationData.sequenced(amount: 9, stepTime: 0.03, textureSize: Vector2(152.0, 142.0));
  SpriteAnimationData runningAnimationDate =
      SpriteAnimationData.sequenced(amount: 9, stepTime: 0.03, textureSize: Vector2(375.0, 520.0));
  SpriteAnimationData idleAnimationData =
      SpriteAnimationData.sequenced(amount: 9, stepTime: 0.03, textureSize: Vector2(290.0, 500.0));
  late SpriteAnimation glidingAnimation;
  late SpriteAnimation runningAnimation;
  late SpriteAnimation idleAnimation;
  bool lookingTowardRight = true;
  bool landedSinceLastElevation = false;

  JoystickComponent joystick;
  late Vector2 initialPosition;
  late double groundLevel;
  late SpriteAnimationComponent girlComponent;

  MyGirl(Vector2 gameSize, this.joystick) {
    initialPosition = gameSize / 2;
    groundLevel = gameSize.y - 3;
    print(gameSize);
    print(groundLevel);
  }

  void move(JoystickDirection direction, Vector2 relativeDelta, double dt) {
    if (direction == JoystickDirection.down) {
      girlComponent.animation = idleAnimation;
      return;
    } else if (direction == JoystickDirection.downLeft ||
        direction == JoystickDirection.left) {
      if (lookingTowardRight) {
        girlComponent.flipHorizontally();
      }
      lookingTowardRight = false;
      girlComponent.animation = runningAnimation;
      body.applyLinearImpulse(Vector2(-10000, 0) * dt);
    } else if (direction == JoystickDirection.downRight ||
        direction == JoystickDirection.right) {
      if (!lookingTowardRight) {
        girlComponent.flipHorizontally();
      }
      lookingTowardRight = true;
      girlComponent.animation = runningAnimation;
      body.applyLinearImpulse(Vector2(10000, 0) * dt);
    } else if (direction == JoystickDirection.up && landedSinceLastElevation) {
      landedSinceLastElevation = false;
      body.applyLinearImpulse(Vector2(0, 1000000) * dt);
    } else if (direction == JoystickDirection.upRight && landedSinceLastElevation) {
      landedSinceLastElevation = false;
      if (!lookingTowardRight) {
        girlComponent.flipHorizontally();
      }
      lookingTowardRight = true;
      girlComponent.animation = runningAnimation;
      body.applyLinearImpulse(Vector2(1000000, 1000000) * dt);
    } else if (direction == JoystickDirection.upLeft && landedSinceLastElevation) {
      landedSinceLastElevation = false;
      if (lookingTowardRight) {
        girlComponent.flipHorizontally();
      }
      lookingTowardRight = false;
      girlComponent.animation = runningAnimation;
      body.applyLinearImpulse(Vector2(-1000000, 1000000) * dt);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    body.angularVelocity = 0;
    landedSinceLastElevation = body.linearVelocity.y == 0;

    if (body.linearVelocity.isZero() || (body.position.y < groundLevel) && (body.position.y > groundLevel - 10)) {
      girlComponent.animation = idleAnimation;
    } else if (body.linearVelocity.y > 0 && !(body.position.y > groundLevel - 5)) {
      girlComponent.animation = glidingAnimation;
    }
    if (!joystick.delta.isZero()) {
      move(joystick.direction, joystick.relativeDelta, dt);
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    glidingAnimation = await gameRef.loadSpriteAnimation("red_girl/gliding_spriteSheet.png", glidingAnimationData);
    runningAnimation = await gameRef.loadSpriteAnimation("red_girl/running_spriteSheet.png", runningAnimationDate);
    idleAnimation = await gameRef.loadSpriteAnimation("red_girl/idle_spriteSheet.png", idleAnimationData);

    girlComponent = SpriteAnimationComponent()
      ..animation = idleAnimation
      ..size = Vector2.all(12)
      ..anchor = Anchor.center;
    add(girlComponent);
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(6, 6);
    final fixtureDefinition = FixtureDef(shape, density: 1, restitution: 0.1, friction: 0.2);
    final bodyDefinition = BodyDef(position: initialPosition, type: BodyType.dynamic);
    return world.createBody(bodyDefinition)..createFixture(fixtureDefinition);
  }
}
