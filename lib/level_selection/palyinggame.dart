import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(MainMenuScreen());
}

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aswang Chronicles',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Main Menu'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DinoGame()),
              );
            },
            child: Text('Start Game'),
          ),
        ),
      ),
    );
  }
}

class DinoGame extends StatefulWidget {
  @override
  _DinoGameState createState() => _DinoGameState();
}

class _DinoGameState extends State<DinoGame> {
  late Timer _timer;
  double _dinoY = 0.0;
  double _dinoYVelocity = 0.0;
  double _obstacleX = 500.0;
  double _obstacleSpeed = 5.0;
  bool _gameOver = false;
  double _previousObstacleX = 0.0; // Track the previous obstacle's position

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _timer = Timer.periodic(Duration(milliseconds: 400), (timer) {
      setState(() {
        // Reset the dino's vertical velocity when the game starts again
        if (_dinoY == 0) {
          _dinoYVelocity = 0;
        }
        
        // Logic for obstacle spawning and game over condition
        
      });
    });
  }

  void _jump() {
    setState(() {
      _dinoYVelocity = 100;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_gameOver) {
          _jump();
        }
      },
      child: Container(
        color: Colors.grey[200],
        child: Stack(
          children: [
            Positioned(
              bottom: _dinoY,
              left: 50,
              child: Image.asset(
                'assets/images/dino.png', // Adjust the path as per your asset location
                width: 50,
                height: 50,
              ),
            ),
            Positioned(
              top: 0,
              left: _obstacleX,
              child: Container(
                width: 30,
                height: 200,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
