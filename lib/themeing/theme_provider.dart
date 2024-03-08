import 'package:flutter/material.dart';

class _ThemeSwitcher extends InheritedWidget {
  final DynamicThemeWidgetState data;

  const _ThemeSwitcher({
    required this.data,
    required super.child,
  });

  static DynamicThemeWidgetState of(context) {
    return (context.dependOnInheritedWidgetOfExactType<_ThemeSwitcher>()
    as _ThemeSwitcher)
        .data;
  }

  @override
  bool updateShouldNotify(_ThemeSwitcher oldWidget) {
    return this != oldWidget;
  }
}

/// This widget is used to switch the theme of the app at runtime.
class DynamicThemeWidget extends StatefulWidget {
  final ColorScheme? lightColorScheme;
  final ColorScheme darkColorScheme;
  final ThemeMode themeMode;
  final Widget child;

  const DynamicThemeWidget({required this.darkColorScheme, this.lightColorScheme, required this.child, this.themeMode = ThemeMode.system, super.key});

  @override
  DynamicThemeWidgetState createState() => DynamicThemeWidgetState();
}

class DynamicThemeWidgetState extends State<DynamicThemeWidget> {
  ColorScheme? darkColorScheme;
  ColorScheme? lightColorScheme;
  ThemeMode? themeMode;

  /// This method sets the theme to the given theme.
  /// Which theme is set is determined by the brightness of the [theme].
  /// Keep in mind that the themeMode is not changed by this method.
  void setTheme(final ColorScheme theme) {
    if (theme.brightness == Brightness.light) {
      setState(() {
        lightColorScheme = theme;
      });
    } else {
      setState(() {
        darkColorScheme = theme;
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
    darkColorScheme = darkColorScheme ?? widget.darkColorScheme;
    lightColorScheme = lightColorScheme ?? widget.lightColorScheme;
    themeMode = themeMode ?? widget.themeMode;
    return _ThemeSwitcher(
      data: this,
      child: widget.child,
    );
  }
}