part of '../view/feed_view.dart';

@immutable
final class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.videoId,
    required this.thumbnail,
    required this.title,
    required this.duration,
    required this.videoUrl,
  });

  final String videoId;
  final String thumbnail;
  final String title;
  final String duration;
  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedVideosProvider>(
      builder: (context, provider, _) {
        final isSaved = provider.isVideoSaved(videoId);

        return GestureDetector(
          onTap: () async {
            if (isSaved) {
              await provider.removeVideo(videoId);
              if (context.mounted) {
                await ToastExtension.showToast(
                  message: StringConstant.removeVideoSuccess,
                  backgroundColor: ColorConstant.error,
                  context: context,
                );
              }
            }

            if (!isSaved) {
              final video = SavedVideo(
                videoId: videoId,
                title: title,
                thumbnail: thumbnail,
                duration: duration,
                videoUrl: videoUrl,
                savedAt: DateTime.now(),
              );
              await provider.saveVideo(video);
              if (context.mounted) {
                await ToastExtension.showToast(
                  message: StringConstant.videoSaved,
                  backgroundColor: ColorConstant.success,
                  context: context,
                );
              }
            }
          },
          child: Container(
            padding: context.padding.low,
            decoration: BoxDecoration(
              color: ColorConstant.onPrimary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: ColorConstant.secondary,
            ),
          ),
        );
      },
    );
  }
}
