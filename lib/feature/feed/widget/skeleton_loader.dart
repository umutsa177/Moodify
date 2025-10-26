part of '../view/feed_view.dart';

final class _SkeletonLoader extends StatelessWidget {
  const _SkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorConstant.softPurple,
      highlightColor: ColorConstant.softGold,
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
