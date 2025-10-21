import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/auth/sign_up/view/sign_up_view.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/extension/toast_extension.dart';
import 'package:provider/provider.dart';

mixin SignUpMixin on State<SignUpView> {
  // Controllers
  late final GlobalKey<FormState> formKey;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  // Loading state
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  // Email signup method
  Future<void> emailSignUp() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.signUpWithEmail(
        emailController.text.trim(),
        passwordController.text,
      );

      // Redirect to email verification page
      if (mounted) {
        unawaited(
          context.route.navigation.pushNamed(
            AppRouter.emailVerification,
            arguments: emailController.text.trim(),
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        await ToastExtension.showToast(
          message: e.toString(),
          backgroundColor: ColorConstant.error,
          context: context,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password repetition area cannot be left empty';
    }

    if (value != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }
}
