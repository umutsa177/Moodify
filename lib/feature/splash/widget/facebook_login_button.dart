part of '../view/splash_view.dart';

final class _FacebookLoginButton extends StatelessWidget {
  const _FacebookLoginButton({
    required this.authProvider,
  });

  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.sized.dynamicWidth(.85),
      child: ElevatedButton.icon(
        onPressed: authProvider.isFacebookLoading
            ? null
            : authProvider.signInWithFacebook,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.facebookLoginBackground,
          foregroundColor: ColorConstant.primary,
        ),
        icon: authProvider.isFacebookLoading
            ? const SizedBox(
                width: DoubleConstant.twentyFour,
                height: DoubleConstant.twentyFour,
                child: CircularProgressIndicator(
                  color: ColorConstant.primary,
                  strokeWidth: DoubleConstant.strokeWidth,
                ),
              )
            : const Icon(
                Icons.facebook,
                size: DoubleConstant.twentyFour,
              ),
        label: Text(
          authProvider.isFacebookLoading
              ? StringConstant.loading
              : StringConstant.signInFacebook,
          style: context.general.textTheme.titleMedium?.copyWith(
            color: ColorConstant.primary,
          ),
        ),
      ),
    );
  }
}
