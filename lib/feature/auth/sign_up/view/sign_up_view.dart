import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/feature/auth/sign_up/mixin/sign_up_mixin.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/extension/project_decoration.dart';

class SignUpView extends StatelessWidget with SignUpMixin {
  const SignUpView({super.key});

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
                    // Title and Subtitle
                    Padding(
                      padding: context.padding.onlyBottomMedium,
                      child: Column(
                        children: [
                          Text(
                            StringConstant.appName,
                            style: context.general.textTheme.displaySmall
                                ?.copyWith(
                                  color: ColorConstant.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            StringConstant.registerTitle,
                            style: context.general.textTheme.bodyLarge
                                ?.copyWith(
                                  color: ColorConstant.onPrimary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    // Form
                    Form(
                      child: Column(
                        spacing: context.sized.normalValue,
                        children: [
                          // Email
                          TextFormField(
                            autofillHints: const [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: context.general.textTheme.bodyMedium
                                ?.copyWith(
                                  color: ColorConstant.primary,
                                ),
                            validator: (value) {
                              return null;
                            },
                            cursorColor: ColorConstant.secondary,

                            decoration: InputDecoration(
                              hintText: StringConstant.email,
                              hintStyle: context.general.textTheme.bodyMedium
                                  ?.copyWith(
                                    color: ColorConstant.primary,
                                  ),
                              filled: true,
                              fillColor: ColorConstant.primaryLight,
                              contentPadding: context.padding.normal,
                              enabledBorder: ProjectDecoration.authBorder(
                                context,
                              ),
                              focusedBorder: ProjectDecoration.authBorder(
                                context,
                              ),
                            ),
                          ),
                          // Password
                          TextFormField(
                            autofillHints: const [AutofillHints.password],
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                            style: context.general.textTheme.bodyMedium
                                ?.copyWith(
                                  color: ColorConstant.primary,
                                ),
                            validator: (value) {
                              return null;
                            },
                            cursorColor: ColorConstant.secondary,

                            decoration: InputDecoration(
                              hintText: StringConstant.password,
                              hintStyle: context.general.textTheme.bodyMedium
                                  ?.copyWith(
                                    color: ColorConstant.primary,
                                  ),
                              filled: true,
                              fillColor: ColorConstant.primaryLight,
                              contentPadding: context.padding.normal,
                              enabledBorder: ProjectDecoration.authBorder(
                                context,
                              ),
                              focusedBorder: ProjectDecoration.authBorder(
                                context,
                              ),
                            ),
                          ),
                          // Confirm Password
                          TextFormField(
                            autofillHints: const [AutofillHints.password],
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            style: context.general.textTheme.bodyMedium
                                ?.copyWith(
                                  color: ColorConstant.primary,
                                ),
                            validator: (value) {
                              return null;
                            },
                            cursorColor: ColorConstant.secondary,

                            decoration: InputDecoration(
                              hintText: StringConstant.confirmPassword,
                              hintStyle: context.general.textTheme.bodyMedium
                                  ?.copyWith(
                                    color: ColorConstant.primary,
                                  ),
                              filled: true,
                              fillColor: ColorConstant.primaryLight,
                              contentPadding: context.padding.normal,
                              enabledBorder: ProjectDecoration.authBorder(
                                context,
                              ),
                              focusedBorder: ProjectDecoration.authBorder(
                                context,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Sign Up Button
                    Padding(
                      padding:
                          context.padding.verticalNormal +
                          context.padding.onlyTopNormal,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.primary,
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: ColorConstant.authBackgroundColors,
                          ).createShader(bounds),
                          child: Text(
                            StringConstant.signUp,
                            style: context.general.textTheme.titleMedium
                                ?.copyWith(
                                  color: ColorConstant.primary,
                                ),
                          ),
                        ),
                      ),
                    ),

                    // Already have an account text
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: context.padding.onlyTopMedium,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: context.general.textTheme.labelSmall
                                ?.copyWith(
                                  color: ColorConstant.onPrimary,
                                ),
                            children: [
                              const TextSpan(
                                text: StringConstant.alreadyHaveAccount,
                              ),
                              TextSpan(
                                text: StringConstant.login,
                                style: context.general.textTheme.labelSmall
                                    ?.copyWith(
                                      color: ColorConstant.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
