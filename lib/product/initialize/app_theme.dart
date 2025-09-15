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

        // cardTheme: const CardThemeData(
        //   margin: EdgeInsets.zero,
        //   color: ColorConstant.primary,
        //   elevation: 2,
        //   shape: CircleBorder(),
        // ),
        scaffoldBackgroundColor: ColorConstant.primary,
        // appBarTheme: const AppBarTheme(
        //   backgroundColor: ColorConstant.transparent,
        //   surfaceTintColor: ColorConstant.primary,
        //   elevation: DoubleConstant.zero,
        //   actionsIconTheme: IconThemeData(
        //     color: ColorConstant.grey,
        //   ),
        // ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: ColorConstant.navBarBackground,
          elevation: DoubleConstant.zero,
          selectedItemColor: ColorConstant.secondary,
          unselectedItemColor: ColorConstant.turquoise,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: context.general.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: context.general.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),

        // outlinedButtonTheme: OutlinedButtonThemeData(
        //   style: OutlinedButton.styleFrom(
        //     backgroundColor: ColorConstant.primary,
        //     iconColor: ColorConstant.primary,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: context.border.highBorderRadius,
        //       side: BorderSide(color: ColorConstant.blue.withValues(alpha: .3)),
        //     ),
        //   ),
        // ),
        // filledButtonTheme: FilledButtonThemeData(
        //   style: FilledButton.styleFrom(
        //     backgroundColor: ColorConstant.blue,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: context.border.highBorderRadius,
        //     ),
        //   ),
        // ),
        // bottomSheetTheme: BottomSheetThemeData(
        //   backgroundColor: ColorConstant.primary,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //       topRight: context.border.normalBorderRadius.topRight,
        //       topLeft: context.border.normalBorderRadius.topLeft,
        //     ),
        //   ),
        // ),
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
