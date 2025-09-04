part of '../view/splash_view.dart';

final class _SeperateText extends StatelessWidget {
  const _SeperateText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.verticalMedium,
      child: Text(
        StringConstant.seperateText,
        style: context.general.textTheme.bodyLarge?.copyWith(
          color: ColorConstant.primaryLight,
        ),
      ),
    );
  }
}
