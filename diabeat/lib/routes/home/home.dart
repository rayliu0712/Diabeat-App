import 'dart:developer';

import 'package:diabeat/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomePage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        _onPop(context, didPop, result);
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
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

  void _onPop(BuildContext context, bool didPop, Object? result) {
    if (didPop) {
      return;
    }

    if (context.canPop()) {
      context.pop();
      return;
    }

    if (navigationShell.currentIndex > 0) {
      navigationShell.goBranch(0);
      return;
    }

    SystemNavigator.pop();
  }

  void _onDestinationSelected(int index) {
    primaryFocus?.unfocus();

    if (index == 1) {
      if (recordPageKey.currentState!.shouldRefresh) {
        recordPageKey.currentState!.shouldRefresh = false;
        historyPageKey.currentState?.getRecords(goToday: false);
      } else if (navigationShell.currentIndex == 1) {
        historyPageKey.currentState!.goToday();
      }
    }

    navigationShell.goBranch(index);
  }
}
