import 'package:diabeat/routes/home/history/history.dart';
import 'package:diabeat/routes/home/record/record.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final recordPageKey = GlobalKey<RecordPageState>();
final historyPageKey = GlobalKey<HistoryPageState>();

BuildContext get globalContext => navigatorKey.currentContext!;
