import 'dart:ui' as ui;

import '../domain/models/shader_type.dart';

class ShadersService {
  /// preloaded shaders
  final Map<ShaderType, ui.FragmentShader> _preloadedShaders = {};

  // ---------------------------------------------------------------------------
  String getShaderPath(ShaderType shaderType) => switch (shaderType) {
        ShaderType.stack =>
          'assets/shaders/stack.frag',
        ShaderType.grass =>
          'assets/shaders/grass_painter.frag',
      };

  // ---------------------------------------------------------------------------
  /// preloading all shaders
  Future<void> cacheAllShaders() async {
    for (final shaderType in ShaderType.values) {
      await cacheShader(shaderType);
    }
  }

  // ---------------------------------------------------------------------------
  /// preloading the shader
  Future<void> cacheShader(
    ShaderType shaderType,
  ) async {
    try {
      final shaderPath = getShaderPath(shaderType);
      final program = await ui.FragmentProgram.fromAsset(shaderPath);
      _preloadedShaders[shaderType] = program.fragmentShader();
    } on Object catch (e, st) {
      Future.delayed(Duration.zero, () => Error.throwWithStackTrace(e, st));
    }
  }

  // ---------------------------------------------------------------------------
  /// getting a previously preloaded shader program
  ui.FragmentShader getShader(ShaderType type) => _preloadedShaders[type]!;
}
