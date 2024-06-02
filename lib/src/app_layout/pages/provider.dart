import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unified_widget_collection/src/app_layout/provider/model.dart';

import '../appbar/appbar.dart';
import 'configuration.dart';

class TabViewProvider extends UnifiedProvider {
  late final TabController _tabController;
  //Every page needs a key to be able to restore the scroll position and the stateful Widgets need a AutomaticKeepAliveClientMixin where the wantKeepAlive getter returns true
  final List<PageConfig> _pageConfigurations;

  TabViewProvider(BuildContext context, {required List<PageConfig> pages, int initialIndex = 0}) :
        assert(initialIndex >= 0 && initialIndex < pages.length),
        _pageConfigurations = pages {
    _tabController = TabController(length: pages.length, vsync: ScrollableState(), initialIndex: initialIndex);
  }

  /// Use this method to get the provider outside of the widget tree
  /// For use in the widget tree use the Provider.of method
  static TabViewProvider of(BuildContext context) {
    return Provider.of<TabViewProvider>(context, listen: false);
  }

  void onPageChanged(BuildContext context) {
    if (_pageConfigurations[_tabController.index].navigatorKey.currentState != null) {
      AppBarProvider.of(context).setCurrentNavigator(_pageConfigurations[_tabController.index].navigatorKey.currentState!);
    }
    AppBarProvider.of(context).changeToCurrentPage(context);
    notifyListeners();
  }

  void animateToPage(int page, BuildContext context) {
    _tabController.animateTo(page, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future animateToPageOnDifferentNavigator(int page, BuildContext context, Widget scope) async {
    animateToPage(page, context);
    if (_pageConfigurations[page].navigatorKey.currentState != null) {
      await _pageConfigurations[page].navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => scope));
    } else {
      throw Exception('Navigator not found');
    }
  }

  TabController get tabController => _tabController;

  PageConfig get currentPage => _pageConfigurations[_tabController.index];

  List<PageConfig> get pageConfigurations => _pageConfigurations;

  List<Widget> get pages => _pageConfigurations.map((e) => e.widget).toList();

  List<BottomNavigationBarItem> get bottomBars => _pageConfigurations.map((e) => BottomNavigationBarItem(
    icon: Icon(e.iconInBottomBar),
    label: e.bottomBarTitle,
  )).toList();
}