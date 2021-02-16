import 'package:crypto_isolator/binance/binance_service.dart';
import 'package:crypto_isolator/main_thread/main_thread_state.dart';
import 'package:crypto_isolator/ui/tokens_header.dart';
import 'package:crypto_isolator/ui/tokens_list_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainThreadState>(create: (_) => MainThreadState(BinanceService())),
      ],
      child: MaterialApp(
        title: 'Cryptocus',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const PrimaryView(),
      ),
    );
  }
}

class PrimaryView extends StatefulWidget {
  const PrimaryView({Key key}) : super(key: key);

  @override
  _PrimaryViewState createState() => _PrimaryViewState();
}

class _PrimaryViewState extends State<PrimaryView> {
  final PageController _controller = PageController();
  int _index = 0;

  void _selectIndex(int newIndex) {
    setState(() {
      _index = newIndex;
      _controller.animateToPage(newIndex, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cryptocus'),
        bottom: const TokensHeader(),
      ),
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          TokensListWrapper<MainThreadState>(),
          Center(child: Text('Second')),
          Center(child: Text('Third')),
          Center(child: Text('Fourth')),
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
