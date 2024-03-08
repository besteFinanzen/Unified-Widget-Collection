import 'package:flutter/material.dart';

class ThemeProvider extends InheritedWidget {
  final DynamicThemeDataWidgetState data;

  const ThemeProvider({super.key,
    required this.data,
    required super.child,
  });

  static DynamicThemeDataWidgetState of(context) {
    return (context.dependOnInheritedWidgetOfExactType<ThemeProvider>()
    as ThemeProvider)
        .data;
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return this != oldWidget;
  }
}

/// This widget is used to switch the theme of the app at runtime.
/// Make sure you set the [DynamicThemeDataWidget] as parent of a [MaterialApp] or [CupertinoApp].
/// Make sure to set these lines in the [MaterialApp] or [CupertinoApp]:
/// themeMode: ThemeProvider.of(context).themeMode,
/// theme: ThemeProvider.of(context).lightColorScheme,
/// darkTheme: ThemeProvider.of(context).darkColorScheme,
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
    return ThemeProvider(
      data: this,
      child: widget.child,
    );
  }
}