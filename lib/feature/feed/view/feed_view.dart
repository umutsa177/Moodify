import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/model/saved_video.dart';
import 'package:moodify/core/providers/feed/feed_provider.dart';
import 'package:moodify/core/providers/saved_videos/saved_videos_provider.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/enum/moods.dart';
import 'package:moodify/product/extension/loading_extension.dart';
import 'package:moodify/product/extension/toast_extension.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

part '../widget/skeleton_loader.dart';
part '../widget/feed_card.dart';
part '../helper/video_player_dialog.dart';
part '../widget/no_videos_view.dart';
part '../widget/save_button.dart';

class FeedView extends StatelessWidget {
  const FeedView({required this.mood, super.key});
  final Moods mood;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FeedProvider(mood)),
        ChangeNotifierProvider(create: (_) => SavedVideosProvider()),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appBar(context),
        body: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: ColorConstant.feedBackgroundColors,
            ),
          ),
          child: _VideoList(),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        '${mood.label} Videos ${mood.mood}',
        style: context.general.textTheme.headlineSmall?.copyWith(
          color: ColorConstant.onPrimary,
        ),
      ),
    );
  }
}

final class _VideoList extends StatelessWidget {
  const _VideoList();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FeedProvider>();
    final videos = provider.state.videos;
    final isLoading = provider.state.isLoading;
    final reachedEnd = provider.state.reachedEnd;

    return RefreshIndicator.adaptive(
      onRefresh: () async => provider.refresh(),
      color: ColorConstant.primary,
      backgroundColor: ColorConstant.secondary,
      child: Builder(
        builder: (context) {
          // Show shimmer loader while videos loading
          if (isLoading && videos.isEmpty) return const _SkeletonLoader();

          // If there is no videos or connection error
          if (videos.isEmpty) return const _NoVideosView();

          return NotificationListener<ScrollNotification>(
            onNotification: (scroll) {
              if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent &&
                  !reachedEnd &&
                  !isLoading) {
                unawaited(provider.loadMoreVideos());
              }
              return false;
            },
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              padding: context.padding.normal + context.padding.onlyTopHigh,
              itemCount: videos.length + (reachedEnd ? 0 : 1),
              separatorBuilder: (_, _) => context.sized.emptySizedHeightBoxLow,
              itemBuilder: (_, i) {
                if (i == videos.length) {
                  return Padding(
                    padding: context.padding.onlyBottomMedium * 2,
                    child: LoadingExtension.loadingBar(context),
                  );
                }

                final v = videos[i];
                final thumb = v.pictures.sizes
                    .where((e) => e.width == 640)
                    .map((e) => e.link)
                    .firstOrNull;

                return _FeedCard(
                  videoId: v.videoId,
                  thumbnail: thumb ?? '',
                  title: v.name,
                  duration: '${v.duration} s',
                  videoUrl: v.playerEmbedUrl ?? '',
                  onTap: () async {
                    if (v.playerEmbedUrl != null &&
                        v.playerEmbedUrl!.isNotEmpty) {
                      await showVideoPlayer(context, v.playerEmbedUrl!, v.name);
                    } else {
                      await ToastExtension.showToast(
                        message: StringConstant.notPlayable,
                        backgroundColor: ColorConstant.error,
                        context: context,
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

Future<void> showVideoPlayer(
  BuildContext context,
  String videoUrl,
  String title,
) async {
  await showDialog<void>(
    context: context,
    barrierColor: ColorConstant.onTertiary,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: DoubleConstant.eight,
        sigmaY: DoubleConstant.eight,
      ),
      child: Dialog(
        backgroundColor: ColorConstant.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: context.sized.dynamicWidth(.05),
          vertical: context.sized.dynamicHeight(.1),
        ),
        child: VideoPlayerDialog(
          videoUrl: videoUrl,
          title: title,
        ),
      ),
    ),
  );
}
