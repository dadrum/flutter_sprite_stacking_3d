import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../domain/models/car.dart';
import '../painters/car_shader_image_painter.dart';

class CarWidget extends StatelessWidget {
  const CarWidget({
    Key? key,
    required this.car,
    required this.carShaderPainter,
    required this.carSpritesSheet,
  }) : super(key: key);

  final Car3D car;

  final ui.FragmentShader carShaderPainter;

  final ui.Image carSpritesSheet;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: car.carSize,
        height: car.carSize,
        child: CustomPaint(
          painter: CarShaderImagePainter(
            shader: carShaderPainter,
            rotation: car.rotation,
            image: carSpritesSheet,
            color: car.color,
          ),
        ));
  }
}
