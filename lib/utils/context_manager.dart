import 'package:flutter/material.dart';

class ContextManager {
  static BuildContext? _context;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void setContext(BuildContext context) {
    _context = context;
  }

  static BuildContext? getContext() {
    return _context;
  }

  static GlobalKey<NavigatorState>? getNavigatorKey() {
    return navigatorKey;
  }
}
