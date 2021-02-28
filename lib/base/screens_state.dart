import 'dart:math';

import 'package:crypto_isolator/utils/benchmark.dart';
import 'package:flutter/cupertino.dart';

class ScreenState with ChangeNotifier {
  ScreenState() {
    _index = 0;
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
    final List<List<double>> columnsOfFrames = [];
    const int maxIterations = 5;
    const double scrollStep = 500;
    const int scrollTimeMs = 300;
    for (int iteration = 0; iteration < maxIterations; iteration++) {
      startFps(120);
      double nextPos = scrollStep;
      while (nextPos < _scrollController.position.maxScrollExtent) {
        await _scrollController.animateTo(nextPos, duration: const Duration(milliseconds: scrollTimeMs), curve: Curves.easeIn);
        nextPos = min(nextPos + scrollStep, _scrollController.position.maxScrollExtent);
      }
      nextPos = nextPos - scrollStep;
      while (nextPos > 0) {
        await _scrollController.animateTo(nextPos, duration: const Duration(milliseconds: scrollTimeMs), curve: Curves.easeIn);
        nextPos = max(0, nextPos - scrollStep);
      }
      final List<double> columnOfFrames = await stopFps(copy: false);
      columnsOfFrames.add(columnOfFrames);
    }
    await computeTableOfFrames(columnsOfFrames);
  }
}
