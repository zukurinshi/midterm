import 'package:basic/level_selection/main.dart';
import 'package:basic/level_selection/palyinggame.dart';
import 'package:basic/style/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the services library
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';

class EndlessRunnerGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return OrientationBuilder(
      builder: (context, orientation) {
        // Check if the device is in landscape mode
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
                  'assets/images/bg.jpg', // Replace 'background_image.jpg' with your actual image file
                  fit: BoxFit.cover,
                ),
              ),
              // Centered column for the start button
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Start button
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blueGrey)
                      ),
                      onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder:(_)=>MyHomePage ()));
                      },
                      child: Text('Start',style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blueGrey)
                      ),
                      
                      onPressed: () {
 // Set preferred orientation to portrait mode
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ]);                      },
                      child: Text('Back',style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),),
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
