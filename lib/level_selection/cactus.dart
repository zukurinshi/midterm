import 'dart:math';

import 'package:flutter/widgets.dart';

import 'constants.dart';
import 'game_object.dart';
import 'sprite.dart';

List<Sprite> cacti = [
  Sprite()
    ..imagePath = "assets/images/whip/whip.png"
    ..imageWidth = 70
    ..imageHeight = 110,
  Sprite()
    ..imagePath = "assets/images/whip/whip.png"
    ..imageWidth = 70
    ..imageHeight = 110,
  Sprite()
    ..imagePath = "assets/images/whip/whip.png"
    ..imageWidth = 70
    ..imageHeight = 110,
  Sprite()
    ..imagePath = "assets/images/bawang/bawang.png"
    ..imageWidth = 80
    ..imageHeight = 60,
  Sprite()
    ..imagePath = "assets/images/bawang/bawang.png"
    ..imageWidth = 80
    ..imageHeight = 60,
];

class Cactus extends GameObject {
  final Sprite sprite;
  final Offset worldLocation;

  Cactus({required this.worldLocation})
      : sprite = cacti[Random().nextInt(cacti.length)];

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * worlToPixelRatio,
      screenSize.height / 1.75 - sprite.imageHeight,
      sprite.imageWidth.toDouble(),
      sprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(sprite.imagePath);
  }
}
