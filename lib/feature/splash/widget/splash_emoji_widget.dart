part of '../view/splash_view.dart';

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
