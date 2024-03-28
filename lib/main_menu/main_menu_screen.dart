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
                'assets/images/frontbg.jpg'), // Replace 'assets/background.jpg' with your image path
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
            SizedBox(height: 100),
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
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.audioOn,
                builder: (context, audioOn, child) {
                  return IconButton(
                    onPressed: () {
                      settingsController.toggleSoundsOn();
                      if (settingsController.audioOn.value) {
                        audioController.playSfx(SfxType.buttonTap);
                      }
                    },
                    icon: ValueListenableBuilder<bool>(
                      valueListenable: settingsController.soundsOn,
                      builder: (context, soundsOn, child) {
                        return Icon(
                          soundsOn ? Icons.volume_up : Icons.volume_off,
                          color: Colors.white,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            const Text(
              'Version by: Flor Ristagno',
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
