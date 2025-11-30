part of '../view/settings_view.dart';

@immutable
final class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: ColorConstant.primary,
        size: DoubleConstant.twentyEight,
      ),
      title: Text(
        title,
        style: context.general.textTheme.bodyLarge?.copyWith(
          color: ColorConstant.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: context.general.textTheme.bodySmall?.copyWith(
          color: ColorConstant.videoDurationColor,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: ColorConstant.videoErrorColor,
      ),
    );
  }
}
