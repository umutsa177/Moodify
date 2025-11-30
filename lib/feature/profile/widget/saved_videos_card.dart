part of '../view/profile_view.dart';

@immutable
final class _SavedVideoCard extends StatelessWidget {
  const _SavedVideoCard({required this.video});
  final SavedVideo video;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorConstant.onPrimaryLight,
        borderRadius: context.border.normalBorderRadius,
      ),
      child: ListTile(
        contentPadding: context.padding.low,
        leading: ClipRRect(
          borderRadius: context.border.lowBorderRadius,
          child: Image.network(
            video.thumbnail,
            width: context.sized.highValue + context.sized.normalValue,
            height: context.sized.highValue,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: context.sized.highValue + context.sized.normalValue,
              height: context.sized.highValue,
              color: ColorConstant.emojiColor,
              child: Icon(
                Icons.video_library_rounded,
                color: ColorConstant.videoErrorColor,
              ),
            ),
          ),
        ),
        title: Text(
          video.title,
          maxLines: DoubleConstant.two.toInt(),
          overflow: TextOverflow.ellipsis,
          style: context.general.textTheme.bodyMedium?.copyWith(
            color: ColorConstant.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: context.padding.onlyTopLow,
          child: Text(
            video.duration,
            style: context.general.textTheme.bodySmall?.copyWith(
              color: ColorConstant.videoDurationColor,
            ),
          ),
        ),
        trailing: IconButton(
          tooltip: StringConstant.remove,
          icon: const Icon(Icons.close_rounded),
          color: ColorConstant.videoCloseColor,
          onPressed: () async {
            // Remove video
            await context.read<SavedVideosProvider>().removeVideo(
              video.videoId,
            );
          },
        ),
        onTap: () {
          unawaited(showVideoPlayer(context, video.videoUrl, video.title));
        },
      ),
    );
  }
}
