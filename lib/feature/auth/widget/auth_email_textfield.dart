import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/extension/project_decoration.dart';

final class AuthEmailTextField extends StatelessWidget {
  const AuthEmailTextField({
    required this.emailController,
    required this.validator,
    required this.hintText,
    super.key,
  });

  final TextEditingController emailController;
  final FormFieldValidator<String> validator;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
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
