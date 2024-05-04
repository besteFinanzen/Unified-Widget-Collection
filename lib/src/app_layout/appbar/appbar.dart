import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:unified_widget_collection/src/app_layout/provider/model.dart';

import '../pages/configuration.dart';
import '../pages/provider.dart';

/// Provider for the app bar title and actions
/// To set the title of a subpage use:
///     WidgetsBinding.instance.addPostFrameCallback((_) {
///       Provider.of<AppBarProvider>(context, listen: false).setTitleForPage("TITEL", CurrentPageProvider.of(context).pageConfig, context);
///     });
class AppBarProvider extends UnifiedProvider {
  final AppBarActions actions;
  final AppBarTitle title;
  NavigatorState? _currentNavigatorKey;

  AppBarProvider({
    final String defaultTitle = 'Startseite',
    final List<Widget> defaultAppBarActions = const [],
    final NavigatorState? currentNavigatorState
  }) : _currentNavigatorKey = currentNavigatorState, actions = AppBarActions(defaultActions: defaultAppBarActions), title = AppBarTitle(defaultTitle: defaultTitle);

  /// Use this method to get the provider outside of the widget tree
  /// For use in the widget tree use the Provider.of method
  static AppBarProvider of(BuildContext context) {
    return Provider.of<AppBarProvider>(context, listen: false);
  }

  void setCurrentNavigator(NavigatorState navigatorKey) {
    _currentNavigatorKey = navigatorKey;
    notifyListeners();
  }
  void clearCurrentNavigator() {
    _currentNavigatorKey = null;
    notifyListeners();
  }

  void changeToCurrentPage(BuildContext context) {
    title.changeToCurrentPage(context);
    actions.changeToCurrentPage(context);
  }

  NavigatorState? get currentNavigatorKey => _currentNavigatorKey;
}

abstract class AppBarFunctions {
  void changeToCurrentPage(BuildContext context);
  void resetForPage(PageConfig pageConfig, BuildContext context);
}

class AppBarActions extends AppBarFunctions with ChangeNotifier {
  final List<Widget> _defaultActions;
  List<Widget> _currentActions = [];
  final Map<PageConfig, List<Widget>> _pageActions = {};

  AppBarActions({
    List<Widget> defaultActions = const [],
  }) : _defaultActions = defaultActions;

  void update(List<Widget> actions) {
    _currentActions = actions;
    notifyListeners();
  }

  void setForPage(List<Widget> actions, PageConfig pageConfig, BuildContext context) {
    _pageActions[pageConfig] = actions;
    changeToCurrentPage(context);
  }

  @override
  void changeToCurrentPage(BuildContext context) {
    _currentActions = _pageActions[Provider.of<PageViewProvider>(context, listen: false).currentPage] ?? _defaultActions;
    notifyListeners();
  }

  @override
  void resetForPage(PageConfig pageConfig, BuildContext context) {
    _pageActions.remove(pageConfig);
    changeToCurrentPage(context);
    notifyListeners();
  }

  List<Widget> get currentActions => _currentActions;
}

class AppBarTitle extends AppBarFunctions with ChangeNotifier {
  String _currentTitle;
  final Map<PageConfig, String> _pageTitles = {};

  AppBarTitle({
    final String defaultTitle = 'Startseite',
  }) : _currentTitle = defaultTitle;

  void update(String title) {
    _currentTitle = title;
    notifyListeners();
  }

  void setForPage(String title, PageConfig pageConfig, BuildContext context) {
    _pageTitles[pageConfig] = title;
    changeToCurrentPage(context);
  }

  @override
  void changeToCurrentPage(BuildContext context) {
    _currentTitle = _pageTitles[Provider.of<PageViewProvider>(context, listen: false).currentPage] ?? Provider.of<PageViewProvider>(context, listen: false).currentPage.appBarTitle;
    print('AppBarTitle: $_currentTitle');
    notifyListeners();
  }

  @override
  void resetForPage(PageConfig pageConfig, BuildContext context) {
    _pageTitles.remove(pageConfig);
    changeToCurrentPage(context);
    notifyListeners();
  }

  String get currentTitle => _currentTitle;
}