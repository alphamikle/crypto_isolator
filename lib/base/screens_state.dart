import 'package:flutter/cupertino.dart';

class ScreenState with ChangeNotifier {
  int _index = 0;
  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];
  ScrollController get _scrollController => _scrollControllers[_index];

  final PageController pageController = PageController();
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
    print('Start scroll down');
    await _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(seconds: 10), curve: Curves.linear);
    print('Start scroll up');
    await _scrollController.animateTo(0, duration: const Duration(seconds: 10), curve: Curves.linear);
  }
}
