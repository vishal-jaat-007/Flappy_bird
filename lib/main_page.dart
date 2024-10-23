import 'package:flame/game.dart';
import 'package:flappy_bird/flappy_dash_game.dart';
import 'package:flappy_bird/game/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late FlappyDashGame _flappyDashGame;
  late GameCubit gameCubit;
  @override
  void initState() {
    final gameCubit = BlocProvider.of<GameCubit>(context);
    _flappyDashGame = FlappyDashGame(gameCubit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: _flappyDashGame),
    );
  }
}
