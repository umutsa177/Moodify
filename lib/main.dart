import 'package:flutter/material.dart';
import 'package:moodify/feature/splash/view/splash_view.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/initialize/app_start.dart';
import 'package:moodify/product/initialize/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStart.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringConstant.appName,
      theme: AppTheme(context).theme,
      home: const SplashView(),
    );
  }
}
