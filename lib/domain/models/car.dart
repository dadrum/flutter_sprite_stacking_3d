import 'dart:math';
import 'dart:ui';

class Car3D {
  Car3D({
    required this.id,
    required this.x,
    required this.y,
    required this.color,
    required this.rotation,
    required this.speed,
    required this.carSize,
  });

  int id;
  double x;
  double y;
  Color color;
  double rotation;
  double speed;
  double carSize;
}

// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
extension CarCheckCollision on Car3D {
  bool checkCollision({
    required Car3D other,
  }) {
    final distanceSquared =
        (x - other.x) * (x - other.x) + (y - other.y) * (y - other.y);
    final criticalSquaredDistance =
        (carSize + other.carSize) * (carSize + other.carSize) * 0.10;
    return distanceSquared <= criticalSquaredDistance;
  }
}

// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
extension CarMovement on Car3D {
  // calculating the movement
  void move({
    required double tickerDelta,
    required double newTime,
    required Size constraints,
  }) {
    this
      ..x = x + 4 * tickerDelta * speed * sin(rotation)
      ..y = y - 4 * tickerDelta * speed * cos(rotation)
      ..rotation += 0.001 * (sin(newTime) * speed + cos(newTime) * speed);

    // checking the exit from the screen
    if (y > constraints.height) {
      y = 0;
    } else if (y < 0) {
      y = constraints.height;
    }
    if (x > constraints.width) {
      x = 0;
    } else if (x < 0) {
      x = constraints.width;
    }
  }
}
