import 'package:hive/hive.dart';

part 'highscore.g.dart';

@HiveType(typeId: 0)
class HighScore {
  @HiveField(0)
  int score;

  HighScore(this.score);
}
