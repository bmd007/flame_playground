import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_playground/my_game.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(GameWidget(game: MyForge2DFlameGame(), overlayBuilderMap: {
    'PauseMenu': (BuildContext context, MyForge2DFlameGame game) {
      return const Text('A pause menu');
    },
  }));
}
