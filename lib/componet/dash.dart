import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flappy_bird/componet/hidden_coin.dart';
import 'package:flappy_bird/componet/pipe.dart';
import 'package:flappy_bird/flappy_dash_game.dart';
import 'package:flappy_bird/game/game_cubit.dart';
import 'package:flappy_bird/game/game_state.dart';

class Dash extends PositionComponent
    with
        CollisionCallbacks,
        HasGameRef<FlappyDashGame>,
        FlameBlocReader<GameCubit, GameState> {
  Dash()
      : super(
            position: Vector2(0, 0),
            size: Vector2.all(80),
            anchor: Anchor.center,
            priority: 10);

  late Sprite _dashSprite;
  final Vector2 _gravity = Vector2(0, 1000.0);
  Vector2 _velocity = Vector2(0, 0);
  final Vector2 _jumpForce = Vector2(0, -350);

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    _dashSprite = await Sprite.load("dash.png");
    await super.onLoad();
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    _velocity += _gravity * dt;
    position += _velocity * dt;
  }

  void jump() {
    _velocity = _jumpForce;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _dashSprite.render(canvas, size: size);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    print("test  print");
    if (other is HiddenCoin) {
      bloc.increaseScore();
      print("Lets increase the coin");

      other.removeFromParent();
    } else if (other is Pipe) {
      bloc.gameOver();
    }
  }
}
