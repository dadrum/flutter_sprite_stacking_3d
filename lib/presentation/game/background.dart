import 'package:flutter/material.dart';

import '../../domain/environment/builders.dep_gen.dart';
import '../../domain/models/shader_type.dart';
import '../../domain/models/sprite_type.dart';
import '../../media/shaders_service.dart';
import '../../media/sprites_service.dart';
import '../painters/grass_shader_image_painter.dart';

/// the background of the entire screen
class GrassBackground extends StatelessWidget {
  const GrassBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GrassShaderImagePainter(
        shader:
        context.depGen().g<ShadersService>().getShader(ShaderType.grass),
        image: context.depGen().g<SpritesService>().getSprite(SpriteType.grass),
      ),
    );
  }
}
