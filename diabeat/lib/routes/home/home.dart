import 'package:diabeat/routes/home/history/history.dart';
import 'package:diabeat/routes/home/record/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final _recordKey = GlobalKey<RecordPageState>();
  final _historyKey = GlobalKey<HistoryPageState>();
  final _accountNavigatorKey = GlobalKey<NavigatorState>();

  HomePage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        final router = GoRouter.of(context);

        if (router.canPop()) {
          router.pop();
        } else if (navigationShell.currentIndex > 0) {
          navigationShell.goBranch(0);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (value) {
            primaryFocus?.unfocus();

            // if (value == 1 && _recordKey.currentState!.shouldRefresh) {
            //   _recordKey.currentState!.shouldRefresh = false;
            //   _historyKey.currentState!.getRecords(goToToday: false);
            // }
            navigationShell.goBranch(
              value,
              // 如果在同一 tab 再次點擊，是否要 pop 到該 tab 的根？
              // doesn't work
              initialLocation: value == navigationShell.currentIndex,
            );
          },
          destinations: const [
            NavigationDestination(
              label: '紀錄',
              icon: Icon(Icons.create_outlined),
              selectedIcon: Icon(Icons.create_rounded),
            ),
            NavigationDestination(
              label: '歷史',
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history_rounded),
            ),
            NavigationDestination(
              label: '帳號',
              icon: Icon(Icons.account_circle_outlined),
              selectedIcon: Icon(Icons.account_circle_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
