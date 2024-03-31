import 'dart:math';
import 'package:basic/audio/audio_controller.dart';
import 'package:basic/level_selection/highscore.dart';
import 'package:basic/level_selection/ptera.dart';
import 'package:basic/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'cactus.dart';
import 'cloud.dart';
import 'dino.dart';
import 'game_object.dart';
import 'ground.dart';
import 'constants.dart';
import 'package:google_fonts/google_fonts.dart';
  double runDistance = 0;
late Box<HighScore> highScoreBox; // Declare the box with the correct type

void main()async {

    runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SettingsController settingsController = SettingsController();
    return MaterialApp(
      title: 'Aswang Chronicles',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(settingsController: settingsController),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final SettingsController settingsController;
  const MyHomePage({Key? key, required this.settingsController})
      : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late Dino dino;
  double runVelocity = initialVelocity;

  late final AudioController audioController = AudioController();

  int highScore = 0;
  TextEditingController gravityController =
      TextEditingController(text: gravity.toString());
  TextEditingController accelerationController =
      TextEditingController(text: acceleration.toString());
  TextEditingController jumpVelocityController =
      TextEditingController(text: jumpVelocity.toString());
  TextEditingController runVelocityController =
      TextEditingController(text: initialVelocity.toString());
  TextEditingController dayNightOffestController =
      TextEditingController(text: dayNightOffest.toString());

  late AnimationController worldController;
  Duration lastUpdateCall = const Duration();

  List<Cactus> cacti = [Cactus(worldLocation: const Offset(200, 10))];

  List<Ground> ground = [
    Ground(worldLocation: const Offset(0, 0)),
    Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0))
  ];

  List<Cloud> clouds = [
    Cloud(worldLocation: const Offset(100, 20)),
    Cloud(worldLocation: const Offset(200, 10)),
    Cloud(worldLocation: const Offset(350, -10)),
  ];

  List<Ptera> pteraFrames = [
    Ptera(worldLocation: const Offset(200, 0)),
  ];

  @override
  void initState() {
    dino = Dino(widget.settingsController);
    super.initState();

    worldController =
        AnimationController(vsync: this, duration: const Duration(days: 99));
    worldController.addListener(_update);
    _die();
  }

