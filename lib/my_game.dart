import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_playground/my_girl_kanui.dart';
import 'package:flutter/material.dart';

import 'boundary_creator.dart';
import 'my_girl.dart';
import 'my_platform.dart';

class MyForge2DFlameGame extends Forge2DGame with HasDraggables, HasTappables {
  late final JoystickComponent joystickComponent;
  late final MyGirl myGirl;
  late final HudButtonComponent shapeButton;
  late final MyGirlKanui myGirlKanui;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = false;
    var screenSize = screenToWorld(camera.viewport.effectiveSize);
    print(screenSize);
    addAll(createBoundaries(this));
    for (double i = 0; i <= 87; i = i + 7) {
      add(MyPlatform(Vector2(87 - i, 87 - i)));
    }

    final knobPaint = BasicPalette.red.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystickComponent = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: knobPaint),
      background: CircleComponent(radius: 60, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(joystickComponent);

    myGirl = MyGirl(screenSize, joystickComponent);
    add(myGirl);

    final shapeButton = HudButtonComponent(
      button: CircleComponent(radius: 20),
      buttonDown: RectangleComponent(
        size: Vector2(10, 10),
        paint: BasicPalette.blue.paint(),
      ),
      margin: const EdgeInsets.only(
        right: 85,
        bottom: 150,
      ),
        onPressed: () {myGirl.throwKanui();
      world.bodies.where((element) => element.isBullet()).forEach((element) => element.linearVelocity.x = 30);
      }
    );

    add(shapeButton);

    add(MyGirlKanui(screenSize/2));
    add(MyGirlKanui(screenSize/2));
    add(MyGirlKanui(screenSize/2));
  }
}
