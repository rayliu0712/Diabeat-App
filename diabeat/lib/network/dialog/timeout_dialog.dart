import 'package:diabeat/util.dart' as util;
import 'package:flutter/material.dart';

class TimeoutDialog extends StatelessWidget {
  const TimeoutDialog._();

  /// retry  : true
  ///
  /// cancel : null
  static Future<dynamic> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const TimeoutDialog._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('連線逾時', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.tonalIcon(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: util.tonalPageButtonStyle(context),
            icon: const Icon(Icons.replay_rounded),
            label: const Text('重試'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            style: util.outlinedPageButtonStyle(),
            icon: const Icon(Icons.close_rounded),
            label: const Text('取消'),
          ),
        ],
      ),
    );
  }
}
