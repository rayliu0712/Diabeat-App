import 'package:diabeat/network/handler.dart' as handler;
import 'package:diabeat/network/session.dart' as session;
import 'package:diabeat/routes/guest/guest.dart';
import 'package:diabeat/routes/guest/login.dart';
import 'package:diabeat/routes/guest/register.dart';
import 'package:diabeat/routes/home/account/account.dart';
import 'package:diabeat/routes/home/account/consult/consult.dart';
import 'package:diabeat/routes/home/account/predict_diabetes/predict_diabetes.dart';
import 'package:diabeat/routes/home/history/history.dart';
import 'package:diabeat/routes/home/home.dart';
import 'package:diabeat/routes/home/record/record.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  navigatorKey: handler.navKey,
  initialLocation: '/guest',
  routes: [
    GoRoute(
      path: '/guest',
      builder: (context, state) => const GuestPage(),
      routes: [
        GoRoute(path: 'login', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: 'register',
          builder: (context, state) => const RegisterPage(),
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomePage(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/record',
              builder: (context, state) => const RecordPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/account',
              builder: (context, state) => const AccountPage(),
              routes: [
                GoRoute(
                  path: 'predict_diabetes',
                  builder: (context, state) => const PredictDiabetesPage(),
                ),
                GoRoute(
                  path: 'consult',
                  builder: (context, state) => const ConsultPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final existSession = await session.load();
  runApp(_MainApp(existSession));
}

class _MainApp extends StatelessWidget {
  const _MainApp(this._existSession);
  final bool _existSession;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        lightDynamic =
            lightDynamic?.harmonized() ??
            ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            );

        darkDynamic =
            darkDynamic?.harmonized() ??
            ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            );

        return MaterialApp.router(
          routerConfig: _router,
          theme: ThemeData(useMaterial3: true, colorScheme: lightDynamic),
          darkTheme: ThemeData(useMaterial3: true, colorScheme: darkDynamic),
        );
      },
    );
  }
}
