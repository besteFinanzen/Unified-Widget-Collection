import 'package:flutter/cupertino.dart';

class PageConfig {
  final Widget widget;
  final String appBarTitle;
  final IconData iconInBottomBar;
  final String bottomBarTitle;
  late final GlobalKey<NavigatorState> navigatorKey;

  PageConfig({
    required this.widget,
    required this.appBarTitle,
    required this.iconInBottomBar,
    required this.bottomBarTitle,
  }) {
    navigatorKey = GlobalKey<NavigatorState>();
  }
}