import 'package:flutter/material.dart';

class ScreenState with ChangeNotifier {
  ScreenState();

  int _counter = 0;

  int get value => _counter;

  bool _isVisible = true;

  bool get isVisible => _isVisible;
  bool _isEnabled = true;

  bool get isEnabled => _isEnabled;

  setIsEnabled(bool val) {
    _isEnabled = val;
    notifyListeners();
  }

  int _timer = 61;

  int get timer => _timer;

  _resetTimer() {
    _timer == 61 ? _timer++ : _timer--;
  }

  int _correctAnswerCount = 0;

  int get correctAnswerCount => _correctAnswerCount;


  VoidCallback _animate;

  setAnimate(VoidCallback value) {
    _animate = value;
  }

  reset() {
    _counter = 0;
    _isVisible = true;
    _isEnabled = true;
    _resetTimer();
    _correctAnswerCount = 0;
    notifyListeners();
  }

  increment(
    VoidCallback toggle, {
    bool showLevelScreen = true,
    AnimationController animationController,
    bool isEnabled,
  }) async {
    _isVisible = false;
    notifyListeners();
    await Future<int>.delayed(Duration(milliseconds: 1500))
        .then((val) => toggle());
    await Future<int>.delayed(Duration(milliseconds: 1000))
        .then((val) => _counter++);
    if (showLevelScreen) {
      _correctAnswerCount++;
    }
    animationController?.reset();
    _isVisible = true;
    _isEnabled = true;
    _resetTimer();
    notifyListeners();
  }

  highlightCorrect() {
    _animate();
    notifyListeners();
  }
}
