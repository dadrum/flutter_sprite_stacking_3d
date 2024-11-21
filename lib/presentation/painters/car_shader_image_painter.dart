import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CarShaderImagePainter extends CustomPainter {
  CarShaderImagePainter({
    required this.shader,
    required this.rotation,
    required this.image,
    required this.color,
  });

  final ui.FragmentShader shader;
  final double rotation;
  final ui.Image image;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setImageSampler(0, image)
      ..setFloat(0, rotation)
      ..setFloat(1, size.width)
      ..setFloat(2, size.height)
      ..setFloat(3, image.width.toDouble())
      ..setFloat(4, image.height.toDouble())
      ..setFloat(5, 15)
      ..setFloat(6, color.red.toDouble())
      ..setFloat(7, color.green.toDouble())
      ..setFloat(8, color.blue.toDouble());

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(CarShaderImagePainter oldDelegate) =>
      rotation != oldDelegate.rotation;
}
