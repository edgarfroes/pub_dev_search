import 'package:flutter/material.dart';

const int _lightColorValue = 0xFF22FFCA;
const int _darkColorValue = 0xFF1D1C17;

const MaterialColor colorScheme = MaterialColor(
  _lightColorValue,
  <int, Color>{
    50: Color(_lightColorValue),
    100: Color(_lightColorValue),
    200: Color(_lightColorValue),
    300: Color(_lightColorValue),
    // only for raised button while pressed in light theme
    350: Color(_lightColorValue),
    400: Color(_lightColorValue),
    500: Color(_lightColorValue),
    600: Color(_lightColorValue),
    700: Color(_darkColorValue),
    800: Color(_darkColorValue),
    // only for background color in dark theme
    850: Color(_darkColorValue),
    900: Color(_darkColorValue),
  },
);

final _baseTextStyle = TextStyle(
  color: colorScheme.shade500,
);

final _baseTextTheme = TextTheme(
  displayLarge: _baseTextStyle,
  displayMedium: _baseTextStyle,
  displaySmall: _baseTextStyle,
  headlineLarge: _baseTextStyle,
  headlineMedium: _baseTextStyle,
  headlineSmall: _baseTextStyle,
  titleLarge: _baseTextStyle,
  titleMedium: _baseTextStyle,
  titleSmall: _baseTextStyle,
  bodyLarge: _baseTextStyle,
  bodyMedium: _baseTextStyle,
  bodySmall: _baseTextStyle,
  labelLarge: _baseTextStyle,
  labelMedium: _baseTextStyle,
  labelSmall: _baseTextStyle,
);

final mainTheme = ThemeData(
  primarySwatch: colorScheme,
  textTheme: _baseTextTheme,
  scaffoldBackgroundColor: colorScheme.shade900,
  listTileTheme: ListTileThemeData(
    textColor: colorScheme.shade500,
  ),
  dividerColor: colorScheme.shade500,
  dividerTheme: const DividerThemeData(
    thickness: 1,
    space: 1,
  ),
  primaryTextTheme: _baseTextTheme,
);
