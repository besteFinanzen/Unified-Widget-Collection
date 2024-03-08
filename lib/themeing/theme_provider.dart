import 'package:flutter/material.dart';

class _ThemeDataSwitcher extends InheritedWidget {
  final DynamicThemeDataWidgetState data;

  const _ThemeDataSwitcher({
    required this.data,
    required super.child,
  });

  static DynamicThemeDataWidgetState of(context) {
    return (context.dependOnInheritedWidgetOfExactType<_ThemeDataSwitcher>()
    as _ThemeDataSwitcher)
        .data;
  }

  @override
  bool updateShouldNotify(_ThemeDataSwitcher oldWidget) {
    return this != oldWidget;
  }
}

/// This widget is used to switch the theme of the app at runtime.
/// Make sure you set the [DynamicThemeDataWidget] as parent of a [MaterialApp] or [CupertinoApp].
/// These should have the [themeMode] set to ThemeSwitcher.of(context).themeMode.
/// ALso the theme should be set to ThemeSwitcher.of(context).getThemeData(ThemeSwitcher.of(context).colorScheme).
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
  ThemeData? darkColorScheme;
  ThemeData? lightColorScheme;
  ThemeMode? themeMode;

  /// This method sets the theme to the given theme.
  /// Which theme is set is determined by the brightness attribute of the Theme.
  /// Keep in mind that the themeMode is not changed by this method.
  void setThemeData(final ThemeData theme) {
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

  ThemeData getThemeData(ColorScheme? colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        iconTheme: Theme.of(context).iconTheme.copyWith(
          size: 30,
        ),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  /// This method sets the themeMode to the given themeMode.
  void switchThemeMode(ThemeMode themeMode) async {
    setState(() {
      this.themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    darkColorScheme = darkColorScheme ?? widget.darkThemeData;
    lightColorScheme = lightColorScheme ?? widget.lightThemeData;
    themeMode = themeMode ?? widget.themeMode;
    return _ThemeDataSwitcher(
      data: this,
      child: widget.child,
    );
  }
}