import 'package:diabeat/core/session.dart' as session;
import 'package:diabeat/keys.dart';
import 'package:diabeat/routes/guest/guest.dart';
import 'package:diabeat/routes/guest/login.dart';
import 'package:diabeat/routes/guest/register.dart';
import 'package:diabeat/routes/home/account/account.dart';
import 'package:diabeat/routes/home/account/consult/consult.dart';
import 'package:diabeat/routes/home/account/diabetes_form/diabetes_form.dart';
import 'package:diabeat/routes/home/history/history.dart';
import 'package:diabeat/routes/home/home.dart';
import 'package:diabeat/routes/home/record/record.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initPath = await session.initAndRead() ? '/record' : '/guest';
  runApp(_MainApp(initPath));
}

class _MainApp extends StatelessWidget {
  const _MainApp(this._initPath);
  final String _initPath;

  @override
  Widget build(BuildContext context) {
    final insulinImg = const AssetImage('assets/insulin.jpg');
    final healthImg = const AssetImage('assets/health.jpg');
    precacheImage(insulinImg, context);
    precacheImage(healthImg, context);

    final router = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: _initPath,
      routes: [
        GoRoute(
          path: '/guest',
          builder: (context, state) => const GuestPage(),
          routes: [
            GoRoute(
              path: 'login',
              builder: (context, state) => const LoginPage(),
            ),
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
                  builder: (context, state) => RecordPage(key: recordPageKey),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/history',
                  builder: (context, state) => HistoryPage(key: historyPageKey),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/account',
                  builder: (context, state) =>
                      AccountPage(insulinImg: insulinImg, healthImg: healthImg),
                  routes: [
                    GoRoute(
                      path: 'predict_diabetes',
                      builder: (context, state) => const DiabetesFormPage(),
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
          routerConfig: router,
          theme: ThemeData(useMaterial3: true, colorScheme: lightDynamic),
          darkTheme: ThemeData(useMaterial3: true, colorScheme: darkDynamic),
        );
      },
    );
  }
}
