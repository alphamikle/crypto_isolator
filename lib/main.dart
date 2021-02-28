import 'package:crypto_isolator/base/screens_state.dart';
import 'package:crypto_isolator/binance/binance_service.dart';
import 'package:crypto_isolator/config.dart';
import 'package:crypto_isolator/main_thread/compute_state.dart';
import 'package:crypto_isolator/main_thread/isolate_state.dart';
import 'package:crypto_isolator/main_thread/isolator_state.dart';
import 'package:crypto_isolator/main_thread/main_thread_state.dart';
import 'package:crypto_isolator/style.dart';
import 'package:crypto_isolator/ui/tokens_header.dart';
import 'package:crypto_isolator/ui/tokens_list_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:statsfl/statsfl.dart';

void main() {
  final Widget app = App();
  runApp(
    useFpsMonitor
        ? StatsFl(
            align: Alignment.topCenter,
            height: 40,
            isEnabled: true,
            maxFps: 120,
            width: 350,
            child: app,
          )
        : app,
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScreenState()),
        ChangeNotifierProvider<MainThreadState>(create: (_) => MainThreadState(BinanceService())),
        ChangeNotifierProvider<ComputeState>(create: (_) => ComputeState(BinanceService(useRawData: true))),
        ChangeNotifierProvider<IsolateState>(create: (_) => IsolateState(BinanceService())),
        ChangeNotifierProvider<IsolatorState>(create: (_) => IsolatorState(BinanceService())),
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

class PrimaryView extends StatelessWidget {
  const PrimaryView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScreenState screenStateStatic = Provider.of(context, listen: false);
    final ScreenState screenState = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cryptocus'),
        bottom: const TokensHeader(),
        actions: [
          IconButton(
            splashColor: background.withOpacity(0.2),
            highlightColor: Colors.transparent,
            icon: const Icon(MdiIcons.script),
            onPressed: screenState.scrollDownAndUp,
          ),
        ],
      ),
      body: PageView(
        controller: screenStateStatic.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          TokensListWrapper<MainThreadState>(index: 0),
          TokensListWrapper<ComputeState>(index: 1),
          TokensListWrapper<IsolateState>(index: 2),
          TokensListWrapper<IsolatorState>(index: 3),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(MdiIcons.numeric1CircleOutline), label: 'Main Thread', activeIcon: Icon(MdiIcons.numeric1Circle)),
            BottomNavigationBarItem(icon: Icon(MdiIcons.numeric2CircleOutline), label: 'Compute', activeIcon: Icon(MdiIcons.numeric2Circle)),
            BottomNavigationBarItem(icon: Icon(MdiIcons.numeric3CircleOutline), label: 'Isolate', activeIcon: Icon(MdiIcons.numeric3Circle)),
            BottomNavigationBarItem(icon: Icon(MdiIcons.numeric4CircleOutline), label: 'Isolator', activeIcon: Icon(MdiIcons.numeric4Circle)),
          ],
          currentIndex: screenState.index,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blue,
          onTap: screenStateStatic.changeIndex,
        ),
      ),
    );
  }
}
