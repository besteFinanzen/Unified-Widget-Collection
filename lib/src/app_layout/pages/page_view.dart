import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unified_widget_collection/src/app_layout/appbar/appbar.dart';
import 'package:unified_widget_collection/src/app_layout/navigators/nested_navigator.dart';
import 'package:unified_widget_collection/src/app_layout/pages/provider.dart';

class AppBarsPageView extends StatelessWidget {
  final AppBarProvider appBarProvider;
  final PageViewProvider pageViewProvider;
  final PreferredSizeWidget Function(BuildContext) appBar;
  final Widget body;
  final Widget Function(BuildContext, PageViewProvider) bottomNavigationBar;

  const AppBarsPageView({
    required this.appBarProvider,
    required this.pageViewProvider,
    required this.body,
    required this.bottomNavigationBar,
    required this.appBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<AppBarProvider>(
          create: (context) => appBarProvider,
        ),
        ListenableProvider<PageViewProvider>(
          create: (context) => pageViewProvider,
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: appBar(context),
            body: body,
            bottomNavigationBar: Consumer<PageViewProvider>(
              builder: (context, value, _) => bottomNavigationBar(context, value),
            )
          );
        }
      ),
    );
  }
}

class PageViewWidget extends StatelessWidget {
  final Function(int)? onPageChanged;
  const PageViewWidget({super.key, this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      restorationId: 'home_page',
      key: const PageStorageKey('home_page'),
      controller: Provider.of<PageViewProvider>(context).pageViewController,
      allowImplicitScrolling: true,
      onPageChanged: (index) {
        print('PageViewWidget: $index');
        Provider.of<PageViewProvider>(context, listen: false).onPageChanged(index, context);
        onPageChanged?.call(index);
      },
      itemCount: Provider.of<PageViewProvider>(context).pages.length,
      itemBuilder: (context, index) {
        return NestedNavigator(
            pageConfig: Provider.of<PageViewProvider>(context).pageConfigurations[index],
            //navigatorKey: GlobalKey<NavigatorState>(),
            child: Provider.of<PageViewProvider>(context).pages[index]
        );
      },
    );
  }
}