import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_playground/boundry_creator.dart';
import 'package:flame_playground/my_girl.dart';
import 'package:flame_playground/my_ground.dart';
import 'package:flame_playground/my_platform.dart';
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

class MyForge2DFlameGame extends Forge2DGame with HasDraggables, HasTappables {
  late final JoystickComponent joystickComponent;
  late final MyGirl myGirl;
  late final HudButtonComponent shapeButton;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = false;
    var gameSize = screenToWorld(camera.viewport.effectiveSize);
    addAll(createBoundaries(this));
    add(MyPlatform(gameSize / 2));
    add(MyGround(gameSize));


    final knobPaint = BasicPalette.red.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystickComponent = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 60, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    myGirl = MyGirl(gameSize, joystickComponent);

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
    );


    add(myGirl);
    add(shapeButton);
    add(joystickComponent);
  }

  // @override
  // void update(double dt){
  //   super.update(dt);
  // }
}
