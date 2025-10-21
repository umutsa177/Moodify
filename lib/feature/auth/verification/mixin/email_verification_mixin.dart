import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/feature/auth/verification/view/email_verification_view.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/extension/toast_extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin EmailVerificationMixin on State<EmailVerificationView> {
  // User email from arguments
  String? userEmail;

  // Loading states
  bool isResendLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get email from arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      userEmail = args;
    }
  }

  // Resend email verification
  Future<void> resendEmailVerification() async {
    if (userEmail == null || userEmail!.isEmpty) {
      if (mounted) {
        await ToastExtension.showToast(
          message: 'Email address not found. Please go back and try again.',
          backgroundColor: ColorConstant.error,
          context: context,
        );
      }
      return;
    }

    setState(() {
      isResendLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;

      // Resend email verification
      await supabase.auth.resend(
        type: OtpType.signup,
        email: userEmail,
        emailRedirectTo: 'com.umutsayar.moodify://oauth2redirect',
      );

      if (mounted) {
        await ToastExtension.showToast(
          message: 'Verification email sent successfully!',
          backgroundColor: ColorConstant.success,
          context: context,
        );
      }
    } on AuthException catch (error) {
      if (mounted) {
        await ToastExtension.showToast(
          message: error.message,
          backgroundColor: ColorConstant.error,
          context: context,
        );
      }
    } on Exception catch (_) {
      if (mounted) {
        await ToastExtension.showToast(
          message: 'Failed to send verification email. Please try again.',
          backgroundColor: ColorConstant.error,
          context: context,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isResendLoading = false;
        });
      }
    }
  }

  // Navigate back to sign in
  void navigateBackToSignIn() => context.route.pop();
}
