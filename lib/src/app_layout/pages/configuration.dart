import 'package:flutter/cupertino.dart';

///Make sure to give every page a unique PageStorageKey as key
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