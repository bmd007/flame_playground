import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_playground/mahdi.dart';
import 'package:flutter/material.dart';

import 'enemy.dart';
import 'my_girl.dart';
import 'wall.dart';

class MyForge2DFlameGame extends Forge2DGame with HasDraggables, HasTappables {
  late final JoystickComponent joystickComponent;
  late final MyGirl myGirl;
  late final HudButtonComponent shapeButton;
  late final TextComponent playerLifeIndicator;
  late final TextComponent numberOfKanuies;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = false;

    camera.viewport = FixedResolutionViewport(Vector2(1366, 768));
    var right = size.x + 100;
    var bottom = size.y;
    final Vector2 topLeft = Vector2.zero() + Vector2(5, 5);
    final Vector2 topRight = Vector2(right, 0) + Vector2(-5, 5);
    final Vector2 bottomLeft = Vector2(0, bottom) + Vector2(5, -5);
    final Vector2 bottomRight = Vector2(right, bottom) + Vector2(-5, -5);
    add(Wall(topLeft, topRight));
    add(Wall(topRight, bottomRight));
    add(Wall(bottomLeft, topLeft));
    add(Wall(bottomRight, bottomLeft));
    camera.worldBounds = Rect.fromLTRB(0, 0, right, bottom);

    SpriteComponent background = SpriteComponent()
      ..sprite = await loadSprite("background.jpeg")
      ..position = Vector2(5, 5)
      ..size = Vector2(right - 10, bottom - 10)
      ..anchor = Anchor.topLeft;
    add(background);

    final knobPaint = BasicPalette.red.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystickComponent = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 70, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 50, bottom: 100),
    )..positionType = PositionType.viewport;
    await add(joystickComponent);

    myGirl = MyGirl(joystickComponent, size / 2.5);
    await add(myGirl);
    camera.followBodyComponent(myGirl, useCenterOfMass: true);

    final shootButton = HudButtonComponent(
        button: CircleComponent(radius: 30),
        buttonDown: RectangleComponent(
          size: Vector2(100, 100),
          paint: BasicPalette.blue.paint(),
        ),
        margin: const EdgeInsets.only(
          right: 50,
          bottom: 130,
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
      ..textRenderer = TextPaint(
          style: TextStyle(color: BasicPalette.white.color, fontSize: 20));
    await add(playerLifeIndicator);
    myGirl.playerLife.addListener(
        () => playerLifeIndicator.text = "lives: ${myGirl.playerLife.value}");

    numberOfKanuies = TextComponent()
      ..size = Vector2(0.1, 0.1)
      ..positionType = PositionType.viewport
      ..anchor = Anchor.bottomCenter
      ..position = Vector2(size.x, size.y + 100)
      ..textRenderer = TextPaint(
          style: TextStyle(color: BasicPalette.white.color, fontSize: 20));
    numberOfKanuies.text = "kanuies: ${myGirl.kanuies.value}";
    await add(numberOfKanuies);
    myGirl.kanuies.addListener(
        () => numberOfKanuies.text = "kanuies: ${myGirl.kanuies.value}");

    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(Enemy(size / 2.5));
    add(Mahdi(size / 6));
  }
}
