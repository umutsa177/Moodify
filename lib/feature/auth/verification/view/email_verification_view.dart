import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/feature/auth/verification/mixin/email_verification_mixin.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';

part '../widget/main_content.dart';
part '../widget/back_sign_up_button.dart';
part '../widget/resend_email_button.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView>
    with EmailVerificationMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ColorConstant.authBackgroundColors,
          ),
        ),
        child: Padding(
          padding: context.padding.horizontalNormal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: context.sized.normalValue,
            children: [
              // Email Logo
              _emailLogo(context),

              // Main Content
              const _MainContent(),
              _BackSignUpButton(
                onPressed: navigateBackToSignIn,
              ),
              _ResendEmailButton(onPressed: resendEmailVerification),
            ],
          ),
        ),
      ),
    );
  }

  Container _emailLogo(BuildContext context) {
    return Container(
      padding: context.padding.normal,
      margin: context.padding.onlyBottomLow,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorConstant.emailBackground,
        border: Border.all(color: ColorConstant.transparent),
      ),
      child: Icon(
        Icons.email_outlined,
        color: ColorConstant.primary,
        size: context.sized.dynamicHeight(.085),
      ),
    );
  }
}
