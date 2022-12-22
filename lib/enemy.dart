import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_playground/bullet.dart';

class Enemy extends BodyComponent {
  SpriteAnimationData runningAnimationDate =
      SpriteAnimationData.sequenced(amount: 9, stepTime: 0.03, textureSize: Vector2(375.0, 520.0));
  SpriteAnimationData idleAnimationData =
      SpriteAnimationData.sequenced(amount: 9, stepTime: 0.03, textureSize: Vector2(290.0, 500.0));
  SpriteAnimationData jumpingAnimationData =
      SpriteAnimationData.sequenced(amount: 9, stepTime: 0.03, textureSize: Vector2(399.0, 543.0));
  SpriteAnimationData dyingAnimationData =
      SpriteAnimationData.sequenced(amount: 9, stepTime: 0.03, textureSize: Vector2(399.0, 543.0));
  late SpriteAnimation runningAnimation;
  late SpriteAnimation idleAnimation;
  late SpriteAnimation jumpingAnimation;
  late SpriteAnimation dyingAnimation;
  bool lookingTowardRight = true;
  bool landedSinceLastElevation = false;
  final double speed = 20;
  final Vector2 initialPosition;
  late SpriteAnimationComponent component;

  Enemy(this.initialPosition);

  @override
  void update(double dt) {
    super.update(dt);
    if (dt.ceil() % 3 == 0) {
      shootBullet();
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    runningAnimation = await gameRef.loadSpriteAnimation("TeamGunner/CHARACTER_SPRITES/Green/Gunner_Green_Run.png", runningAnimationDate);
    idleAnimation = await gameRef.loadSpriteAnimation("TeamGunner/CHARACTER_SPRITES/Green/Gunner_Green_Idle.png", idleAnimationData);
    jumpingAnimation = await gameRef.loadSpriteAnimation("TeamGunner/CHARACTER_SPRITES/Green/Gunner_Green_Jump.png", jumpingAnimationData);
    dyingAnimation = await gameRef.loadSpriteAnimation("TeamGunner/CHARACTER_SPRITES/Green/Gunner_Green_Death.png", dyingAnimationData);

    component = SpriteAnimationComponent()
      ..animation = idleAnimation
      ..size = Vector2.all(6)
      ..anchor = Anchor.center;
    add(component);
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(3, 3);
    final fixtureDefinition = FixtureDef(shape, density: 2, restitution: 0.1, friction: 2);
    final bodyDefinition = BodyDef(position: initialPosition, type: BodyType.dynamic)..fixedRotation = true;
    return world.createBody(bodyDefinition)..createFixture(fixtureDefinition);
  }

  shootBullet() async {
    Bullet bullet = Bullet(component.position);
    await parent?.add(bullet);
    bullet.body.linearVelocity.x = lookingTowardRight ? 30 : -30;
    bullet.body.linearVelocity.y = 30;
  }
}
