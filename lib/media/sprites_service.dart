import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../domain/models/sprite_type.dart';

class SpritesService {
  // preloaded images
  final Map<SpriteType, ui.Image> _cachedSprites = {};

  // ---------------------------------------------------------------------------
  String getSpritePath(SpriteType spriteType) => switch (spriteType) {
        SpriteType.blueCar2 => 'assets/images/blue_car2.png',
        SpriteType.grass => 'assets/images/grass.jpg',
      };


  // ---------------------------------------------------------------------------
  /// preloading all sprites
  Future<void> cacheAllSprites() async {
    for (final spriteType in SpriteType.values) {
      await cacheSprite(spriteType);
    }
  }

  // ---------------------------------------------------------------------------
  /// preloading the sprite
  Future<void> cacheSprite(
    SpriteType spriteType,
  ) async {
    // изображение уже загружено
    if (_cachedSprites.containsKey(spriteType)) {
      return;
    }

    final String assetPath = getSpritePath(spriteType);

    final imageData = await rootBundle.load(assetPath);
    final decodedImage =
        await decodeImageFromList(imageData.buffer.asUint8List());

    _cachedSprites[spriteType] = decodedImage;
  }

  // ---------------------------------------------------------------------------
  /// getting a cached image
  ui.Image getSprite(SpriteType spriteType) {
    return _cachedSprites[spriteType]!;
  }
}
