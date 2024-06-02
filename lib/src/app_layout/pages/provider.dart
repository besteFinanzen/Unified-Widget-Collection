import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unified_widget_collection/src/app_layout/provider/model.dart';

import '../appbar/appbar.dart';
import 'configuration.dart';

class TabViewProvider extends UnifiedProvider {
  TabController? _tabController;
  //Every page needs a key to be able to restore the scroll position and the stateful Widgets need a AutomaticKeepAliveClientMixin where the wantKeepAlive getter returns true
  final List<PageConfig> _pageConfigurations;
  final int initialIndex;

  TabViewProvider(BuildContext context, {required List<PageConfig> pages, this.initialIndex = 0}) :
        assert(initialIndex >= 0 && initialIndex < pages.length),
        _pageConfigurations = pages;

  /// Use this method to get the provider outside of the widget tree
  /// For use in the widget tree use the Provider.of method
  static TabViewProvider of(BuildContext context) {
    return Provider.of<TabViewProvider>(context, listen: false);
  }

  void initTabController(TickerProvider vsync) {
    if (_tabController != null) {
      return;
    }
    _tabController = TabController(length: _pageConfigurations.length, vsync: vsync, initialIndex: 0);
  }

  void onPageChanged(BuildContext context) {
    if (_pageConfigurations[currentPageIndex].navigatorKey.currentState != null) {
      AppBarProvider.of(context).setCurrentNavigator(_pageConfigurations[currentPageIndex].navigatorKey.currentState!);
    }
    AppBarProvider.of(context).changeToCurrentPage(context);
    notifyListeners();
  }

  void animateToPage(int page, BuildContext context) {
    tabController.animateTo(page, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future animateToPageOnDifferentNavigator(int page, BuildContext context, Widget scope) async {
    animateToPage(page, context);
    if (_pageConfigurations[page].navigatorKey.currentState != null) {
      await _pageConfigurations[page].navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => scope));
    } else {
      throw Exception('Navigator not found');
    }
  }

  TabController get tabController {
    assert(_tabController != null, 'TabController not initialized');
    return _tabController!;
  }

  PageConfig get currentPage => _pageConfigurations[currentPageIndex];

  int get currentPageIndex => _tabController?.index ?? initialIndex;

  List<PageConfig> get pageConfigurations => _pageConfigurations;

  List<Widget> get pages => _pageConfigurations.map((e) => e.widget).toList();

  List<BottomNavigationBarItem> get bottomBars => _pageConfigurations.map((e) => BottomNavigationBarItem(
    icon: Icon(e.iconInBottomBar),
    label: e.bottomBarTitle,
  )).toList();
}