part of '../view/edit_profile_view.dart';

@immutable
final class _ProfileEditingTextFields extends StatelessWidget {
  const _ProfileEditingTextFields({
    required this.usernameController,
    required this.profile,
  });

  final TextEditingController usernameController;
  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringConstant.username,
          style: context.general.textTheme.titleMedium?.copyWith(
            color: ColorConstant.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        context.sized.emptySizedHeightBoxLow,
        TextField(
          controller: usernameController,
          style: context.general.textTheme.bodyLarge?.copyWith(
            color: ColorConstant.onPrimary,
          ),
          decoration: InputDecoration(
            hintText: StringConstant.nameHint,
            hintStyle: TextStyle(
              color: ColorConstant.videoErrorColor,
            ),
            filled: true,
            fillColor: ColorConstant.userNameInputColor,
            border: OutlineInputBorder(
              borderRadius: context.border.normalBorderRadius,
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(
              Icons.person_outline,
              color: ColorConstant.primary,
            ),
          ),
        ),
        context.sized.emptySizedHeightBoxNormal,
        // Email (Read-only)
        Text(
          StringConstant.email,
          style: context.general.textTheme.titleMedium?.copyWith(
            color: ColorConstant.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        context.sized.emptySizedHeightBoxLow,
        Container(
          padding: context.padding.normal,
          decoration: BoxDecoration(
            color: ColorConstant.emailDecorationColor,
            borderRadius: context.border.normalBorderRadius,
            border: Border.all(
              color: ColorConstant.onPrimaryLight,
            ),
          ),
          child: Row(
            spacing: DoubleConstant.twelve,
            children: [
              Icon(
                Icons.email_outlined,
                color: ColorConstant.videoErrorColor,
              ),
              Expanded(
                child: Text(
                  profile?.email ?? StringConstant.notEmail,
                  style: context.general.textTheme.bodyLarge?.copyWith(
                    color: ColorConstant.videoCloseColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
