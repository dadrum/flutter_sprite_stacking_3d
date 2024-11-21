import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../domain/environment/builders.dep_gen.dart';
import '../../domain/fps_meter/fps_meter.dart';
import '../../domain/models/car.dart';
import '../../domain/models/shader_type.dart';
import '../../domain/models/sprite_type.dart';
import '../../media/shaders_service.dart';
import '../../media/sprites_service.dart';
import 'background.dart';
import 'car.dart';
import 'fps_readings.dart';

class GameStage extends StatefulWidget {
  const GameStage({Key? key}) : super(key: key);

  @override
  State<GameStage> createState() => _GameStageState();
}

class _GameStageState extends State<GameStage>
    with SingleTickerProviderStateMixin {
  // car display size
  static const double _carSize = 116;

  // preloaded car sprites sheet
  ui.Image? carSpritesSheet;

  // preloaded shader
  ui.FragmentShader? carShaderPainter;

  // screen size
  late Size _size;

  // array of cars
  final List<Car3D> _cars = [];

  // timer to add new car
  late final Timer timer;

  // animation ticker parameters
  double _lastTime = 0;
  late Ticker _ticker;

  // last added car id
  int _lastId = 0;

  // Performance Meter
  late FpsMeter _fpsMeter;

  // ---------------------------------------------------------------------------
  @override
  void initState() {
    _fpsMeter = FpsMeter();

    // creating a ticker for smooth animation
    _ticker = createTicker(_onTick);
    _ticker.start();

    // timer to add new car
    timer = Timer.periodic(const Duration(seconds: 5), (t) => addCar());

    super.initState();
  }

  // ---------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    // we get all the preloaded resources for animation
    carSpritesSheet ??=
        context.depGen().g<SpritesService>().getSprite(SpriteType.blueCar2);
    carShaderPainter ??=
        context.depGen().g<ShadersService>().getShader(ShaderType.stack);

    _size = MediaQuery.sizeOf(context);

    // adding the first car so as not to wait for the timer
    addCar();

    super.didChangeDependencies();
  }

  // ---------------------------------------------------------------------------
  /// for each tick of the timer, we move all the cars according
  /// to their speed and check their collisions
  void _onTick(Duration duration) {
    if (!mounted) {
      return;
    }

    // we determine how much time has passed
    final newTime = duration.inMilliseconds * 0.001;
    final tickerDelta = newTime - _lastTime;
    _lastTime = newTime;
    _fpsMeter.onTick(duration);

    // moving all cars
    _cars.forEach((car) => car.move(
          tickerDelta: tickerDelta,
          newTime: newTime,
          constraints: _size,
        ));

    // check cars collisions
    checkCarsCollisions();

    // we delete all cars with a speed of 0
    _cars.removeWhere((car) => car.speed < 1);

    setState(() {});
  }

  // ---------------------------------------------------------------------------
  /// check cars collisions
  void checkCarsCollisions() {
    // check cars collisions
    final int len = _cars.length;
    for (int i1 = 0; i1 < (len - 1); i1++) {
      for (int i2 = i1 + 1; i2 < len; i2++) {
        final car1 = _cars[i1];
        final car2 = _cars[i2];
        // if the cars collided
        if (car1.checkCollision(other: car2)) {
          // We stop the oldest car. We cannot immediately remove it from
          // the list inside the loop
          // we slow down the newer car (there was an accident after all)
          car2.speed *= 0.75;
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  /// adding a random car with a random direction, speed and color
  void addCar() {
    if (_cars.length >= 10) {
      return;
    }
    setState(() {
      _cars.add(Car3D(
        id: ++_lastId,
        carSize: _carSize - 40 + 80 * Random().nextDouble(),
        x: _size.width * Random().nextDouble(),
        y: _size.height * Random().nextDouble(),
        color: Color.fromARGB(
          255,
          20 + Random().nextInt(150),
          20 + Random().nextInt(150),
          20 + Random().nextInt(150),
        ),
        rotation: 360 * Random().nextDouble(),
        speed: 10 + 20 * Random().nextDouble(),
      ));
    });
  }

  // ---------------------------------------------------------------------------
  @override
  void dispose() {
    _ticker
      ..stop()
      ..dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.blueGrey,
      child: Stack(children: [
        /// the background of the entire screen
        const Positioned.fill(child: GrassBackground()),

        /// moving cars
        ..._cars.map((car) => Positioned(
              left: car.x - car.carSize * 0.5,
              top: car.y - car.carSize * 0.5,
              child: CarWidget(
                car: car,
                carShaderPainter: carShaderPainter!,
                carSpritesSheet: carSpritesSheet!,
              ),
            )),

        /// FPS meter
        Positioned(left: 40, top: 40, child: FpsReadings(fpsMeter: _fpsMeter))
      ]),
    );
  }
}
