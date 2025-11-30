part of '../view/profile_view.dart';

@immutable
final class _SearchedVideos extends StatelessWidget {
  const _SearchedVideos({
    required this.isLoading,
    required this.videos,
    required this.searchQuery,
    required this.viewType,
  });

  final bool isLoading;
  final List<SavedVideo> videos;
  final String searchQuery;
  final VideoViewType viewType;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isLoading
          ? LoadingExtension.loadingBar(context)
          : videos.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  searchQuery.isEmpty
                      ? Icons.bookmark_border_rounded
                      : Icons.search_off_rounded,
                  size: context.sized.highValue,
                  color: ColorConstant.videoListSectionColor,
                ),
                context.sized.emptySizedHeightBoxLow,
                Text(
                  searchQuery.isEmpty
                      ? StringConstant.savedVideosEmpty
                      : '${StringConstant.savedVideoSearchEmpty} "$searchQuery"',
                  textAlign: TextAlign.center,
                  style: context.general.textTheme.bodyLarge?.copyWith(
                    color: ColorConstant.videoErrorColor,
                  ),
                ),
              ],
            )
          : viewType == VideoViewType.list
          ? ListView.separated(
              physics: const FixedExtentScrollPhysics(),
              padding:
                  context.padding.horizontalNormal +
                  context.padding.verticalLow,
              itemCount: videos.length,
              separatorBuilder: (_, _) => context.sized.emptySizedHeightBoxLow,
              itemBuilder: (_, index) {
                final video = videos[index];
                return _SavedVideoCard(video: video);
              },
            )
          : GridView.builder(
              physics: const FixedExtentScrollPhysics(),
              padding:
                  context.padding.horizontalNormal +
                  context.padding.verticalLow,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (DoubleConstant.two / 2).toInt(),
                childAspectRatio: DoubleConstant.aspectRatio,
                crossAxisSpacing: DoubleConstant.twelve,
                mainAxisSpacing: DoubleConstant.twelve,
              ),
              itemCount: videos.length,
              itemBuilder: (_, index) {
                final video = videos[index];
                return _SavedVideoGridCard(video: video);
              },
            ),
    );
  }
}
