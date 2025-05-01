import 'package:flutter/material.dart';

extension MediaQueryEx on BuildContext {
  double get allWidth => MediaQuery.of(this).size.width;
  double get allHeight => MediaQuery.of(this).size.height;
}

extension SizedBoxEx on num {
  SizedBox get width => SizedBox(width: toDouble());
  SizedBox get height => SizedBox(height: toDouble());
}