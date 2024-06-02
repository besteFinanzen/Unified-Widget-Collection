import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unified_widget_collection/src/app_layout/appbar/appbar.dart';
import 'package:unified_widget_collection/src/app_layout/navigators/nested_navigator.dart';
import 'package:unified_widget_collection/src/app_layout/pages/provider.dart';

class AppBarsPageView extends StatelessWidget {
  final AppBarProvider appBarProvider;
  final TabViewProvider pageViewProvider;
  final PreferredSizeWidget Function(BuildContext) appBar;
  final Widget body;
  final Widget Function(BuildContext, TabViewProvider) bottomNavigationBar;

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
        ListenableProvider<TabViewProvider>(
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
            bottomNavigationBar: Consumer<TabViewProvider>(
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
   return TabBarView(
      key: const PageStorageKey('home_page'),
      controller: Provider.of<TabViewProvider>(context).tabController,
      children: Provider.of<TabViewProvider>(context).pages.map((e) => NestedNavigator(
        pageConfig: TabViewProvider.of(context).pageConfigurations[Provider.of<TabViewProvider>(context).pages.indexOf(e)],
        child: e
      )).toList(),
    );
  }
}