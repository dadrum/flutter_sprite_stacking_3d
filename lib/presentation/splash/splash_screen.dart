import 'package:flutter/material.dart';

import '../../domain/environment/builders.dep_gen.dart';
import '../../media/shaders_service.dart';
import '../../media/sprites_service.dart';
import '../game/game_stage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool initialized = false;

  Future<void> initialize() async {
    if (mounted) {
      final depProvider = context.depGen();
      await depProvider.g<SpritesService>().cacheAllSprites();
      await depProvider.g<ShadersService>().cacheAllShaders();
    }
  }

  // ---------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    if (!initialized) {
      // we have to preload all the resources from the asset
      initialized = true;
      initialize().then((_) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const GameStage(),
            ),
          );
        }
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.black,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
