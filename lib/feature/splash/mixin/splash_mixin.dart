import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/providers/auth_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/enum/auth_status.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin SplashMixin<T extends StatefulWidget> on State<T> {
  final _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    initDeepLinks();
    checkAuth(context);
  }

  // Authentication check
  void checkAuth(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        context.route.navigation.pushReplacementNamed(AppRouter.moodSelection);
      }

      // Hata mesajını göster
      if (authProvider.status == AuthStatus.error &&
          authProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: ColorConstant.error,
            action: SnackBarAction(
              label: 'OK',
              textColor: ColorConstant.primary,
              onPressed: authProvider.clearError,
            ),
          ),
        );
      }
    });
  }

  // Initialize deep link
  Future<void> initDeepLinks() async {
    // Listen to the deep connections that come when the application is open
    _appLinks.uriLinkStream.listen((Uri? uri) async {
      if (uri != null &&
          uri.toString().startsWith(StringConstant.supabaseRedirectUri)) {
        // Supabase redirect URI'si geldi
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final supabase = Supabase.instance.client;

        await Future.delayed(const Duration(seconds: 1), () {});

        // Check supabase session
        final session = supabase.auth.currentSession;
        if (session != null && mounted) {
          authProvider.clearError();
          await context.route.navigation.pushReplacementNamed(
            AppRouter.moodSelection,
          );
        } else {
          // there is a session but email unapproved
          // go to email verification page
          if (session != null && mounted) {
            await context.route.navigation.pushReplacementNamed(
              AppRouter.emailVerification,
              arguments: session.user.email,
            );
          }
        }
      }
    });

    // Check the deep connection that comes with the application off
    final uri = await _appLinks.getInitialLink();
    if (uri != null &&
        uri.toString().startsWith(StringConstant.supabaseRedirectUri)) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final supabase = Supabase.instance.client;

      await Future.delayed(const Duration(seconds: 1), () {});

      // Check supabase session
      final session = supabase.auth.currentSession;
      if (session != null && mounted) {
        authProvider.clearError();
        await context.route.navigation.pushReplacementNamed(
          AppRouter.moodSelection,
        );
      }
    }
  }
}
