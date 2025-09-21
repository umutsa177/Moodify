import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/providers/auth_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/auth/sign_in/view/sign_in_view.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/extension/toast_extension.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin SignInMixin on State<SignInView> {
  // Controllers
  late final GlobalKey<FormState> formKey;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  // Loading state
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  // Email sign in method
  Future<void> emailSignIn() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.signInWithEmail(
        emailController.text.trim(),
        passwordController.text,
      );

      // Redirect to mood selection view
      if (mounted) {
        unawaited(
          context.route.navigation.pushNamedAndRemoveUntil(
            AppRouter.moodSelection,
            (route) => false,
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ToastExtension.showToast(
          message: e.toString(),
          backgroundColor: ColorConstant.error,
          context: context,
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Validation methods
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'The email area cannot be left empty';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password area cannot be left empty';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }
}
