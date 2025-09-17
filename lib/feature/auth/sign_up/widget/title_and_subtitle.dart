part of '../view/sign_up_view.dart';

final class _TitleAndSubtitle extends StatelessWidget {
  const _TitleAndSubtitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.onlyBottomMedium,
      child: Column(
        children: [
          Text(
            StringConstant.appName,
            style: context.general.textTheme.displaySmall?.copyWith(
              color: ColorConstant.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            StringConstant.registerTitle,
            style: context.general.textTheme.bodyLarge?.copyWith(
              color: ColorConstant.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
