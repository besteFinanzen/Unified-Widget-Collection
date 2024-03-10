import 'package:flutter/material.dart';

class DynamicThemeProvider extends InheritedWidget {
  final DynamicThemeDataWidgetState data;

  const DynamicThemeProvider({super.key,
    required this.data,
    required super.child,
  });

  static DynamicThemeDataWidgetState of(context) {
    return (context.dependOnInheritedWidgetOfExactType<DynamicThemeProvider>()
    as DynamicThemeProvider)
        .data;
  }

  @override
  bool updateShouldNotify(DynamicThemeProvider oldWidget) {
    return this != oldWidget;
  }
}
/// This widget is used to switch the theme of the app at runtime.
/// Make sure you set the [DynamicThemeDataWidget] as parent of a [MaterialApp] or [CupertinoApp].
/// Make sure to set these lines in the [MaterialApp] or [CupertinoApp]:
/// themeMode: DynamicThemeProvider.of(context).themeMode,
/// theme: DynamicThemeProvider.of(context).lightTheme,
/// darkTheme: darkTheme: DynamicThemeProvider.of(context).darkTheme,
class DynamicThemeDataWidget extends StatefulWidget {
  final ThemeData? lightThemeData;
  final ThemeData darkThemeData;
  final ThemeMode themeMode;
  final Widget child;

  const DynamicThemeDataWidget({required this.darkThemeData, this.lightThemeData, required this.child, this.themeMode = ThemeMode.system, super.key});

  @override
  DynamicThemeDataWidgetState createState() => DynamicThemeDataWidgetState();
}

class DynamicThemeDataWidgetState extends State<DynamicThemeDataWidget> {
  late ThemeData darkTheme;
  late ThemeData lightTheme;
  late ThemeMode themeMode;

  @override
  void initState() {
    super.initState();
    darkTheme = widget.darkThemeData;
    lightTheme = widget.lightThemeData ?? widget.darkThemeData;
    themeMode = widget.themeMode;
  }

  /// This method sets the theme to the given theme.
  /// Which theme is set is determined by the brightness attribute of the Theme.
  /// Keep in mind that the themeMode is not changed by this method.
  void setThemeData(final ThemeData theme) {
    if (theme.brightness == Brightness.light) {
      setState(() {
        lightTheme = theme;
      });
    } else {
      setState(() {
        darkTheme = theme;
      });
    }
  }

  /// This forces the theme to be updated.
  /// Don't use this method if you don't have to.
  void forceUpdate() {
    setState(() {});
  }

  /// This method sets the colorScheme to the given colorScheme.
  /// Which colorScheme is set is determined by the brightness attribute of the ColorScheme.
  /// Keep in mind that the theme is not changed by this method.
  void setColorScheme(final ColorScheme colorScheme) {
    if (colorScheme.brightness == Brightness.light) {
      setState(() {
        lightTheme = lightTheme.copyWith(
          colorScheme: colorScheme,
        );
      });
    } else {
      setState(() {
        darkTheme = darkTheme.copyWith(
          colorScheme: colorScheme,
        );
      });
    }
  }

  /// This method sets the themeMode to the given themeMode.
  void switchThemeMode(ThemeMode themeMode) async {
    setState(() {
      this.themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicThemeProvider(
      data: this,
      child: widget.child,
    );
  }
}