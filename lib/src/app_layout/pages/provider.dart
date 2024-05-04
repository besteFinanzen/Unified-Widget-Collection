import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../appbar/appbar.dart';
import 'configuration.dart';

class PageViewProvider with ChangeNotifier {
  final PageController _pageViewController = PageController(initialPage: 0);
  int _currentIndex;
  //Every page needs a key to be able to restore the scroll position and the stateful Widgets need a AutomaticKeepAliveClientMixin where the wantKeepAlive getter returns true
  final List<PageConfig> _pageConfigurations;

  PageViewProvider({required List<PageConfig> pages, int initialIndex = 0}) :
        assert(initialIndex >= 0 && initialIndex < pages.length),
        _pageConfigurations = pages, _currentIndex = initialIndex;

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
      Provider.of<AppBarProvider>(context, listen: false).setCurrentNavigator(_pageConfigurations[page].navigatorKey.currentState!);
    }
    Provider.of<AppBarProvider>(context, listen: false).title.changeToCurrentPage(context);
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


class CurrentPageProvider extends InheritedWidget {
  final CurrentPageProviderWidgetState pageConfig;

  const CurrentPageProvider({super.key,
    required this.pageConfig,
    required super.child,
  });

  static CurrentPageProviderWidgetState of(context) {
    return (context.dependOnInheritedWidgetOfExactType<CurrentPageProvider>()
    as CurrentPageProvider)
        .pageConfig;
  }

  @override
  bool updateShouldNotify(CurrentPageProvider oldWidget) {
    return this != oldWidget;
  }
}

class CurrentPageProviderWidget extends StatefulWidget {
  final Widget child;
  final PageConfig pageConfig;
  const CurrentPageProviderWidget({required this.child, required this.pageConfig, super.key});

  @override
  CurrentPageProviderWidgetState createState() => CurrentPageProviderWidgetState();
}

class CurrentPageProviderWidgetState extends State<CurrentPageProviderWidget> {
  late final PageConfig pageConfig;

  @override
  void initState() {
    super.initState();
    pageConfig = widget.pageConfig;
  }


  @override
  Widget build(BuildContext context) {
    return CurrentPageProvider(
      pageConfig: this,
      child: widget.child,
    );
  }
}