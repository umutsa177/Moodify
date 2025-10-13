part of '../view/mood_selection_view.dart';

@immutable
final class _MoodCard extends StatelessWidget {
  const _MoodCard({required this.moods});

  final Moods moods;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.route.navigation.pushNamed(
          AppRouter.navbar,
          arguments: moods,
        );
      },
      child: Card.filled(
        child: Column(
          spacing: context.sized.lowValue,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mood's emoji
            Text(
              moods.mood,
              style: TextStyle(
                fontSize: context.sized.mediumValue + context.sized.normalValue,
              ),
            ),
            // Mood's Label
            Text(
              moods.label,
              style: context.general.primaryTextTheme.bodyLarge?.copyWith(
                fontSize: context.sized.normalValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
