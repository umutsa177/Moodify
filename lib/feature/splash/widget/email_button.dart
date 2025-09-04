part of '../view/splash_view.dart';

final class _EmailButton extends StatelessWidget {
  const _EmailButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.sized.dynamicWidth(.85),
      child: ElevatedButton(
        onPressed: () {
          context.route.navigation.pushNamed(
            AppRouter.signUp,
          );
        },
        style: ElevatedButton.styleFrom(
          side: const BorderSide(
            color: ColorConstant.transparent,
          ),
          backgroundColor: ColorConstant.emailBackground,
          elevation: DoubleConstant.four,
          padding: context.padding.normal,
          shape: RoundedRectangleBorder(
            borderRadius: context.border.highBorderRadius,
          ),
        ),
        child: Text(
          StringConstant.emailSignup,
          style: context.general.textTheme.titleMedium?.copyWith(
            color: ColorConstant.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
