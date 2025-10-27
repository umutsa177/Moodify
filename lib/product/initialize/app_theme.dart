import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';

@immutable
final class AppTheme {
  const AppTheme(this.context);

  final BuildContext context;
  ThemeData get theme =>
      ThemeData(
        useMaterial3: true,
      ).copyWith(
        textTheme: context.general.textTheme.copyWith(
          titleLarge: context.general.textTheme.titleLarge?.copyWith(
            fontFamily: 'Epilogue',
          ),
          titleMedium: context.general.textTheme.titleMedium?.copyWith(
            fontFamily: 'Epilogue',
          ),
          titleSmall: context.general.textTheme.titleSmall?.copyWith(
            fontFamily: 'Epilogue',
          ),
          bodyLarge: context.general.textTheme.bodyLarge?.copyWith(
            fontFamily: 'Epilogue',
          ),
          bodyMedium: context.general.textTheme.bodyMedium?.copyWith(
            fontFamily: 'Epilogue',
          ),
          bodySmall: context.general.textTheme.bodySmall?.copyWith(
            fontFamily: 'Epilogue',
          ),
          labelLarge: context.general.textTheme.labelLarge?.copyWith(
            fontFamily: 'Epilogue',
          ),
          labelMedium: context.general.textTheme.labelMedium?.copyWith(
            fontFamily: 'Epilogue',
          ),
          labelSmall: context.general.textTheme.labelSmall?.copyWith(
            fontFamily: 'Epilogue',
          ),
          displaySmall: context.general.textTheme.displaySmall?.copyWith(
            fontFamily: 'Epilogue',
          ),
          displayMedium: context.general.textTheme.displayMedium?.copyWith(
            fontFamily: 'Epilogue',
          ),
          displayLarge: context.general.textTheme.displayLarge?.copyWith(
            fontFamily: 'Epilogue',
          ),
          headlineSmall: context.general.textTheme.headlineSmall?.copyWith(
            fontFamily: 'Epilogue',
          ),
          headlineMedium: context.general.textTheme.headlineMedium?.copyWith(
            fontFamily: 'Epilogue',
          ),
          headlineLarge: context.general.textTheme.headlineLarge?.copyWith(
            fontFamily: 'Epilogue',
          ),
        ),
        primaryTextTheme: context.general.primaryTextTheme.copyWith(
          titleLarge: context.general.primaryTextTheme.titleLarge?.copyWith(
            fontFamily: 'Epilogue',
          ),
          titleMedium: context.general.primaryTextTheme.titleMedium?.copyWith(
            fontFamily: 'Epilogue',
          ),
          titleSmall: context.general.primaryTextTheme.titleSmall?.copyWith(
            fontFamily: 'Epilogue',
          ),
          bodyLarge: context.general.primaryTextTheme.bodyLarge?.copyWith(
            fontFamily: 'Epilogue',
          ),
          bodyMedium: context.general.primaryTextTheme.bodyMedium?.copyWith(
            fontFamily: 'Epilogue',
          ),
          bodySmall: context.general.primaryTextTheme.bodySmall?.copyWith(
            fontFamily: 'Epilogue',
          ),
          labelLarge: context.general.primaryTextTheme.labelLarge?.copyWith(
            fontFamily: 'Epilogue',
          ),
          labelMedium: context.general.primaryTextTheme.labelMedium?.copyWith(
            fontFamily: 'Epilogue',
          ),
          labelSmall: context.general.primaryTextTheme.labelSmall?.copyWith(
            fontFamily: 'Epilogue',
          ),
          displaySmall: context.general.primaryTextTheme.displaySmall?.copyWith(
            fontFamily: 'Epilogue',
          ),
          displayMedium: context.general.primaryTextTheme.displayMedium
              ?.copyWith(
                fontFamily: 'Epilogue',
              ),
          displayLarge: context.general.primaryTextTheme.displayLarge?.copyWith(
            fontFamily: 'Epilogue',
          ),
          headlineSmall: context.general.primaryTextTheme.headlineSmall
              ?.copyWith(
                fontFamily: 'Epilogue',
              ),
          headlineMedium: context.general.primaryTextTheme.headlineMedium
              ?.copyWith(
                fontFamily: 'Epilogue',
              ),
          headlineLarge: context.general.primaryTextTheme.headlineLarge
              ?.copyWith(
                fontFamily: 'Epilogue',
              ),
        ),

        cardTheme: CardThemeData(
          margin: context.padding.low,
          color: ColorConstant.emojiColor,
          elevation: DoubleConstant.four,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.sized.lowValue),
            side: const BorderSide(color: ColorConstant.transparent),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorConstant.transparent,
          centerTitle: true,
          elevation: DoubleConstant.zero,
          surfaceTintColor: Colors.transparent,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: ColorConstant.navBarBackground,
          elevation: DoubleConstant.zero,
          selectedItemColor: const Color(0xFF8B5CF6),
          unselectedItemColor: ColorConstant.turquoise,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: context.general.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: context.general.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: Size.fromWidth(context.sized.width),
            elevation: DoubleConstant.four,
            padding: context.padding.normal,
            shape: RoundedRectangleBorder(
              borderRadius: context.border.highBorderRadius,
              side: const BorderSide(
                color: ColorConstant.transparent,
              ),
            ),
          ),
        ),
      );
}
