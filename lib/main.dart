import 'package:flutter/material.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/initialize/app_start.dart';
import 'package:moodify/product/initialize/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.microtask(AppStart.init);

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringConstant.appName,
      theme: AppTheme(context).theme,
      onGenerateRoute: AppRouter.routes,
      initialRoute: AppRouter.moodSelection,
    );
  }
}
