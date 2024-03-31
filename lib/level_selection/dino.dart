import 'package:basic/audio/sounds.dart';
import 'package:basic/audio/audio_controller.dart';
import 'package:basic/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'constants.dart';
import 'game_object.dart';
import 'sprite.dart';

List<Sprite> dino = [
  Sprite()
    ..imagePath = "assets/images/dino/walk_1.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "assets/images/dino/walk_2.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "assets/images/dino/walk_3.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "assets/images/dino/walk_4.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "assets/images/dino/death_1.png"
    ..imageWidth = 88
    ..imageHeight = 94,
];

List<Sprite> dinoNight = [
  Sprite()
    ..imagePath = "assets/images/dino/fly1.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "assets/images/dino/fly2.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "assets/images/dino/fly3.png"
    ..imageWidth = 88
    ..imageHeight = 94,
];

enum DinoState {
  jumping,
  running,
  dead,
}

class Dino extends GameObject {
  final AudioController audioController = AudioController();
  final SettingsController settingsController;
  double runDistance = 0;
  double runVelocity = 0; 
  Dino(this.settingsController);
  List<Sprite> daySprites = dino;
  List<Sprite> nightSprites = dinoNight;
  Sprite currentSprite = dino[0];
  double dispY = 0;
  double velY = 0;
  DinoState state = DinoState.running;

  @override
  Widget render() {
    return Image.asset(currentSprite.imagePath);
  }

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      screenSize.width / 10,
      screenSize.height / 1.65 - currentSprite.imageHeight - dispY,
      currentSprite.imageWidth.toDouble(),
      currentSprite.imageHeight.toDouble(),
    );
  }

  @override
  void update(Duration lastUpdate, Duration? elapsedTime) {
    double elapsedTimeSeconds;
    try {
      currentSprite =
          (daySprites[(elapsedTime!.inMilliseconds / 100).floor() % 2 + 2]);
    } catch (_) {
      // Handle exceptions if needed
    }
    try {
      elapsedTimeSeconds = (elapsedTime! - lastUpdate).inMilliseconds / 1000;
    } catch (_) {
      elapsedTimeSeconds = 0;
    }
    runDistance += runVelocity * elapsedTimeSeconds;
    if ((runDistance ~/ dayNightOffest) % 2 != 0) {
      currentSprite =
          nightSprites[(elapsedTime!.inMilliseconds / 100).floor() % 3];
    } else {
      currentSprite =
          daySprites[(elapsedTime!.inMilliseconds / 100).floor() % 4];
    }

    dispY += velY * elapsedTimeSeconds;
    if (dispY <= 0) {
      dispY = 0;
      velY = 0;
      state = DinoState.running;
    } else {
      velY -= gravity * elapsedTimeSeconds;
    }
  }

void updateSpriteForScore1000() {

    // maging baboy pag 1000 pero 500 nilagy ko for debug hahah
    currentSprite = Sprite()
      ..imagePath = "assets/images/dino/pig.gif"
      ..imageWidth = 88
      ..imageHeight = 94;
    
  
}

  void jump() {
    if (state != DinoState.jumping) {
      state = DinoState.jumping;
      velY = jumpVelocity;
      if (settingsController.audioOn.value) {
        audioController.playSfx(SfxType.jump);
      }
    }
  }

  void die() {
    currentSprite = dino[4];
    state = DinoState.dead;
  }
}
