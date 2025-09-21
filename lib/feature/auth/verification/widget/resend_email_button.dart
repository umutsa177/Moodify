part of '../view/email_verification_view.dart';

final class _ResendEmailButton extends StatelessWidget {
  const _ResendEmailButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: context.general.primaryTextTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w400,
          ),
          children: [
            const TextSpan(
              text: StringConstant.resendEmailFirstText,
            ),
            TextSpan(
              text: StringConstant.resendEmailSecondText,
              style: context.general.primaryTextTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
