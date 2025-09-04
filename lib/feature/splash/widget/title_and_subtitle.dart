part of '../view/splash_view.dart';

final class _TitleAndSubtitle extends StatelessWidget {
  const _TitleAndSubtitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: context.padding.onlyTopHigh,
          child: Text(
            StringConstant.splashTitle,
            textAlign: TextAlign.center,
            style: context.general.textTheme.displayMedium?.copyWith(
              color: ColorConstant.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        context.sized.emptySizedHeightBoxLow,

        // SubTitle
        Text(
          StringConstant.splashSubtitle,
          style: context.general.textTheme.bodyLarge?.copyWith(
            color: ColorConstant.primaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
