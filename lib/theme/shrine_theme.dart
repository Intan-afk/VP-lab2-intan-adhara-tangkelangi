import 'package:flutter/material.dart';

import '../widgets/cut_corners_border.dart';
import 'colors.dart';

ThemeData buildShrineTheme() {
  final ThemeData base = ThemeData.light(useMaterial3: false);

  const BeveledRectangleBorder bevel = BeveledRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(7.0)),
  );

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: kShrinePink100,
      onPrimary: kShrineBrown900,
      secondary: kShrineBrown900,
      error: kShrineErrorRed,
    ),
    textTheme: _buildShrineTextTheme(base.textTheme),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: kShrinePink100,
    ),
    appBarTheme: const AppBarTheme(
      foregroundColor: kShrineBrown900,
      backgroundColor: kShrinePink100,
    ),
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    // Bentuk: kolom teks dengan sudut terpotong
    inputDecorationTheme: const InputDecorationTheme(
      border: CutCornersBorder(),
      focusedBorder: CutCornersBorder(
        borderSide: BorderSide(width: 2.0, color: kShrineBrown900),
      ),
      floatingLabelStyle: TextStyle(color: kShrineBrown900),
    ),
    // Bentuk + elevasi
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(elevation: 8.0, shape: bevel),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kShrineBrown900,
        shape: bevel,
      ),
    ),
  );
}

// Tipografi. Font 'Rubik' opsional: jika belum dipasang, Flutter memakai font bawaan.
TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        headlineSmall: base.headlineSmall!.copyWith(fontWeight: FontWeight.w500),
        titleLarge: base.titleLarge!.copyWith(fontSize: 18.0),
        bodySmall: base.bodySmall!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        bodyLarge: base.bodyLarge!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
        labelLarge: base.labelLarge!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: kShrineBrown900,
        bodyColor: kShrineBrown900,
      );
}