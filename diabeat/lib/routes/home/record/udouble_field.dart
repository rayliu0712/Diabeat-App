import 'package:flutter/material.dart';

class UdoubleFieldManager {
  UdoubleFieldManager(this.labelText);

  final controller = TextEditingController();
  final focusNode = FocusNode();
  final String labelText;

  double? get value => double.tryParse(controller.text);
}
