part of '../view/sign_in_view.dart';

final class _SignInButton extends StatelessWidget {
  const _SignInButton({
    required this.onPressed,
    required this.isLoading,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.verticalNormal,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.primary,
        ),
        child: isLoading
            ? SizedBox(
                height: context.sized.normalValue,
                width: context.sized.normalValue,
                child: const CircularProgressIndicator(
                  strokeWidth: DoubleConstant.two,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ColorConstant.secondary,
                  ),
                ),
              )
            : ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: ColorConstant.authBackgroundColors,
                ).createShader(bounds),
                child: Text(
                  StringConstant.login,
                  style: context.general.textTheme.titleMedium?.copyWith(
                    color: ColorConstant.primary,
                  ),
                ),
              ),
      ),
    );
  }
}
