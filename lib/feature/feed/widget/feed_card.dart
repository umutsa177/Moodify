part of '../view/feed_view.dart';

@immutable
final class _FeedCard extends StatelessWidget {
  const _FeedCard({
    required this.videoId,
    required this.thumbnail,
    required this.title,
    required this.duration,
    required this.videoUrl,
    required this.onTap,
  });

  final String videoId;
  final String thumbnail;
  final String title;
  final String duration;
  final String videoUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: context.padding.horizontalLow + context.padding.onlyBottomLow,
        height: context.sized.dynamicHeight(.25),
        decoration: BoxDecoration(
          borderRadius: context.border.highBorderRadius,
          image: DecorationImage(
            image: CachedNetworkImageProvider(thumbnail),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: context.border.highBorderRadius,
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                ColorConstant.onSecondary,
                ColorConstant.transparent,
              ],
            ),
          ),
          padding: context.padding.normal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Save Button
              Align(
                alignment: Alignment.topRight,
                child: _SaveButton(
                  videoId: videoId,
                  thumbnail: thumbnail,
                  title: title,
                  duration: duration,
                  videoUrl: videoUrl,
                ),
              ),
              // Title and actions section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _feedCardTitle(context),
                  _feedCardAction(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _feedCardAction(BuildContext context) {
    return Row(
      spacing: DoubleConstant.eight,
      children: [
        Chip(
          label: Text(duration),
          backgroundColor: ColorConstant.onPrimary,
          labelStyle: context.general.textTheme.bodySmall?.copyWith(
            color: ColorConstant.secondary,
          ),
        ),
        Container(
          padding: context.padding.low,
          decoration: BoxDecoration(
            color: ColorConstant.onPrimary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.play_arrow,
            color: ColorConstant.secondary,
            size: DoubleConstant.twentyFour,
          ),
        ),
      ],
    );
  }

  Expanded _feedCardTitle(BuildContext context) {
    return Expanded(
      child: Text(
        title,
        maxLines: DoubleConstant.two.toInt(),
        overflow: TextOverflow.ellipsis,
        style: context.general.textTheme.titleMedium?.copyWith(
          color: ColorConstant.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
