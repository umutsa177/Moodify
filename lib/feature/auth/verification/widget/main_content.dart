part of '../view/email_verification_view.dart';

final class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: context.sized.lowValue,
      children: [
        Text(
          StringConstant.checkMail,
          style: context.general.textTheme.headlineMedium?.copyWith(
            color: ColorConstant.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        // Email text
        Column(
          children: [
            Text(
              StringConstant.sendLink,
              style: context.general.primaryTextTheme.bodyLarge?.copyWith(
                color: ColorConstant.onPrimary,
              ),
            ),
            Text(
              ModalRoute.of(context)!.settings.arguments.toString(),
              style: context.general.primaryTextTheme.titleMedium,
            ),
          ],
        ),
        Text(
          StringConstant.checkInboxAndContinue,
          textAlign: TextAlign.center,
          maxLines: (DoubleConstant.four / 2).toInt(),
          style: context.general.primaryTextTheme.bodyLarge,
        ),
      ],
    );
  }
}
