import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unified_widget_collection/src/app_layout/appbar/appbar.dart';
import 'package:unified_widget_collection/src/app_layout/navigators/nested_navigator.dart';
import 'package:unified_widget_collection/src/app_layout/pages/provider.dart';

class AppBarsTabView extends StatelessWidget {
  final AppBarProvider appBarProvider;
  final TabViewProvider tabViewProvider;
  final PreferredSizeWidget Function(BuildContext) appBar;
  final Widget body;
  final Widget Function(BuildContext, TabViewProvider) bottomNavigationBar;

  const AppBarsTabView({
    required this.appBarProvider,
    required this.tabViewProvider,
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
          create: (context) => tabViewProvider,
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

class TabViewWidget extends StatefulWidget {
  final Function(int)? onPageChanged;
  const TabViewWidget({super.key, this.onPageChanged});

  @override
  State<TabViewWidget> createState() => _TabViewWidgetState();
}

class _TabViewWidgetState extends State<TabViewWidget> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
   Provider.of<TabViewProvider>(context, listen: false).initTabController(this);
   Provider.of<TabViewProvider>(context, listen: false).tabController.addListener(() {
      if (Provider.of<TabViewProvider>(context).tabController.indexIsChanging) {
        Provider.of<TabViewProvider>(context).onPageChanged(context);
      }
    });
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