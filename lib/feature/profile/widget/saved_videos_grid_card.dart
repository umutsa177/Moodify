part of '../view/profile_view.dart';

@immutable
final class _SavedVideoGridCard extends StatelessWidget {
  const _SavedVideoGridCard({required this.video});
  final SavedVideo video;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        unawaited(showVideoPlayer(context, video.videoUrl, video.title));
      },
      borderRadius: context.border.normalBorderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ColorConstant.onPrimaryLight,
          borderRadius: context.border.normalBorderRadius,
        ),
        child: Stack(
          children: [
            _videoImage(context),
            _deleteButton(context),
            _videoInfosText(context),
          ],
        ),
      ),
    );
  }

  Positioned _videoInfosText(BuildContext context) {
    return Positioned(
      bottom: DoubleConstant.zero,
      left: DoubleConstant.zero,
      right: DoubleConstant.zero,
      child: Container(
        padding: context.padding.low + context.padding.onlyLeftLow,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorConstant.transparent,
              ColorConstant.onSecondary,
            ],
          ),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(context.sized.normalValue),
          ),
        ),
        child: Column(
          spacing: context.sized.lowValue,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Video title
            Text(
              video.title,
              maxLines: DoubleConstant.two.toInt(),
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.bodyMedium?.copyWith(
                color: ColorConstant.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Video duration
            Text(
              video.duration,
              style: context.general.textTheme.bodySmall?.copyWith(
                color: ColorConstant.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _deleteButton(BuildContext context) {
    return Positioned(
      top: DoubleConstant.eight,
      right: DoubleConstant.eight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ColorConstant.tertiary,
          borderRadius: context.border.lowBorderRadius,
        ),
        child: IconButton(
          tooltip: StringConstant.remove,
          icon: const Icon(Icons.close_rounded),
          color: ColorConstant.primary,
          iconSize: context.sized.normalValue + context.sized.lowValue,
          padding: context.padding.low,
          onPressed: () async {
            await context.read<SavedVideosProvider>().removeVideo(
              video.videoId,
            );
          },
        ),
      ),
    );
  }

  ClipRRect _videoImage(BuildContext context) {
    return ClipRRect(
      borderRadius: context.border.normalBorderRadius,
      child: Image.network(
        video.thumbnail,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => ColoredBox(
          color: ColorConstant.emojiColor,
          child: Center(
            child: Icon(
              Icons.video_library_rounded,
              color: ColorConstant.videoErrorColor,
              size: context.sized.mediumValue + context.sized.normalValue,
            ),
          ),
        ),
      ),
    );
  }
}
