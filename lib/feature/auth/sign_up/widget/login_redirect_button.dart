part of '../view/sign_up_view.dart';

final class _LoginRedirectButton extends StatelessWidget {
  const _LoginRedirectButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.route.navigation.pushNamed(AppRouter.signIn),
      child: Padding(
        padding: context.padding.onlyTopMedium,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: context.general.textTheme.labelSmall?.copyWith(
              color: ColorConstant.onPrimary,
            ),
            children: [
              TextSpan(text: StringConstant.alreadyHaveAccount),
              TextSpan(
                text: StringConstant.login,
                style: context.general.textTheme.labelSmall?.copyWith(
                  color: ColorConstant.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
