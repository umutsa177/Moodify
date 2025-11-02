part of '../view/feed_view.dart';

@immutable
final class _NoVideosView extends StatelessWidget {
  const _NoVideosView();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, _) => const SizedBox.shrink(),
            childCount: (DoubleConstant.two / 2).toInt(),
          ),
        ),

        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: context.sized.lowValue,
            children: [
              Icon(
                Icons.video_library_outlined,
                size: context.sized.highValue,
                color: ColorConstant.emailBackground,
              ),
              Text(
                StringConstant.videosNotFound,
                style: context.general.textTheme.bodyLarge?.copyWith(
                  color: ColorConstant.onPrimary,
                ),
              ),
              Text(
                StringConstant.pullToRefresh,
                style: context.general.textTheme.bodySmall?.copyWith(
                  color: ColorConstant.emailBackground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
