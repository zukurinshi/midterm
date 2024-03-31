import 'package:basic/level_selection/main.dart';
import 'package:basic/level_selection/palyinggame.dart';
import 'package:basic/style/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../settings/settings.dart';
import 'package:provider/provider.dart';

class EndlessRunnerGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final audioController = context.watch<AudioController>();
    final settingsController = context.watch<SettingsController>();
    return OrientationBuilder(
      builder: (context, orientation) {
   
        bool isLandscape = orientation == Orientation.landscape;

        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Container(
                width: isLandscape ? MediaQuery.of(context).size.width : null,
                height: isLandscape ? MediaQuery.of(context).size.height : null,
                child: Image.asset(
                  'assets/images/bg.jpg', 
                  fit: BoxFit.cover,
                ),
              ),
        
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Start button
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blueGrey)),
                      onPressed: () {
audioController.stopMusic();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => MyHomePage(settingsController: settingsController)));
                      },
                      child: Text(
                        'Start',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blueGrey)),
                      onPressed: () {
                        // Set preferred orientation to portrait mode
                            Navigator.pop(context); // This will pop the current route and go back

                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ]);
                      },
                      child: Text(
                        'Back',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                 
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
