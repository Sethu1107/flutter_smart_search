import 'package:flutter/cupertino.dart';

extension SmartVisibleExtension on Widget {
  Widget onVisibleKeepSpace(bool isVisible) {
    return isVisible?this:SizedBox.shrink();
  }
}