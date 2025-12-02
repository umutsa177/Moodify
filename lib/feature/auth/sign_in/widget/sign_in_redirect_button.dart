part of '../view/sign_in_view.dart';

final class _SignInRedirectButton extends StatelessWidget {
  const _SignInRedirectButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.route.navigation.pushNamed(AppRouter.signUp),
      child: Padding(
        padding: context.padding.onlyTopMedium,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: context.general.textTheme.labelSmall?.copyWith(
              color: ColorConstant.onPrimary,
            ),
            children: [
              TextSpan(text: StringConstant.dontHaveAccount),
              TextSpan(
                text: StringConstant.signUp,
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
