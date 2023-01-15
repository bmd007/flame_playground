import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class MyPlatform extends BodyComponent {
  final Vector2 position;

  MyPlatform(this.position);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = true;
    var wall = SpriteComponent()
      ..sprite = await gameRef.loadSprite("Tiles/Tile_13.png")
      ..size = Vector2(10, 1)
      ..anchor = Anchor.topCenter;
    add(wall);
  }

  @override
  Body createBody() {
    PolygonShape shape = PolygonShape()..setAsBoxXY(5, 0.25);
    final fixtureDefinition = FixtureDef(shape, density: 1, restitution: 0.1, friction: 0.3);
    final bodyDefinition = BodyDef(position: position, type: BodyType.static)..userData = this;
    return world.createBody(bodyDefinition)..createFixture(fixtureDefinition);
  }
}
