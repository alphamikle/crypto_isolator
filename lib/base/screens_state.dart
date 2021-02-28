import 'package:crypto_isolator/utils/benchmark.dart';
import 'package:flutter/cupertino.dart';

class ScreenState with ChangeNotifier {
  ScreenState() {
    _index = 2;
    _pageController = PageController(initialPage: _index);
  }

  PageController _pageController;
  int _index;
  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];

  ScrollController get _scrollController => _scrollControllers[_index];
  PageController get pageController => _pageController;
  int get index => _index;

  ScrollController getControllerByIndex(int index) {
    return _scrollControllers[index];
  }

  void changeIndex(int index) {
    _index = index;
    notifyListeners();
    pageController.animateToPage(_index, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  Future<void> resetScroll() async {
    await _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  Future<void> scrollDownAndUp() async {
    await resetScroll();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    startFps(120);
    const int maxSeconds = 40;
    int currentTime = 3;
    while (currentTime < maxSeconds) {
      await _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(seconds: currentTime), curve: Curves.linear);
      currentTime += currentTime;
      await _scrollController.animateTo(0, duration: Duration(seconds: currentTime), curve: Curves.linear);
      currentTime += currentTime;
    }
    await stopFps();
  }
}
