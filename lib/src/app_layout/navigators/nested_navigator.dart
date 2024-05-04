import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unified_widget_collection/src/app_layout/provider/model.dart';

import '../appbar/appbar.dart';
import '../pages/configuration.dart';

class NestedNavigator extends StatelessWidget {
  const NestedNavigator({super.key, required this.pageConfig, required this.child});
  final PageConfig pageConfig;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (context) => CurrentPageProvider(pageConfig: pageConfig),
      child: Navigator(
        restorationScopeId: pageConfig.bottomBarTitle,
        key: pageConfig.navigatorKey,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => child,
          );
        },
        observers: [
          NavigationObserver(pageConfig),
        ],
      ),
    );
  }
}

class CurrentPageProvider extends UnifiedProvider {
  final PageConfig pageConfig;

  CurrentPageProvider({required this.pageConfig});

  /// Use this method to get the provider outside of the widget tree
  /// For use in the widget tree use the Provider.of method
  static CurrentPageProvider of(BuildContext context) {
    return Provider.of<CurrentPageProvider>(context, listen: false);
  }
}

class NavigationObserver extends NavigatorObserver {
  final PageConfig pageConfig;

  NavigationObserver(this.pageConfig);

  void updateAppBarNavigator(NavigatorState? navigator) {
    if (navigator == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('updateAppBarNavigator');
      if (navigator.mounted == false || navigator.context.mounted == false) {
        return;
      }
      print('updateAppBarNavigator2');
      if (navigator.canPop() != true) {
        print('updateAppBarNavigator3');
        AppBarProvider.of(navigator.context).title.resetForPage(pageConfig, navigator.context);
      }
    });
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('didPop');
    updateAppBarNavigator(route.navigator);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    print('didPush');
    updateAppBarNavigator(route.navigator);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    print('didRemove');
    updateAppBarNavigator(route.navigator);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    print('didReplace');
    updateAppBarNavigator(newRoute?.navigator);
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    print('didStartUserGesture');
    updateAppBarNavigator(route.navigator);
  }
}