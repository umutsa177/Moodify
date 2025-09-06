import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/providers/auth_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/splash/mixin/splash_mixin.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:provider/provider.dart';

part '../widget/terms_text.dart';
part '../widget/email_button.dart';
part '../widget/splash_emoji_widget.dart';
part '../widget/title_and_subtitle.dart';
part '../widget/seperate_text.dart';
part '../widget/facebook_login_button.dart';
part '../widget/google_login_button.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SplashMixin {
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = context.sized.height < 700;

    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Stack(
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
                topValue: isSmallScreen
                    ? context.sized.dynamicHeight(.37)
                    : context.sized.dynamicHeight(.325),
                rightValue: isSmallScreen
                    ? context.sized.dynamicHeight(.075)
                    : context.sized.dynamicHeight(.05),
                leftValue: null,
                bottomValue: null,
                emoji: '😌',
                containerSize: context.sized.dynamicHeight(.07),
                emojiSize: context.sized.dynamicHeight(.035),
              ),

              // Surprised Emoji
              _SplashEmojiWidget(
                bottomValue: isSmallScreen
                    ? context.sized.dynamicHeight(.1)
                    : context.sized.dynamicHeight(.19),
                leftValue: isSmallScreen
                    ? context.sized.dynamicHeight(.065)
                    : context.sized.dynamicHeight(.04),
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
                    const _TitleAndSubtitle(),
                    context.sized.emptySizedHeightBoxNormal,
                    _GoogleLoginButton(authProvider: authProvider),
                    context.sized.emptySizedHeightBoxLow3x,
                    _FacebookLoginButton(authProvider: authProvider),
                    const _SeperateText(),
                    const _EmailButton(),
                    const Spacer(),
                    const _TermsText(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
