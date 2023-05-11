import 'package:flutter/material.dart';

double MediaWidth(BuildContext context, double? customSize) {
  final givenSize = customSize ?? 1.0;
  return MediaQuery.of(context).size.width / givenSize;
}

double MediaHeight(BuildContext context, double? customSize) {
  final givenSize = customSize ?? 1.0;
  return MediaQuery.of(context).size.height / givenSize;
}

double MediaAspectRatio(BuildContext context, double? customSize) {
  final givenSize = customSize ?? 1.0;
  return MediaQuery.of(context).size.aspectRatio / givenSize;
}
