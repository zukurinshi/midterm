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
  Sprite()
    ..imagePath = "assets/images/dino/dino_6.png"
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
    Dino(this.settingsController);
  Sprite currentSprite = dino[1];
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
      currentSprite = dino[(elapsedTime!.inMilliseconds / 100).floor() % 2 + 2];
    } catch (_) {
      currentSprite = dino[1];
    }
    try{
      elapsedTimeSeconds = (elapsedTime! - lastUpdate).inMilliseconds / 1000;
    }
    catch(_){
      elapsedTimeSeconds = 0;
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
