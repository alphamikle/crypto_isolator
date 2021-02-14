import 'dart:async';
import 'dart:math';

import 'package:crypto_api_app/models/token_data.dart';
import 'package:crypto_api_app/ui/token_list_view.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:statsfl/statsfl.dart';

void main() {
  runApp(
    StatsFl(
      align: Alignment.topCenter,
      height: 40,
      isEnabled: true,
      maxFps: 120,
      width: 350,
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cryptocus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PrimaryView(),
    );
  }
}

class PrimaryView extends StatefulWidget {
  const PrimaryView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PrimaryViewState createState() => _PrimaryViewState();
}

const int limit = 300;

class _PrimaryViewState extends State<PrimaryView> {
  final PageController _controller = PageController();
  final List<TokenData> _tokens = [];
  final List<TokenData> _initialTokens = [];
  Timer _timer;
  int _index = 0;
  bool _isLoading = true;
  int _refreshTime = 1000;

  void _selectIndex(int newIndex) {
    setState(() {
      _index = newIndex;
      _controller.animateToPage(newIndex, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    });
  }

  String _randomToken() {
    final List<String> alphabet = 'ABCDEFGHIJCLMNOPUVWXYZ'.split('');
    alphabet.shuffle();
    return alphabet.getRange(0, 3).join('');
  }

  double _randomIn(double min, double max) {
    return (Random().nextDouble() * max).floorToDouble() + min;
  }

  void _changeRefreshTime(int newTime) {
    _refreshTime = newTime;
  }

  void _start() {
    _timer = Timer(Duration(milliseconds: _refreshTime), () {
      _refreshTokens();
      _start();
    });
  }

  void _refreshTokens() {
    final bool firstTime = _tokens.isEmpty;
    for (int i = 0; i < limit; i++) {
      if (firstTime) {
        final double price = _randomIn(10.0, 10000.0);
        final double minPrice = price * _randomIn(0.8, 0.9);
        final double maxPrice = price * _randomIn(1.1, 1.2);
        const double diff = 0;
        final TokenData tokenData = TokenData(title: _randomToken(), price: price, minPrice: minPrice, maxPrice: maxPrice, diff: diff);
        _tokens.add(tokenData);
        _initialTokens.add(tokenData);
      } else {
        final TokenData oldToken = _tokens[i];
        final TokenData oldInitialToken = _initialTokens[i];
        final double diffCf = (oldToken.price - oldInitialToken.price) / oldInitialToken.price * 100;
        final double cf = diffCf < -75
            ? _randomIn(1.05, 1.10)
            : diffCf > 75
                ? _randomIn(0.90, 0.95)
                : _randomIn(0.98, 1.03);
        final double price = oldToken.price * cf;
        final double minPrice = price * 0.9;
        final double maxPrice = price * 1.1;
        final double diff = (price - oldInitialToken.price) / oldInitialToken.price * 100;
        _tokens[i] = oldToken.copyWith(price: price, minPrice: minPrice, maxPrice: maxPrice, diff: diff);
      }
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cryptocus'),
        actions: [
          DropdownButton<int>(
            items: [
              for (int i = 200; i < 2200; i += 200) DropdownMenuItem(child: Text('$i'), value: i),
            ],
            onChanged: _changeRefreshTime,
            icon: const Icon(MdiIcons.dotsVertical, color: Colors.white),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                TokenListView(tokens: _tokens),
                const Center(child: Text('Second')),
                const Center(child: Text('Third')),
                const Center(child: Text('Fourth')),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(MdiIcons.numeric1CircleOutline), label: 'Main Thread', activeIcon: Icon(MdiIcons.numeric1Circle)),
          BottomNavigationBarItem(icon: Icon(MdiIcons.numeric2CircleOutline), label: 'Compute', activeIcon: Icon(MdiIcons.numeric2Circle)),
          BottomNavigationBarItem(icon: Icon(MdiIcons.numeric3CircleOutline), label: 'Isolate', activeIcon: Icon(MdiIcons.numeric3Circle)),
          BottomNavigationBarItem(icon: Icon(MdiIcons.numeric4CircleOutline), label: 'Isolator', activeIcon: Icon(MdiIcons.numeric4Circle)),
        ],
        currentIndex: _index,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        onTap: _selectIndex,
      ),
    );
  }
}
