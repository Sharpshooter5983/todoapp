import 'dart:async';

class PomodoroService {
  static final PomodoroService _instance = PomodoroService._internal();
  factory PomodoroService() => _instance;
  PomodoroService._internal();

  int _seconds = 25 * 60;
  bool _isActive = false;
  bool _isBreak = false;
  Timer? _timer;

  Stream<int> get timerStream => _timerController.stream;
  final _timerController = StreamController<int>.broadcast();

  bool get isActive => _isActive;
  bool get isBreak => _isBreak;

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    
    _isActive = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        _seconds--;
      } else {
        _isBreak = !_isBreak;
        _seconds = _isBreak ? 5 * 60 : 25 * 60;
      }
      _timerController.add(_seconds);
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _isActive = false;
  }

  void resetTimer() {
    stopTimer();
    _seconds = 25 * 60;
    _isBreak = false;
    _timerController.add(_seconds);
  }

  void dispose() {
    _timer?.cancel();
    _timerController.close();
  }
}