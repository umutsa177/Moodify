part of '../view/sign_up_view.dart';

final class _SignupButton extends StatelessWidget {
  const _SignupButton({
    required this.onPressed,
    required this.isLoading,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.verticalNormal + context.padding.onlyTopNormal,
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
                  strokeWidth: DoubleConstant.strokeWidth,
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
                  StringConstant.signUp,
                  style: context.general.textTheme.titleMedium?.copyWith(
                    color: ColorConstant.primary,
                  ),
                ),
              ),
      ),
    );
  }
}
