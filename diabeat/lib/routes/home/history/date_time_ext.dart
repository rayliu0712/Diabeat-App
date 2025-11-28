import 'package:diabeat/util.dart' as util;

extension DateTimeExt on DateTime {
  DateTime get date => DateTime(year, month, day);

  String get dateString =>
      '$year-${util.pad2Zero(month)}-${util.pad2Zero(day)}';

  String get timeString => '${util.pad2Zero(hour)}:${util.pad2Zero(minute)}';
}

DateTime get todayDate => today.date;

DateTime get today => DateTime.now();
