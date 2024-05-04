import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../appbar/appbar.dart';
import '../pages/configuration.dart';
import '../pages/provider.dart';

class NestedNavigator extends StatelessWidget {
  const NestedNavigator({super.key, required this.pageConfig, required this.child});
  final PageConfig pageConfig;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CurrentPageProviderWidget(
      pageConfig: pageConfig,
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

class NavigationObserver extends NavigatorObserver {
  final PageConfig pageConfig;

  NavigationObserver(this.pageConfig);

  void updateAppBarNavigator(NavigatorState? navigator) {
    if (navigator == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigator.mounted == false || navigator.context.mounted == false) {
        return;
      }
      if (navigator.canPop() != true) {
        Provider.of<AppBarProvider>(navigator.context, listen: false).title.resetForPage(pageConfig, navigator.context);
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