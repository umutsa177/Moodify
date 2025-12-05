part of '../view/profile_view.dart';

@immutable
final class SavedVideos extends StatefulWidget {
  const SavedVideos({super.key});

  @override
  State<SavedVideos> createState() => _SavedVideosState();
}

class _SavedVideosState extends State<SavedVideos> with SavedVideosMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstant.emojiColor,
        borderRadius: context.border.normalBorderRadius,
      ),
      margin: context.padding.horizontalLow,
      padding: context.padding.onlyBottomHigh,
      child: Column(
        children: [
          Padding(
            padding: context.padding.normal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _savedVideosText(context),
                  ),
                ),
                _videosViewSelectionWidget(context),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: context.padding.horizontalNormal,
            child: _searchVideosWidget(),
          ),
          context.sized.emptySizedHeightBoxLow,
          // Videos from searched
          _SearchedVideos(
            isLoading: isLoading,
            videos: videos,
            searchQuery: searchQuery,
            viewType: viewType,
          ),
        ],
      ),
    );
  }

  SearchAnchor _searchVideosWidget() {
    return SearchAnchor(
      searchController: searchController,
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          padding: WidgetStateProperty.all(context.padding.low),
          backgroundColor: WidgetStateProperty.all(
            ColorConstant.onPrimaryLight,
          ),
          elevation: WidgetStateProperty.all(DoubleConstant.zero),
          hintText: StringConstant.searchSavedVideo,
          hintStyle: WidgetStateProperty.all(
            context.general.textTheme.bodyMedium?.copyWith(
              color: ColorConstant.videoErrorColor,
            ),
          ),
          textStyle: WidgetStateProperty.all(
            context.general.textTheme.bodyMedium?.copyWith(
              color: ColorConstant.primary,
            ),
          ),
          leading: Icon(
            Icons.search,
            color: ColorConstant.videoCloseColor,
          ),
          trailing: searchQuery.isNotEmpty
              ? [
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: ColorConstant.videoCloseColor,
                    ),
                    onPressed: () {
                      controller.clear();
                      setState(() {
                        searchQuery = '';
                      });
                    },
                  ),
                ]
              : null,
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: context.border.normalBorderRadius,
            ),
          ),
        );
      },
      suggestionsBuilder: (context, controller) {
        final suggestions = filterVideos(
          provider.savedVideos,
        ).take(5).toList();

        if (suggestions.isEmpty) {
          return [
            Padding(
              padding: context.padding.normal,
              child: Text(
                StringConstant.noVideos,
                style: context.general.textTheme.bodyMedium?.copyWith(
                  color: ColorConstant.videoErrorColor,
                ),
              ),
            ),
          ];
        }

        return suggestions.map((video) {
          return ListTile(
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
                  color: ColorConstant.onPrimaryLight,
                  child: Icon(
                    Icons.video_library_rounded,
                    color: ColorConstant.videoErrorColor,
                  ),
                ),
              ),
            ),
            title: Text(
              video.title,
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.bodyMedium?.copyWith(
                color: ColorConstant.primary,
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
            onTap: () {
              controller.closeView(video.title);
              setState(() {
                searchQuery = video.title;
              });
              unawaited(
                showVideoPlayer(context, video.videoUrl, video.title),
              );
            },
          );
        }).toList();
      },
    );
  }

  Row _videosViewSelectionWidget(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: viewType == VideoViewType.list
                ? ColorConstant.videoListSectionColor
                : ColorConstant.emojiColor,
            borderRadius: context.border.lowBorderRadius,
          ),
          child: IconButton(
            icon: const Icon(Icons.view_list_rounded),
            color: ColorConstant.primary,
            iconSize: context.sized.normalValue + context.sized.lowValue,
            padding: context.padding.low,
            onPressed: () {
              setState(() {
                viewType = VideoViewType.list;
              });
            },
          ),
        ),
        context.sized.emptySizedWidthBoxLow3x,
        DecoratedBox(
          decoration: BoxDecoration(
            color: viewType == VideoViewType.grid
                ? ColorConstant.videoListSectionColor
                : ColorConstant.emojiColor,
            borderRadius: context.border.lowBorderRadius,
          ),
          child: IconButton(
            icon: const Icon(Icons.grid_view_rounded),
            color: ColorConstant.primary,
            iconSize: context.sized.normalValue + context.sized.lowValue,
            padding: context.padding.low,
            onPressed: () {
              setState(() {
                viewType = VideoViewType.grid;
              });
            },
          ),
        ),
      ],
    );
  }

  Text _savedVideosText(BuildContext context) {
    return Text(
      StringConstant.savedVideos,
      style: context.general.textTheme.titleLarge?.copyWith(
        color: ColorConstant.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
