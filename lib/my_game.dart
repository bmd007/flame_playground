import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'enemy.dart';
import 'my_girl.dart';
import 'my_platform.dart';
import 'wall.dart';

class MyForge2DFlameGame extends Forge2DGame with HasDraggables, HasTappables {
  late final JoystickComponent joystickComponent;
  late final MyGirl myGirl;
  late final HudButtonComponent shapeButton;
  late final TextComponent playerLifeIndicator;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = false;

    final knobPaint = BasicPalette.red.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystickComponent = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: knobPaint),
      background: CircleComponent(radius: 45, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 50, bottom: 50),
    )..positionType = PositionType.viewport;
    await add(joystickComponent);

    myGirl = MyGirl(joystickComponent, size / 2.5);
    await add(myGirl);

    final shootButton = HudButtonComponent(
        button: CircleComponent(radius: 20),
        buttonDown: RectangleComponent(
          size: Vector2(10, 10),
          paint: BasicPalette.blue.paint(),
        ),
        margin: const EdgeInsets.only(
          right: 80,
          bottom: 80,
        ),
        onPressed: () async {
          await myGirl.throwKanui();
        })
      ..positionType = PositionType.viewport;
    add(shootButton);

    playerLifeIndicator = TextComponent()
      ..size = Vector2(0.1, 0.1)
      ..positionType = PositionType.viewport
      ..anchor = Anchor.bottomCenter
      ..position = Vector2(size.x, size.y)
      ..textRenderer = TextPaint(style: TextStyle(color: BasicPalette.white.color, fontSize: 20));
    await add(playerLifeIndicator);
    myGirl.playerLife.addListener(() => playerLifeIndicator.text = "lives: ${myGirl.playerLife.value}");

    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(MyPlatform(size / 2.5));
    add(MyPlatform(size / 2.3));
    add(MyPlatform(size / 2.1));
    add(Enemy(size / 2.1));

    // camera.viewport = FixedResolutionViewport(Vector2.all(maxSide));
    var bottom = size.y;
    var right = size.x + 100;
    final Vector2 topLeft = Vector2.zero();
    final Vector2 bottomLeft = Vector2(0, bottom);
    final Vector2 bottomRight = Vector2(right, bottom);
    final Vector2 topRight = Vector2(right, 0);
    add(Wall(topLeft, topRight));
    add(Wall(topRight, bottomRight));
    add(Wall(bottomLeft, topLeft));
    add(Wall(bottomRight, bottomLeft));
    camera.followBodyComponent(myGirl, useCenterOfMass: true);
    camera.worldBounds = Rect.fromLTRB(0, 0, right, bottom);
  }
}
