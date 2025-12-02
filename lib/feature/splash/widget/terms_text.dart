part of '../view/splash_view.dart';

final class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.onlyBottomLow,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: context.general.textTheme.labelSmall?.copyWith(
            color: ColorConstant.primaryLight,
            letterSpacing: DoubleConstant.termsLetterSpacing,
          ),
          children: [
            TextSpan(text: StringConstant.firstTermsText),
            TextSpan(
              text: StringConstant.secondTermsText,
              style: context.general.textTheme.labelSmall?.copyWith(
                color: ColorConstant.primaryLight,
                decoration: TextDecoration.underline,
                decorationColor: ColorConstant.primary,
                letterSpacing: DoubleConstant.termsLetterSpacing,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
