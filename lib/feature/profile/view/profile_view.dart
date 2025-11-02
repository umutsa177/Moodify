import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/model/saved_video.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/providers/saved_videos/saved_videos_provider.dart';
import 'package:moodify/feature/feed/view/feed_view.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/enum/video_view_type.dart';
import 'package:moodify/product/extension/loading_extension.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SavedVideosProvider(),
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: ColorConstant.feedBackgroundColors,
            ),
          ),
          child: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _ProfileHeader()),
              SliverFillRemaining(child: _SavedVideosList()),
            ],
          ),
        ),
      ),
    );
  }
}

// Profile Header
final class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Padding(
      padding: context.padding.normal + context.padding.onlyTopNormal,
      child: Column(
        spacing: context.sized.normalValue,
        children: [
          Row(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Title
                    Center(
                      child: Text(
                        StringConstant.myProfile,
                        style: context.general.textTheme.headlineSmall
                            ?.copyWith(
                              color: ColorConstant.primaryLight,
                            ),
                      ),
                    ),

                    // Language Selection Button
                    Positioned(
                      left: DoubleConstant.zero,
                      child: IconButton(
                        icon: const Icon(Icons.language_outlined),
                        iconSize: context.sized.mediumValue,
                        color: ColorConstant.onPrimary,
                        onPressed: () {},
                      ),
                    ),

                    // Logout Account Button
                    Positioned(
                      right: DoubleConstant.zero,
                      child: IconButton(
                        icon: const Icon(Icons.logout_outlined),
                        iconSize: context.sized.mediumValue,
                        color: ColorConstant.onPrimary,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Profile Picture
          CircleAvatar(
            radius: context.sized.dynamicHeight(.075),
            backgroundColor: ColorConstant.primary.withValues(alpha: .2),
            child: Icon(
              Icons.person_rounded,
              color: ColorConstant.primary,
              size: context.sized.highValue,
            ),
          ),
          // User Name
          Text(
            user?.email?.split('@').first ?? 'User',
            style: context.general.textTheme.headlineSmall?.copyWith(
              color: ColorConstant.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          // User Email
          Text(
            user?.email ?? 'No email',
            style: context.general.textTheme.bodyMedium?.copyWith(
              color: ColorConstant.onPrimary.withValues(alpha: .7),
            ),
          ),
        ],
      ),
    );
  }
}

// Saved Videos
@immutable
final class _SavedVideosList extends StatefulWidget {
  const _SavedVideosList();

  @override
  State<_SavedVideosList> createState() => _SavedVideosListState();
}

class _SavedVideosListState extends State<_SavedVideosList> {
  VideoViewType _viewType = VideoViewType.list;
  final SearchController _searchController = SearchController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SavedVideo> _filterVideos(List<SavedVideo> videos) {
    if (_searchQuery.isEmpty) return videos;

    return videos.where((video) {
      return video.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          video.duration.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SavedVideosProvider>();
    final videos = _filterVideos(provider.savedVideos);
    final isLoading = provider.isLoading;

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
                Text(
                  'Your Saved Videos',
                  style: context.general.textTheme.titleLarge?.copyWith(
                    color: ColorConstant.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: _viewType == VideoViewType.list
                            ? ColorConstant.primary.withValues(alpha: .3)
                            : ColorConstant.primary.withValues(alpha: .1),
                        borderRadius: context.border.lowBorderRadius,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.view_list_rounded),
                        color: ColorConstant.primary,
                        iconSize: context.sized.dynamicHeight(.03),
                        padding: context.padding.low,
                        onPressed: () {
                          setState(() {
                            _viewType = VideoViewType.list;
                          });
                        },
                      ),
                    ),
                    context.sized.emptySizedWidthBoxLow3x,
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: _viewType == VideoViewType.grid
                            ? ColorConstant.primary.withValues(alpha: .3)
                            : ColorConstant.primary.withValues(alpha: .1),
                        borderRadius: context.border.lowBorderRadius,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.grid_view_rounded),
                        color: ColorConstant.primary,
                        iconSize: context.sized.dynamicHeight(.03),
                        padding: context.padding.low,
                        onPressed: () {
                          setState(() {
                            _viewType = VideoViewType.grid;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: context.padding.horizontalNormal,
            child: SearchAnchor(
              searchController: _searchController,
              builder: (context, controller) {
                return SearchBar(
                  controller: controller,
                  padding: WidgetStateProperty.all(context.padding.low),
                  backgroundColor: WidgetStateProperty.all(
                    ColorConstant.primary.withValues(alpha: .2),
                  ),
                  elevation: WidgetStateProperty.all(DoubleConstant.zero),
                  hintText: 'Search saved videos',
                  hintStyle: WidgetStateProperty.all(
                    context.general.textTheme.bodyMedium?.copyWith(
                      color: ColorConstant.primary.withValues(alpha: .5),
                    ),
                  ),
                  textStyle: WidgetStateProperty.all(
                    context.general.textTheme.bodyMedium?.copyWith(
                      color: ColorConstant.primary,
                    ),
                  ),
                  leading: Icon(
                    Icons.search,
                    color: ColorConstant.primary.withValues(alpha: .7),
                  ),
                  trailing: _searchQuery.isNotEmpty
                      ? [
                          IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: ColorConstant.primary.withValues(
                                alpha: .7,
                              ),
                            ),
                            onPressed: () {
                              controller.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          ),
                        ]
                      : null,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
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
                final suggestions = _filterVideos(
                  provider.savedVideos,
                ).take(5).toList();

                if (suggestions.isEmpty) {
                  return [
                    Padding(
                      padding: context.padding.normal,
                      child: Text(
                        'No videos found',
                        style: context.general.textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.primary.withValues(alpha: .5),
                        ),
                      ),
                    ),
                  ];
                }

                return suggestions.map((video) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: context.border.lowBorderRadius,
                      child: Image.network(
                        video.thumbnail,
                        width: 60,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 60,
                          height: 40,
                          color: ColorConstant.primary.withValues(alpha: .1),
                          child: Icon(
                            Icons.video_library_rounded,
                            size: 20,
                            color: ColorConstant.primary.withValues(alpha: .5),
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
                    subtitle: Text(
                      video.duration,
                      style: context.general.textTheme.bodySmall?.copyWith(
                        color: ColorConstant.primary.withValues(alpha: .6),
                      ),
                    ),
                    onTap: () {
                      controller.closeView(video.title);
                      setState(() {
                        _searchQuery = video.title;
                      });
                      unawaited(
                        showVideoPlayer(context, video.videoUrl, video.title),
                      );
                    },
                  );
                }).toList();
              },
            ),
          ),
          context.sized.emptySizedHeightBoxLow,
          Expanded(
            child: isLoading
                ? LoadingExtension.loadingBar(context)
                : videos.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _searchQuery.isEmpty
                            ? Icons.bookmark_border_rounded
                            : Icons.search_off_rounded,
                        size: context.sized.highValue,
                        color: ColorConstant.primary.withValues(alpha: .3),
                      ),
                      context.sized.emptySizedHeightBoxLow,
                      Text(
                        _searchQuery.isEmpty
                            ? 'No saved videos yet'
                            : 'No videos found for "$_searchQuery"',
                        textAlign: TextAlign.center,
                        style: context.general.textTheme.bodyLarge?.copyWith(
                          color: ColorConstant.primary.withValues(alpha: .5),
                        ),
                      ),
                    ],
                  )
                : _viewType == VideoViewType.list
                ? ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding:
                        context.padding.horizontalNormal +
                        context.padding.verticalLow,
                    itemCount: videos.length,
                    separatorBuilder: (_, _) =>
                        context.sized.emptySizedHeightBoxLow,
                    itemBuilder: (_, index) {
                      final video = videos[index];
                      return _SavedVideoCard(video: video);
                    },
                  )
                : GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
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
          ),
        ],
      ),
    );
  }
}

