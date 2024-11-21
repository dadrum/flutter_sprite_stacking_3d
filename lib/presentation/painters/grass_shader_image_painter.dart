import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class GrassShaderImagePainter extends CustomPainter {
  GrassShaderImagePainter({
    required this.shader,
    required this.image,
  });

  final FragmentShader shader;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setImageSampler(0, image)
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, image.width.toDouble())
      ..setFloat(3, image.height.toDouble());

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