void _die() {
  setState(() {
    worldController.stop();
    dino.die();
    HighScore currentHighScore = highScoreBox.get('highScoreKey') ?? HighScore(0);
    HighScore updatedHighScore = HighScore(max(currentHighScore.score, highScore));
    highScoreBox.put('highScoreKey', updatedHighScore);
  });
}

  void _newGame() {
  setState(() {
   HighScore currentHighScore = highScoreBox.get('highScoreKey') ?? HighScore(0);
    highScore = max(currentHighScore.score, runDistance.toInt());
    runDistance = 0;
    runVelocity = 30; // Adjust this value as needed
    dino.state = DinoState.running;
    dino.dispY = 0;
    worldController.reset();
    cacti = [
      Cactus(worldLocation: const Offset(200, 0)),
      Cactus(worldLocation: const Offset(300, 0)),
      Cactus(worldLocation: const Offset(450, 0)),
    ];

    ground = [
      Ground(worldLocation: const Offset(0, 0)),
      Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 110))
    ];

    clouds = [
      Cloud(worldLocation: const Offset(100, 20)),
      Cloud(worldLocation: const Offset(200, 10)),
      Cloud(worldLocation: const Offset(350, -15)),
      Cloud(worldLocation: const Offset(500, 10)),
      Cloud(worldLocation: const Offset(550, -10)),
    ];

    pteraFrames = [
      Ptera(worldLocation: const Offset(200, 0)),
      Ptera(worldLocation: const Offset(300, 0)),
      Ptera(worldLocation: const Offset(450, 0)),
    ];

    worldController.forward();
  });
}

  void _update() {
      if (runDistance.toInt() > highScore) {
    setState(() {
      highScore = runDistance.toInt();
    });
  }
    try {
      double elapsedTimeSeconds;
      dino.update(lastUpdateCall, worldController.lastElapsedDuration);
      try {
        elapsedTimeSeconds =
            (worldController.lastElapsedDuration! - lastUpdateCall)
                    .inMilliseconds /
                1000;
      } catch (_) {
        elapsedTimeSeconds = 0;
      }

      runDistance += runVelocity * elapsedTimeSeconds;
      if (runDistance < 0) runDistance = 0;
      runVelocity += acceleration * elapsedTimeSeconds;

      Size screenSize = MediaQuery.of(context).size;

      Rect dinoRect = dino.getRect(screenSize, runDistance);
      for (Cactus cactus in cacti) {
        Rect obstacleRect = cactus.getRect(screenSize, runDistance);
        if (dinoRect.overlaps(obstacleRect.deflate(30))) {
          _die();
        }

        if (obstacleRect.right < 0) {
          setState(() {
            cacti.remove(cactus);

            cacti.add(
              Cactus(
                worldLocation: Offset(
                  runDistance +
                      MediaQuery.of(context).size.width / worlToPixelRatio +
                      Random().nextInt(
                          500) + // Add random distance between obstacles
                      100, // Minimum distance between obstacles
                  0,
                ),
              ),
            );
          });
        }
      }

      for (Ground groundlet in ground) {
        if (groundlet.getRect(screenSize, runDistance).right < 0) {
          setState(() {
            ground.remove(groundlet);
            ground.add(
              Ground(
                worldLocation: Offset(
                  ground.last.worldLocation.dx + groundSprite.imageWidth / 10,
                  0,
                ),
              ),
            );
          });
        }
      }

      for (Cloud cloud in clouds) {
        if (cloud.getRect(screenSize, runDistance).right < 0) {
          setState(() {
            clouds.remove(cloud);
            clouds.add(
              Cloud(
                worldLocation: Offset(
                  clouds.last.worldLocation.dx +
                      Random().nextInt(200) +
                      MediaQuery.of(context).size.width / worlToPixelRatio,
                  Random().nextInt(50) - 25.0,
                ),
              ),
            );
          });
        }
      }

      lastUpdateCall = worldController.lastElapsedDuration!;

      // Check if the score reaches 1000 and update Dino sprite
      if (runDistance >= 500) {
        setState(() {
          dino.updateSpriteForScore1000();
        });
      }
    } catch (e) {
      //
    }
  }

  @override
  void dispose() {
    gravityController.dispose();
    accelerationController.dispose();
    jumpVelocityController.dispose();
    runVelocityController.dispose();
    dayNightOffestController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> children = [];

    for (GameObject object in [...clouds, ...ground, ...cacti, dino]) {
      children.add(
        AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
            Rect objectRect = object.getRect(screenSize, runDistance);
            return Positioned(
              left: objectRect.left,
              top: objectRect.top,
              width: objectRect.width,
              height: objectRect.height,
              child: object.render(),
            );
          },
        ),
      );
    }
    return Scaffold(
      body: Container(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
        color: runDistance >= 1000 || (runDistance ~/ dayNightOffest) % 2 != 0
              ?Color.fromARGB(255, 139, 0, 0)
              : Colors.black,

          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (dino.state == DinoState.running) {
                dino.jump();
              }
              if (dino.state == DinoState.dead) {
                _newGame();
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ...children,
                AnimatedBuilder(
                  animation: worldController,
                  builder: (context, _) {
                    return Positioned(
                      left: screenSize.width / 2 - 30,
                      top: 100,
                      child: Text(
                        'Score: ' + runDistance.toInt().toString(),
                        style: GoogleFonts.pixelifySans(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: (runDistance ~/ dayNightOffest) % 2 == 0
                              ? Colors.white
                              : Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: worldController,
                  builder: (context, _) {
                    return Positioned(
                      left: screenSize.width / 2 - 50,
                      top: 120,
                      child: Text(
                        'High Score: ' + highScore.toString(),
                        style: GoogleFonts.pixelifySans(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: (runDistance ~/ dayNightOffest) % 2 == 0
                              ? Colors.white
                              : Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  right: 20,
                  top: 20,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(
                                context); // Go back to the previous screen
        
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //       builder: (_) => EndlessRunnerGame()),
                            // );
                          },
                          icon: Icon(Icons.close)),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          _die();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Change Physics"),
                                actions: [
                                  Positioned(
                                    right: 20,
                                    top: 20,
                                    child: IconButton(
                                      onPressed: () {
                                        widget.settingsController
                                            .toggleSoundsOn();
                                      },
                                      icon: ValueListenableBuilder<bool>(
                                        valueListenable:
                                            widget.settingsController.soundsOn,
                                        builder: (context, soundsOn, child) {
                                          return Icon(
                                            soundsOn
                                                ? Icons.volume_up
                                                : Icons.volume_off,
                                            color: const Color.fromARGB(
                                                255, 17, 17, 17),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 25,
                                      width: 280,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Gravity:"),
                                          SizedBox(
                                            child: TextField(
                                              controller: gravityController,
                                              key: UniqueKey(),
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                            height: 25,
                                            width: 75,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 25,
                                      width: 280,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Acceleration:"),
                                          SizedBox(
                                            child: TextField(
                                              controller: accelerationController,
                                              key: UniqueKey(),
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                            height: 25,
                                            width: 75,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 25,
                                      width: 280,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Initial Velocity:"),
                                          SizedBox(
                                            child: TextField(
                                              controller: runVelocityController,
                                              key: UniqueKey(),
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                            height: 25,
                                            width: 75,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 25,
                                      width: 280,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Jump Velocity:"),
                                          SizedBox(
                                            child: TextField(
                                              controller: jumpVelocityController,
                                              key: UniqueKey(),
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                            height: 25,
                                            width: 75,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 25,
                                      width: 280,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Day-Night Offset:"),
                                          SizedBox(
                                            child: TextField(
                                              controller:
                                                  dayNightOffestController,
                                              key: UniqueKey(),
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                            height: 25,
                                            width: 75,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      gravity = int.parse(gravityController.text);
                                      acceleration = double.parse(
                                          accelerationController.text);
                                      initialVelocity = double.parse(
                                          runVelocityController.text);
                                      jumpVelocity = double.parse(
                                          jumpVelocityController.text);
                                      dayNightOffest = int.parse(
                                          dayNightOffestController.text);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Done",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: TextButton(
                    onPressed: () {
                      _die();
                    },
                    child: const Text(
                      "Patayin ang Aswang",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
