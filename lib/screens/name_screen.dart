import 'package:flutter/material.dart';
import 'package:watch_os/screens/ambient_screen.dart';
import 'package:watch_os/screens/relax_menu.dart';
import 'package:watch_os/wear.dart';

class NameScreen extends StatelessWidget {
  final screenHeight;
  final screenWidth;
  NameScreen(this.screenHeight, this.screenWidth);

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      builder: (context, mode) => mode == Mode.active
          ? NameScreenUI(screenHeight, screenWidth)
          : AmbientWatchFace(),
    );
  }
}

class NameScreenUI extends StatelessWidget {
  final screenHeight;
  final screenWidth;
  NameScreenUI(this.screenHeight, this.screenWidth);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: <Widget>[
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/outline_arrow.png',
                      scale: 1.8,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Back',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 15),
              Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'FlutterOS',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue[700],
                ),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400], // Background color
                  foregroundColor: Colors.white, // Text color
                  elevation: 6.0, // Elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return RelaxView(screenHeight, screenWidth);
                    }),
                  );
                },
                child: Text(
                  'NEXT',
                  style: TextStyle(fontSize: 16), // Text style
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
