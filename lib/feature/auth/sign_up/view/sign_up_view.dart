import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/auth/sign_up/mixin/sign_up_mixin.dart';
import 'package:moodify/feature/auth/widget/auth_email_textfield.dart';
import 'package:moodify/feature/auth/widget/auth_password_textfield.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';

part '../widget/title_and_subtitle.dart';
part '../widget/login_redirect_button.dart';
part '../widget/sign_up_button.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with SignUpMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ColorConstant.authBackgroundColors,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: context.general.keyboardPadding,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: context.sized.height,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: context.padding.horizontalNormal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _TitleAndSubtitle(),
                    Form(
                      key: formKey,
                      child: Column(
                        spacing: context.sized.normalValue,
                        children: [
                          // Email
                          AuthEmailTextField(
                            emailController: emailController,
                            validator: emailValidator,
                            hintText: StringConstant.email,
                          ),
                          // Password
                          AuthPasswordTextField(
                            passwordController: passwordController,
                            textInputAction: TextInputAction.next,
                            validator: passwordValidator,
                            hintText: StringConstant.password,
                          ),
                          // Confirm Password
                          AuthPasswordTextField(
                            passwordController: confirmPasswordController,
                            textInputAction: TextInputAction.done,
                            validator: confirmPasswordValidator,
                            hintText: StringConstant.confirmPassword,
                          ),
                        ],
                      ),
                    ),
                    _SignupButton(
                      onPressed: emailSignUp,
                      isLoading: isLoading,
                    ),
                    const _LoginRedirectButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
