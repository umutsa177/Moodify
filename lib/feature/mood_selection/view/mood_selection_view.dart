import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/enum/moods.dart';

part '../widget/mood_card.dart';
part '../widget/title_and_description.dart';

class MoodSelectionView extends StatelessWidget {
  const MoodSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ColorConstant.splashBackgroundColors,
          ),
        ),
        child: Column(
          children: [
            // Title And Description
            Padding(
              padding:
                  context.padding.onlyTopMedium + context.padding.onlyTopNormal,
              child: const _TitleAndDescription(),
            ),
            context.sized.emptySizedHeightBoxLow,
            // Mood Selection
            Expanded(
              child: GridView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: Moods.values.length,
                padding: context.padding.horizontalLow,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: DoubleConstant.two.toInt(),
                ),
                itemBuilder: (context, index) {
                  final mood = Moods.values[index];
                  return _MoodCard(moods: mood);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
