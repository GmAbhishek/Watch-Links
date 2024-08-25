
import 'package:flutter/material.dart';
import 'package:watch_os/screens/ambient_screen.dart';
import 'package:watch_os/screens/start_screen.dart';
import 'package:watch_os/wear.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Wear App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WatchScreen(),
        debugShowCheckedModeBanner: false,
      );
}

class WatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => WatchShape(
        builder: (context, shape) => InheritedShape(
              shape: shape,
              child: AmbientMode(
                builder: (context, mode) =>
                    mode == Mode.active ? StartScreen() : AmbientWatchFace(),
              ),
            ),
      );
}