import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(GameWidget(game: MyForge2DFlameGame(), overlayBuilderMap: {
    'PauseMenu': (BuildContext context, MyForge2DFlameGame game) {
      return const Text('A pause menu');
    },
  }));
}

class MyForge2DFlameGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = false;
    add(MyCircle(Vector2(20, 3)));
    add(MyCircle(Vector2(10, 3)));
    add(MyGround(screenToWorld(camera.viewport.effectiveSize)));
  }
}

class MyCircle extends BodyComponent {
  final Vector2 initialPosition;

  MyCircle(this.initialPosition);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    SpriteAnimationData spriteData =
        SpriteAnimationData.sequenced(amount: 9, stepTime: 0.03, textureSize: Vector2(152.0, 142.0));
    SpriteAnimation spriteAnimation = await gameRef.loadSpriteAnimation("red_girl/girl_gliding_sheet.png", spriteData);
    var girlAnimation = SpriteAnimationComponent()
      ..animation = spriteAnimation
      ..size = Vector2.all(12)
      ..anchor = Anchor.center;
    add(girlAnimation);
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 6;
    final fixtureDefinition = FixtureDef(shape, density: 1, restitution: 0.4, friction: 0.2);
    final bodyDefinition = BodyDef(position: initialPosition, type: BodyType.dynamic);
    return world.createBody(bodyDefinition)..createFixture(fixtureDefinition);
  }
}

class MyGround extends BodyComponent {
  final Vector2 gameSize;

  MyGround(this.gameSize);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(Vector2(0, gameSize.y - 3), Vector2(gameSize.x, gameSize.y - 3));
    final fixtureDefinition = FixtureDef(shape, friction: 1);
    final bodyDefinition = BodyDef(position: Vector2.zero(), userData: this);
    return world.createBody(bodyDefinition)..createFixture(fixtureDefinition);
  }
}