// Saved Videos Card
@immutable
final class _SavedVideoCard extends StatelessWidget {
  const _SavedVideoCard({required this.video});
  final SavedVideo video;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorConstant.primary.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(context.sized.lowValue + 4),
      ),
      child: ListTile(
        contentPadding: context.padding.low,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(context.sized.lowValue),
          child: Image.network(
            video.thumbnail,
            width: 100,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 100,
              height: 70,
              color: ColorConstant.primary.withValues(alpha: .1),
              child: Icon(
                Icons.video_library_rounded,
                color: ColorConstant.primary.withValues(alpha: .5),
              ),
            ),
          ),
        ),
        title: Text(
          video.title,
          maxLines: 2,
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
              color: ColorConstant.primary.withValues(alpha: .6),
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close_rounded),
          color: ColorConstant.primary.withValues(alpha: .7),
          iconSize: 24,
          onPressed: () async {
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

// Saved Videos Grid Card
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
      borderRadius: BorderRadius.circular(context.sized.lowValue + 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ColorConstant.primary.withValues(alpha: .15),
          borderRadius: BorderRadius.circular(context.sized.lowValue + 4),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(context.sized.lowValue + 4),
              child: Image.network(
                video.thumbnail,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: ColorConstant.primary.withValues(alpha: .1),
                  child: Center(
                    child: Icon(
                      Icons.video_library_rounded,
                      color: ColorConstant.primary.withValues(alpha: .5),
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: DoubleConstant.eight,
              right: DoubleConstant.eight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .6),
                  borderRadius: context.border.lowBorderRadius,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: ColorConstant.primary,
                  iconSize: 20,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  onPressed: () async {
                    await context.read<SavedVideosProvider>().removeVideo(
                      video.videoId,
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: DoubleConstant.zero,
              left: DoubleConstant.zero,
              right: DoubleConstant.zero,
              child: Container(
                padding: context.padding.low,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: .8),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(context.sized.lowValue + 4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      video.title,
                      maxLines: DoubleConstant.two.toInt(),
                      overflow: TextOverflow.ellipsis,
                      style: context.general.textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.duration,
                      style: context.general.textTheme.bodySmall?.copyWith(
                        color: ColorConstant.primary.withValues(alpha: .8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
