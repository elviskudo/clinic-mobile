import 'package:clinic/utils/sizes.dart';
import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff35693e),
      surfaceTint: Color(0xff35693e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb7f1ba),
      onPrimaryContainer: Color(0xff002109),
      secondary: Color(0xff516351),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd4e8d1),
      onSecondaryContainer: Color(0xff0f1f11),
      tertiary: Color(0xff39656d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbdeaf3),
      onTertiaryContainer: Color(0xff001f24),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff7fbf2),
      onSurface: Color(0xff181d18),
      onSurfaceVariant: Color(0xff414941),
      outline: Color(0xff727970),
      outlineVariant: Color(0xffc1c9be),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xff9bd4a0),
      primaryFixed: Color(0xffb7f1ba),
      onPrimaryFixed: Color(0xff002109),
      primaryFixedDim: Color(0xff9bd4a0),
      onPrimaryFixedVariant: Color(0xff1c5129),
      secondaryFixed: Color(0xffd4e8d1),
      onSecondaryFixed: Color(0xff0f1f11),
      secondaryFixedDim: Color(0xffb8ccb6),
      onSecondaryFixedVariant: Color(0xff3a4b3a),
      tertiaryFixed: Color(0xffbdeaf3),
      onTertiaryFixed: Color(0xff001f24),
      tertiaryFixedDim: Color(0xffa1ced7),
      onTertiaryFixedVariant: Color(0xff1f4d54),
      surfaceDim: Color(0xffd7dbd3),
      surfaceBright: Color(0xfff7fbf2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ec),
      surfaceContainer: Color(0xffebefe7),
      surfaceContainerHigh: Color(0xffe5e9e1),
      surfaceContainerHighest: Color(0xffe0e4db),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff174d25),
      surfaceTint: Color(0xff35693e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4b8053),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff364736),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff677966),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff1b4950),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff507b83),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbf2),
      onSurface: Color(0xff181d18),
      onSurfaceVariant: Color(0xff3e453d),
      outline: Color(0xff5a6158),
      outlineVariant: Color(0xff757d73),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xff9bd4a0),
      primaryFixed: Color(0xff4b8053),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff33673c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff677966),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4e614f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff507b83),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff37626a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dbd3),
      surfaceBright: Color(0xfff7fbf2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ec),
      surfaceContainer: Color(0xffebefe7),
      surfaceContainerHigh: Color(0xffe5e9e1),
      surfaceContainerHighest: Color(0xffe0e4db),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00290d),
      surfaceTint: Color(0xff35693e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff174d25),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff152617),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff364736),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00272c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1b4950),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbf2),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1f261f),
      outline: Color(0xff3e453d),
      outlineVariant: Color(0xff3e453d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xffc0fac3),
      primaryFixed: Color(0xff174d25),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003512),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff364736),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff203121),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff1b4950),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003239),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dbd3),
      surfaceBright: Color(0xfff7fbf2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ec),
      surfaceContainer: Color(0xffebefe7),
      surfaceContainerHigh: Color(0xffe5e9e1),
      surfaceContainerHighest: Color(0xffe0e4db),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff9bd4a0),
      surfaceTint: Color(0xff9bd4a0),
      onPrimary: Color(0xff003914),
      primaryContainer: Color(0xff1c5129),
      onPrimaryContainer: Color(0xffb7f1ba),
      secondary: Color(0xffb8ccb6),
      onSecondary: Color(0xff243425),
      secondaryContainer: Color(0xff3a4b3a),
      onSecondaryContainer: Color(0xffd4e8d1),
      tertiary: Color(0xffa1ced7),
      onTertiary: Color(0xff00363d),
      tertiaryContainer: Color(0xff1f4d54),
      onTertiaryContainer: Color(0xffbdeaf3),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff101510),
      onSurface: Color(0xffe0e4db),
      onSurfaceVariant: Color(0xffc1c9be),
      outline: Color(0xff8b9389),
      outlineVariant: Color(0xff414941),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff35693e),
      primaryFixed: Color(0xffb7f1ba),
      onPrimaryFixed: Color(0xff002109),
      primaryFixedDim: Color(0xff9bd4a0),
      onPrimaryFixedVariant: Color(0xff1c5129),
      secondaryFixed: Color(0xffd4e8d1),
      onSecondaryFixed: Color(0xff0f1f11),
      secondaryFixedDim: Color(0xffb8ccb6),
      onSecondaryFixedVariant: Color(0xff3a4b3a),
      tertiaryFixed: Color(0xffbdeaf3),
      onTertiaryFixed: Color(0xff001f24),
      tertiaryFixedDim: Color(0xffa1ced7),
      onTertiaryFixedVariant: Color(0xff1f4d54),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff363a35),
      surfaceContainerLowest: Color(0xff0b0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff262b26),
      surfaceContainerHighest: Color(0xff313630),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa0d8a4),
      surfaceTint: Color(0xff9bd4a0),
      onPrimary: Color(0xff001b06),
      primaryContainer: Color(0xff679d6d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffbcd0ba),
      onSecondary: Color(0xff091a0c),
      secondaryContainer: Color(0xff839682),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffa5d2db),
      onTertiary: Color(0xff001a1e),
      tertiaryContainer: Color(0xff6c98a0),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101510),
      onSurface: Color(0xfff8fcf3),
      onSurfaceVariant: Color(0xffc6cdc2),
      outline: Color(0xff9ea59b),
      outlineVariant: Color(0xff7e857c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff1d522a),
      primaryFixed: Color(0xffb7f1ba),
      onPrimaryFixed: Color(0xff001504),
      primaryFixedDim: Color(0xff9bd4a0),
      onPrimaryFixedVariant: Color(0xff063f19),
      secondaryFixed: Color(0xffd4e8d1),
      onSecondaryFixed: Color(0xff051407),
      secondaryFixedDim: Color(0xffb8ccb6),
      onSecondaryFixedVariant: Color(0xff293a2a),
      tertiaryFixed: Color(0xffbdeaf3),
      onTertiaryFixed: Color(0xff001418),
      tertiaryFixedDim: Color(0xffa1ced7),
      onTertiaryFixedVariant: Color(0xff093c43),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff363a35),
      surfaceContainerLowest: Color(0xff0b0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff262b26),
      surfaceContainerHighest: Color(0xff313630),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff0ffec),
      surfaceTint: Color(0xff9bd4a0),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa0d8a4),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff0ffec),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbcd0ba),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff2fdff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffa5d2db),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101510),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff6fdf1),
      outline: Color(0xffc6cdc2),
      outlineVariant: Color(0xffc6cdc2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff003211),
      primaryFixed: Color(0xffbbf5be),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffa0d8a4),
      onPrimaryFixedVariant: Color(0xff001b06),
      secondaryFixed: Color(0xffd8ecd5),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbcd0ba),
      onSecondaryFixedVariant: Color(0xff091a0c),
      tertiaryFixed: Color(0xffc1eff8),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa5d2db),
      onTertiaryFixedVariant: Color(0xff001a1e),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff363a35),
      surfaceContainerLowest: Color(0xff0b0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff262b26),
      surfaceContainerHighest: Color(0xff313630),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      textTheme: textTheme.apply(
        fontFamily: 'Geist',
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? MaterialTheme.lightScheme().surface
            : MaterialTheme.darkScheme().surface,
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.p8,
          vertical: Sizes.p4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        errorMaxLines: 3,
        hintStyle: textTheme
            .apply(fontFamily: 'Geist')
            .bodyLarge
            ?.copyWith(color: colorScheme.outlineVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.p12,
          vertical: Sizes.p8,
        ),
      ),
    );
  }

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
