import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '/helper/extension/context_extension.dart';

class DefaultThemes {
  InputDecorationTheme? inputDecorationTheme(BuildContext context, dProvider) =>
      InputDecorationTheme(
          hintStyle: WidgetStateTextStyle.resolveWith((states) {
            return Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: dProvider.black5,
                  fontSize: 14,
                );
          }),
          counterStyle: WidgetStateTextStyle.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return context.titleSmall!
                  .copyWith(color: dProvider.primaryColor);
            }
            return Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: dProvider.blackColor);
          }),
          errorMaxLines: 3,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: dProvider.primaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: dProvider.black8, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: dProvider.black8, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: dProvider.warningColor, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: dProvider.warningColor, width: 1),
          ),
          prefixIconColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return dProvider.primaryColor;
            }
            if (states.contains(WidgetState.error)) {
              return dProvider.warningColor;
            }
            return dProvider.black5;
          }));

  CheckboxThemeData? checkboxTheme(dProvider) => CheckboxThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(
          width: 2,
          color: dProvider.black7,
        ),
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return dProvider.primaryColor;
          }
          return dProvider.whiteColor;
        }),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
            side: BorderSide(
              color: dProvider.primaryColor,
            )),
      );
  RadioThemeData? radioThemeData(dProvider) => RadioThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return dProvider.secondaryColor;
          }
          return dProvider.black5;
        }),
        visualDensity: VisualDensity.compact,
      );

  OutlinedButtonThemeData? outlinedButtonTheme(dProvider,
          {foregroundColor, color}) =>
      OutlinedButtonThemeData(
          style: ButtonStyle(
        overlayColor:
            WidgetStateColor.resolveWith((states) => Colors.transparent),
        shape: WidgetStateProperty.resolveWith<OutlinedBorder?>((states) {
          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return BorderSide(
              color: dProvider.primaryColor,
            );
          }
          return BorderSide(
            color: color ?? dProvider.black8,
          );
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return dProvider.primaryColor;
          }
          return foregroundColor ?? dProvider.black5;
        }),
      ));

  ElevatedButtonThemeData? elevatedButtonTheme(dProvider) =>
      ElevatedButtonThemeData(
          style: ButtonStyle(
        elevation: WidgetStateProperty.resolveWith((states) => 0),
        overlayColor:
            WidgetStateColor.resolveWith((states) => Colors.transparent),
        shape: WidgetStateProperty.resolveWith<OutlinedBorder?>((states) {
          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return dProvider.primaryColor.withOpacity(.05);
          }
          if (states.contains(WidgetState.pressed)) {
            return dProvider.blackColor;
          }
          return dProvider.primaryColor;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return dProvider.black5;
          }
          if (states.contains(WidgetState.pressed)) {
            return dProvider.whiteColor;
          }
          return dProvider.whiteColor;
        }),
      ));
  TextButtonThemeData? textButtonThemeData(dProvider) => TextButtonThemeData(
          style: ButtonStyle(
        elevation: WidgetStateProperty.resolveWith((states) => 0),
        overlayColor:
            WidgetStateColor.resolveWith((states) => Colors.transparent),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return dProvider.blackColor.withOpacity(0.0);
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return dProvider.black5;
          }
          if (states.contains(WidgetState.pressed)) {
            return dProvider.blackColor;
          }
          return dProvider.primaryColor;
        }),
      ));

  appBarTheme(BuildContext context) => AppBarTheme(
        backgroundColor: context.dProvider.whiteColor,
        foregroundColor: context.dProvider.blackColor,
        titleTextStyle: context.titleLarge?.bold6,
        elevation: 3,
        surfaceTintColor: context.dProvider.whiteColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark),
      );

  themeData(BuildContext context, dProvider) => ThemeData(
        useMaterial3: true,
        primaryColor: dProvider.primaryColor,
        textTheme: GoogleFonts.getTextTheme('Inter'),
        scaffoldBackgroundColor: dProvider.black9,
        scrollbarTheme: scrollbarTheme(dProvider),
        appBarTheme: DefaultThemes().appBarTheme(context),
        elevatedButtonTheme: elevatedButtonTheme(dProvider),
        outlinedButtonTheme: outlinedButtonTheme(dProvider),
        inputDecorationTheme: inputDecorationTheme(context, dProvider),
        checkboxTheme: checkboxTheme(dProvider),
        textButtonTheme: textButtonThemeData(dProvider),
        switchTheme: switchThemeData(dProvider),
        popupMenuTheme: popupMenuTheme(context, dProvider),
        radioTheme: radioThemeData(dProvider),
      );
}

popupMenuTheme(BuildContext context, dProvider) {
  return PopupMenuThemeData(
      color: dProvider.whiteColor,
      surfaceTintColor: dProvider.whiteColor,
      textStyle: context.titleMedium);
}

SwitchThemeData switchThemeData(dProvider) => SwitchThemeData(
      thumbColor:
          WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return dProvider.primary10;
        }
        return dProvider.whiteColor;
      }),
      trackColor:
          WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (!states.contains(WidgetState.selected)) {
          return dProvider.warningColor.withOpacity(.60);
        }
        return dProvider.greenColor.withOpacity(.60);
      }),
      trackOutlineColor:
          WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (!states.contains(WidgetState.selected)) {
          return dProvider.warningColor.withOpacity(.60);
        }
        return dProvider.greenColor.withOpacity(.40);
      }),
    );

ScrollbarThemeData scrollbarTheme(dProvider) => ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.scrolledUnder)) {
          return true;
        }
        return false;
      }),
      thickness: WidgetStateProperty.resolveWith((states) => 6),
      thumbColor:
          WidgetStateProperty.resolveWith((states) => dProvider.primary60),
    );
