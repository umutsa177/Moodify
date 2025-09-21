import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/auth/sign_in/mixin/sign_in_mixin.dart';
import 'package:moodify/feature/auth/widget/auth_email_textfield.dart';
import 'package:moodify/feature/auth/widget/auth_password_textfield.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';

part '../widget/title_and_subtitle.dart';
part '../widget/sign_in_button.dart';
part '../widget/sign_in_redirect_button.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> with SignInMixin {
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
                            textInputAction: TextInputAction.done,
                            validator: passwordValidator,
                            hintText: StringConstant.password,
                          ),
                        ],
                      ),
                    ),
                    _forgotPasswordButton(context),
                    _SignInButton(
                      isLoading: isLoading,
                      onPressed: emailSignIn,
                    ),
                    const _SignInRedirectButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _forgotPasswordButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => context.route.navigation.pushNamed(
            AppRouter.resetPaswword,
          ),
          style: TextButton.styleFrom(
            padding: context.padding.horizontalLow,
            foregroundColor: ColorConstant.onPrimary,
          ),
          child: Text(
            StringConstant.forgotPassword,
            style: context.general.primaryTextTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}
