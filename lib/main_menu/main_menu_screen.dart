import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../settings/settings.dart';

import '../style/palette.dart';


class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/front1.jpg'), // Replace 'assets/background.jpg' with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Transform.rotate(
                angle: -0.1,
                child: const Text(
                  '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 55,
                    height: 1,
                    color: Colors
                        .white, // Adjust the text color to match your background
                  ),
                ),
              ),
            ),
            SizedBox(height: 150),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blueGrey)),
                onPressed: () {
                  if (settingsController.audioOn.value) {
                    audioController.playSfx(SfxType.buttonTap);
                  }
                  GoRouter.of(context).go('/play');
                },
                child: const Text(
                  'Maglaro',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 10),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blueGrey)),
                onPressed: () => GoRouter.of(context).push('/settings'),
                child: const Text(
                  'Kaukulang Paggayos',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 10),
            
            SizedBox(height: 10),
            const Text(
              'Developed by: MAD GROUP',
              style: TextStyle(
                  color: Colors
                      .white), // Adjust the text color to match your background
            ),
          ],
        ),
      ),
    );
  }
}
