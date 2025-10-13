part of '../view/splash_view.dart';

final class _GoogleLoginButton extends StatelessWidget {
  const _GoogleLoginButton({
    required this.authProvider,
  });

  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.sized.dynamicWidth(.85),
      child: ElevatedButton.icon(
        onPressed: authProvider.isGoogleLoading
            ? null
            : authProvider.signInWithGoogle,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.primary,
          foregroundColor: ColorConstant.secondary,
        ),
        icon: authProvider.isGoogleLoading
            ? const SizedBox(
                width: DoubleConstant.twentyFour,
                height: DoubleConstant.twentyFour,
                child: CircularProgressIndicator(
                  color: ColorConstant.secondary,
                  strokeWidth: DoubleConstant.two,
                ),
              )
            : const Icon(
                Icons.g_mobiledata,
                size: DoubleConstant.twentyFour,
                color: ColorConstant.secondary,
              ),
        label: Text(
          authProvider.isGoogleLoading
              ? StringConstant.loading
              : StringConstant.signInGoogle,
          style: context.general.textTheme.titleMedium,
        ),
      ),
    );
  }
}
