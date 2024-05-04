import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unified_widget_collection/src/app_layout/provider/model.dart';

import '../appbar/appbar.dart';
import 'configuration.dart';

class PageViewProvider extends UnifiedProvider {
  final PageController _pageViewController = PageController(initialPage: 0);
  int _currentIndex;
  //Every page needs a key to be able to restore the scroll position and the stateful Widgets need a AutomaticKeepAliveClientMixin where the wantKeepAlive getter returns true
  final List<PageConfig> _pageConfigurations;

  PageViewProvider({required List<PageConfig> pages, int initialIndex = 0}) :
        assert(initialIndex >= 0 && initialIndex < pages.length),
        _pageConfigurations = pages, _currentIndex = initialIndex;

  /// Use this method to get the provider outside of the widget tree
  /// For use in the widget tree use the Provider.of method
  static PageViewProvider of(BuildContext context) {
    return Provider.of<PageViewProvider>(context, listen: false);
  }

  void animateToPage(int page, BuildContext context) {
    _pageViewController.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    onPageChanged(page, context);
  }

  Future animateToPageOnDifferentNavigator(int page, BuildContext context, Widget scope) async {
    animateToPage(page, context);
    if (_pageConfigurations[page].navigatorKey.currentState != null) {
      await _pageConfigurations[page].navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => scope));
    } else {
      throw Exception('Navigator not found');
    }
  }

  void onPageChanged(int page, BuildContext context) {
    _currentIndex = page;
    if (_pageConfigurations[page].navigatorKey.currentState != null) {
      AppBarProvider.of(context).setCurrentNavigator(_pageConfigurations[page].navigatorKey.currentState!);
    }
    AppBarProvider.of(context).changeToCurrentPage(context);
    notifyListeners();
  }

  int get currentIndex => _currentIndex;

  PageController get pageViewController => _pageViewController;

  PageConfig get currentPage => _pageConfigurations[_currentIndex];

  List<PageConfig> get pageConfigurations => _pageConfigurations;

  List<Widget> get pages => _pageConfigurations.map((e) => e.widget).toList();

  List<BottomNavigationBarItem> get bottomBars => _pageConfigurations.map((e) => BottomNavigationBarItem(
    icon: Icon(e.iconInBottomBar),
    label: e.bottomBarTitle,
  )).toList();
}