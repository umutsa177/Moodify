import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/providers/feed/feed_provider.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/enum/moods.dart';
import 'package:moodify/product/extension/loading_extension.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FeedView extends StatelessWidget {
  const FeedView({required this.mood, super.key});
  final Moods mood;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedProvider(mood),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appBar(context),
        body: Container(
          // Background
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: ColorConstant.feedBackgroundColors,
            ),
          ),
          child: const _VideoList(),
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

class _VideoList extends StatelessWidget {
  const _VideoList();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FeedProvider>();
    final videos = provider.state.videos;
    final isLoading = provider.state.isLoading;
    final reachedEnd = provider.state.reachedEnd;

    if (videos.isEmpty && isLoading) {
      return const _SkeletonLoader();
    }

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
        padding: context.padding.normal + context.padding.onlyTopHigh,
        itemCount: videos.length + (reachedEnd ? 0 : 1),
        separatorBuilder: (_, _) => context.sized.emptySizedHeightBoxLow,
        itemBuilder: (_, i) {
          if (i == videos.length) return LoadingExtension.loadingBar(context);

          final v = videos[i];
          final thumb = v.pictures.sizes
              .where((e) => e.width == 640)
              .map((e) => e.link)
              .firstOrNull;

          return _FeedCard(
            thumbnail: thumb ?? '',
            title: v.name,
            duration: '${v.duration} s',
          );
        },
      ),
    );
  }
}

final class _FeedCard extends StatelessWidget {
  const _FeedCard({
    required this.thumbnail,
    required this.title,
    required this.duration,
  });
  final String thumbnail;
  final String title;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Colors.black87,
              Colors.transparent,
            ],
          ),
        ),
        padding: context.padding.normal,
        alignment: Alignment.bottomLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: DoubleConstant.two.toInt(),
                overflow: TextOverflow.ellipsis,
                style: context.general.textTheme.titleMedium?.copyWith(
                  color: ColorConstant.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Chip(
              label: Text(duration),
              backgroundColor: ColorConstant.onPrimary,
              labelStyle: context.general.textTheme.bodySmall?.copyWith(
                color: ColorConstant.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _SkeletonLoader extends StatelessWidget {
  const _SkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        padding:
            context.padding.normal +
            EdgeInsets.only(top: context.sized.highValue),
        itemCount: DoubleConstant.eight.toInt(),
        separatorBuilder: (_, _) => context.sized.emptySizedHeightBoxLow,
        itemBuilder: (_, _) => Container(
          margin: context.padding.horizontalNormal,
          height: context.sized.dynamicHeight(.25),
          decoration: BoxDecoration(
            color: ColorConstant.primary,
            borderRadius: context.border.highBorderRadius,
          ),
        ),
      ),
    );
  }
}
