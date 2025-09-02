import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          const SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: ColorConstant.backgroundColors,
                ),
              ),
            ),
          ),

          // Happy Emoji
          _SplashEmojiWidget(
            topValue: context.sized.dynamicHeight(.085),
            leftValue: context.sized.dynamicHeight(.035),
            rightValue: null,
            bottomValue: null,
            emoji: '😊',
            containerSize: context.sized.highValue,
            emojiSize: context.sized.dynamicHeight(.05),
          ),

          // Tired Emoji
          _SplashEmojiWidget(
            topValue: context.sized.dynamicHeight(.325),
            rightValue: context.sized.dynamicHeight(.05),
            leftValue: null,
            bottomValue: null,
            emoji: '😌',
            containerSize: context.sized.dynamicHeight(.07),
            emojiSize: context.sized.dynamicHeight(.035),
          ),

          // Surprised Emoji
          _SplashEmojiWidget(
            bottomValue: context.sized.dynamicHeight(.19),
            leftValue: context.sized.dynamicHeight(.04),
            rightValue: null,
            topValue: null,
            emoji: '🤩',
            containerSize: context.sized.dynamicHeight(.1),
            emojiSize: context.sized.dynamicHeight(.05),
          ),

          // Laughing Emoji
          _SplashEmojiWidget(
            bottomValue: context.sized.dynamicHeight(.08),
            rightValue: context.sized.dynamicHeight(.04),
            leftValue: null,
            topValue: null,
            emoji: '😂',
            containerSize: context.sized.dynamicHeight(.06),
            emojiSize: context.sized.dynamicHeight(.03),
          ),

          // Main Content
          Padding(
            padding: context.padding.horizontalNormal,
            child: Column(
              children: [
                context.sized.emptySizedHeightBoxHigh,

                // Title
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

                context.sized.emptySizedHeightBoxNormal,

                // Google signIn button
                SizedBox(
                  width: context.sized.dynamicWidth(.85),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.primary,
                      foregroundColor: ColorConstant.secondary,
                      elevation: DoubleConstant.four,
                      padding: context.padding.normal,
                      shape: RoundedRectangleBorder(
                        borderRadius: context.border.highBorderRadius,
                      ),
                    ),
                    icon: const Icon(
                      Icons.g_mobiledata,
                      size: DoubleConstant.twentyFour,
                      color: ColorConstant.secondary,
                    ),
                    label: Text(
                      StringConstant.signInGoogle,
                      style: context.general.textTheme.titleMedium,
                    ),
                  ),
                ),

                context.sized.emptySizedHeightBoxLow3x,

                // Facebook signIn button
                SizedBox(
                  width: context.sized.dynamicWidth(.85),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.facebookLoginBackground,
                      foregroundColor: ColorConstant.primary,
                      elevation: DoubleConstant.four,
                      padding: context.padding.normal,
                      shape: RoundedRectangleBorder(
                        borderRadius: context.border.highBorderRadius,
                      ),
                    ),
                    icon: const Icon(
                      Icons.facebook,
                      size: DoubleConstant.twentyFour,
                    ),
                    label: Text(
                      StringConstant.signInFacebook,
                      style: context.general.textTheme.titleMedium?.copyWith(
                        color: ColorConstant.primary,
                      ),
                    ),
                  ),
                ),

                // "or" text
                Padding(
                  padding: context.padding.verticalMedium,
                  child: Text(
                    StringConstant.seperateText,
                    style: context.general.textTheme.bodyLarge?.copyWith(
                      color: ColorConstant.primaryLight,
                    ),
                  ),
                ),

                // Email signUp button
                SizedBox(
                  width: context.sized.dynamicWidth(.85),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: ColorConstant.transparent),
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
                ),

                context.sized.emptySizedHeightBoxHigh,

                // Terms of Service
                Padding(
                  padding:
                      context.padding.onlyTopNormal +
                      context.padding.onlyTopHigh,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: context.general.textTheme.labelSmall?.copyWith(
                        color: ColorConstant.primaryLight,
                        letterSpacing: DoubleConstant.termsLetterSpacing,
                      ),
                      children: [
                        const TextSpan(text: StringConstant.firstTermsText),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _SplashEmojiWidget extends StatelessWidget {
  const _SplashEmojiWidget({
    required this.topValue,
    required this.bottomValue,
    required this.leftValue,
    required this.rightValue,
    required this.emoji,
    required this.containerSize,
    required this.emojiSize,
  });

  final double? topValue;
  final double? bottomValue;
  final double? leftValue;
  final double? rightValue;
  final String emoji;
  final double containerSize;
  final double emojiSize;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topValue,
      bottom: bottomValue,
      right: rightValue,
      left: leftValue,
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: const BoxDecoration(
          color: ColorConstant.emojiColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            emoji,
            style: TextStyle(fontSize: emojiSize),
          ),
        ),
      ),
    );
  }
}
