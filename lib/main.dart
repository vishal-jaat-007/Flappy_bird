import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game/game_cubit.dart';
import 'main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GameCubit(),
      child: const MaterialApp(
        title: 'Flappy Bird',
        home: MainPage(),
      ),
    );
  }
}
