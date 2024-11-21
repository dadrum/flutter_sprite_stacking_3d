import 'package:flutter/material.dart';

import '../../domain/fps_meter/fps_meter.dart';

class FpsReadings extends StatelessWidget {
  const FpsReadings({Key? key, required this.fpsMeter}): super(key: key);

  final FpsMeter fpsMeter;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white54,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FPS: ${fpsMeter.fps}'),
          Text('Avr Frame Time: ${fpsMeter.avrTime} ms'),
        ],
      ),
    );
  }
}
