import '../../media/shaders_service.dart';
import '../../media/sprites_service.dart';
import 'builders.dep_gen.dart';

class Environment extends DepGenEnvironment {
  Future<Environment> prepare() async {
    /// a service that downloads and caches sprites
    final spritesService = SpritesService();
    registry<SpritesService>(spritesService);

    /// a service that downloads and prepares shader programs
    final shadersService = ShadersService();
    registry<ShadersService>(shadersService);

    return this;
  }
}
