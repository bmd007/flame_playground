import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'boundary_creator.dart';
import 'enemy.dart';
import 'my_girl.dart';
import 'my_platform.dart';

class MyForge2DFlameGame extends Forge2DGame with HasDraggables, HasTappables {
  late final JoystickComponent joystickComponent;
  late final MyGirl myGirl;
  late final HudButtonComponent shapeButton;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = false;

    // camera.viewport = FixedResolutionViewport(Vector2.all(maxSide));
    addAll(createBoundaries(size));

    final knobPaint = BasicPalette.red.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystickComponent = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: knobPaint),
      background: CircleComponent(radius: 60, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 30, bottom: 20),
    );
    await add(joystickComponent);

    myGirl = MyGirl(joystickComponent, size / 2);
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
        });
    add(shootButton);

    add(Enemy(size / 1.47));
    add(Enemy(size / 2.5));
    add(MyPlatform(size / 1.5));
    add(MyPlatform(size / 2.5));

    add(Enemy(size / 1.3));
    add(MyPlatform(size / 1.3));

    add(Enemy(size / 2.1));
    add(MyPlatform(size / 1.05));

    camera.followBodyComponent(myGirl, useCenterOfMass: false);
  }
}
