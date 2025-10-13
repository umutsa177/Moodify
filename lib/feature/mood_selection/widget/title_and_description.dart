part of '../view/mood_selection_view.dart';

@immutable
final class _TitleAndDescription extends StatelessWidget {
  const _TitleAndDescription();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Title
        Text(
          StringConstant.moodSelectionTitle,
          textAlign: TextAlign.center,
          style: context.general.textTheme.headlineLarge?.copyWith(
            color: ColorConstant.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: DoubleConstant.termsLetterSpacing,
          ),
        ),
        context.sized.emptySizedHeightBoxLow,
        // Description Texts
        Text(
          StringConstant.moodSelectionFirstDescriptionText,
          style: context.general.textTheme.bodyLarge?.copyWith(
            color: ColorConstant.primaryLight,
          ),
        ),
        Text(
          StringConstant.moodSelectionSecondDescriptionText,
          style: context.general.textTheme.bodyLarge?.copyWith(
            color: ColorConstant.primaryLight,
          ),
        ),
      ],
    );
  }
}
