import 'package:flutter/material.dart';

class ContextManager {
  static BuildContext? _context;

  static void setContext(BuildContext context) {
    _context = context;
  }

  static BuildContext? getContext() {
    return _context;
  }
}