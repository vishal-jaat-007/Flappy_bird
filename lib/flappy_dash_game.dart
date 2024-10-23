import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flappy_bird/componet/dash.dart';
import 'package:flappy_bird/componet/dash_parallax_background.dart';
import 'package:flappy_bird/componet/pipe_pair.dart';
import 'package:flappy_bird/game/game_cubit.dart';
import 'package:flappy_bird/game/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlappyDashGame extends FlameGame<FlappyDashWorld>
    with KeyboardEvents, HasCollisionDetection {
  FlappyDashGame(this.gameCubit)
      : super(
          world: FlappyDashWorld(),
          camera: CameraComponent.withFixedResolution(
            width: 600,
            height: 1000,
          ),
        );

  final GameCubit gameCubit;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //  the GameCubit here
    final flameBlocProvider = FlameBlocProvider<GameCubit, GameState>(
      create: () => gameCubit,
    );
    add(flameBlocProvider);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is KeyDownEvent;
    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isSpace && isKeyDown) {
      world.onSpaceDown();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}

//---FlappyDashWorld---//
class FlappyDashWorld extends World
    with TapCallbacks, HasGameRef<FlappyDashGame> {
  late FlappyDashRootComponent _rootComponent;

  @override
  void onLoad() {
    super.onLoad();
    // No need to add FlameBlocProvider here as it's already added in FlappyDashGame
    add(_rootComponent = FlappyDashRootComponent());
  }

  void onSpaceDown() => _rootComponent.onSpaceDown();

  @override
  void onTapDown(TapDownEvent event) => _rootComponent.onTapDown(event);
}

//-----------FlappyDashRootComponent------------//
class FlappyDashRootComponent extends Component
    with HasGameRef<FlappyDashGame>, FlameBlocReader<GameCubit, GameState> {
  late Dash _dash;
  late PipePair _lastPipe;
  static const _pipeDistance = 400.0;
  int _score = 0;
  late TextComponent _scoreText;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(DashParallaxBackground());
    add(_dash = Dash());

    _generatePipes(fromX: 400);

    // Initialize the score text
    _scoreText = TextComponent(
      text: _score.toString(),
      position: Vector2(10, 10), // Top-left corner
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
    add(_scoreText);
  }

  void _generatePipes({double fromX = 0.0, int count = 20}) {
    for (int i = 0; i < count; i++) {
      const area = 500;
      final y = (Random().nextDouble() * area) - (area / 2);
      add(_lastPipe =
          PipePair(position: Vector2(fromX + (i * _pipeDistance), y)));
    }
  }

  void _removePipes() {
    final pipes = children.whereType<PipePair>();
    final shouldBeRemoved = max(pipes.length - 5, 0);
    pipes.take(shouldBeRemoved).forEach((pipe) {
      pipe.removeFromParent();
    });
  }

  void onSpaceDown() {
    _dash.jump();
  }

  void increaseScore() {
    _score += 1;
    _scoreText.text = _score.toString(); // Update score display
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_dash.x >= _lastPipe.x) {
      increaseScore(); // Increase score when passing a pipe
      _generatePipes(fromX: _pipeDistance);
      _removePipes();
    }
  }

  void onTapDown(TapDownEvent event) {
    _dash.jump();
  }
}
