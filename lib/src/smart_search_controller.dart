import 'dart:ui';

class SmartSearchController {
  VoidCallback? _clear;

  void attach(VoidCallback clear) => _clear = clear;
  void clear() => _clear?.call();
}
