import 'dart:async';

import 'package:flame/components.dart';
import 'package:flappy_bird/componet/hidden_coin.dart';
import 'package:flappy_bird/componet/pipe.dart';

class PipePair extends PositionComponent {
  PipePair({required super.position, this.gap = 200.0, this.speed = 200.0});
  final double gap;
  final double speed;
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    addAll([
      Pipe(isFlipped: false, position: Vector2(0, gap / 2)),
      Pipe(isFlipped: true, position: Vector2(0, -gap / 2)),
      HiddenCoin(position: Vector2(30, 0)),
    ]);
  }

  @override
  void update(double dt) {
    position.x -= speed * dt;
    super.update(dt);
  }
}
