import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/extension/project_decoration.dart';

final class AuthPasswordTextField extends StatelessWidget {
  const AuthPasswordTextField({
    required this.passwordController,
    required this.textInputAction,
    required this.validator,
    required this.hintText,
    super.key,
  });

  final TextEditingController passwordController;
  final TextInputAction textInputAction;
  final FormFieldValidator<String> validator;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      autofillHints: const [AutofillHints.password],
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      obscureText: true,
      style: context.general.textTheme.bodyMedium?.copyWith(
        color: ColorConstant.primary,
      ),
      validator: validator,
      cursorColor: ColorConstant.secondary,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: context.general.textTheme.bodyMedium?.copyWith(
          color: ColorConstant.primary,
        ),
        filled: true,
        fillColor: ColorConstant.primaryLight,
        contentPadding: context.padding.normal,
        enabledBorder: ProjectDecoration.authBorder(context),
        focusedBorder: ProjectDecoration.authBorder(context),
      ),
    );
  }
}
