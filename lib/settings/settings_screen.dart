import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../player_progress/player_progress.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'custom_name_dialog.dart';
import 'settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key});

  static const _gap = SizedBox(height: 60);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final palette = context.watch<Palette>();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/settingbg.jpg'), // Adjust the image path
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ResponsiveScreen(
          squarishMainArea: ListView(
            children: [
              _gap,
              const Text(
                'Settings',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 55,
                  height: 1,
                  color: Colors.white, // Set text color to white
                ),
              ),
              _gap,
              const _NameChangeLine('Name'),
          
              ValueListenableBuilder<bool>(
                valueListenable: settings.audioOn,
                builder: (context, audioOn, child) => _SettingsLine(
                  'Music',
                  Icon(audioOn ? Icons.music_note : Icons.music_off, color: Colors.white), // Set icon color to white
                  onSelected: () => settings.toggleAudioOn(),
                ),
              ),
              _SettingsLine(
                'Reset progress',
                const Icon(Icons.delete, color: Colors.white), // Set icon color to white
                onSelected: () {
                  context.read<PlayerProgress>().reset();

                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Player progress has been reset.')),
                  );
                },
              ),
              _gap,
            ],
          ),
          rectangularMenuArea: MyButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            child: const Text('Back'),
          ),
        ),
      ),
    );
  }
}

class _NameChangeLine extends StatelessWidget {
  const _NameChangeLine(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: () => showCustomNameDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 30,
                color: Colors.white, // Set text color to white
              ),
            ),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: settings.playerName,
              builder: (context, name, child) => Text(
                '‘$name’',
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 30,
                  color: Colors.white, // Set text color to white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  const _SettingsLine(this.title, this.icon, {this.onSelected});

  final String title;
  final Widget icon;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 30,
                  color: Colors.white, // Set text color to white
                ),
              ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
