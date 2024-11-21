/// Performance Meter
class FpsMeter {
  FpsMeter() {
    _lastUpdateFpsTime = DateTime.now();
  }

  int _frameCount = 0;
  int _fps = 0;

  // Average frame construction time in milliseconds
  double _averageFrameTime = 0;
  final List<double> _frameTimes = [];
  late DateTime _lastUpdateFpsTime;
  late DateTime _lastFrameTime;

  // ---------------------------------------------------------------------------
  int get fps => _fps;
  String get avrTime => _averageFrameTime.toStringAsFixed(2);

  // ---------------------------------------------------------------------------
  void onTick(Duration elapsed) {
    final currentFrameTime = DateTime.now();
    final deltaTime = currentFrameTime.difference(_lastUpdateFpsTime);

    // Counting frames per second
    if (deltaTime.inMilliseconds >= 1000) {
      _fps = _frameCount;
      _frameCount = 0;
      // We calculate the average frame construction time
      if (_frameTimes.isNotEmpty) {
        _averageFrameTime =
            _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
        _frameTimes.clear();
      }
      _lastUpdateFpsTime = currentFrameTime;
    } else {
      // Time between frames
      if (_frameCount > 0) {
        final frameTime = currentFrameTime.difference(_lastFrameTime).inMicroseconds / 1000; // В миллисекундах
        _frameTimes.add(frameTime);
      }
      _frameCount++;
    }
    _lastFrameTime = currentFrameTime;

  }
}
