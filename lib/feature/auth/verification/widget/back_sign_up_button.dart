part of '../view/email_verification_view.dart';

final class _BackSignUpButton extends StatelessWidget {
  const _BackSignUpButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.onlyTopNormal,
      child: ElevatedButton(
        onPressed: onPressed,
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
            StringConstant.backToSignUp,
            style: context.general.textTheme.titleMedium?.copyWith(
              color: ColorConstant.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
