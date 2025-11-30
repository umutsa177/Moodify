part of '../view/edit_profile_view.dart';

@immutable
final class _AvatarEditingButtons extends StatelessWidget {
  const _AvatarEditingButtons({
    required this.profile,
    required this.selectedImage,
    required this.onCameraPressed,
    required this.onDeletePressed,
  });

  final UserProfile? profile;
  final File? selectedImage;
  final VoidCallback onCameraPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final currentProfile = profile;

    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: Container(
              height: context.sized.dynamicHeight(.2),
              width: context.sized.dynamicHeight(.2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstant.onPrimaryLight,
              ),
              child: selectedImage != null
                  ? Image.file(
                      selectedImage!,
                      fit: BoxFit.cover,
                    )
                  : (currentProfile?.avatarUrl != null &&
                            currentProfile!.avatarUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: currentProfile.avatarUrl!,
                            fit: BoxFit.cover,
                            cacheKey:
                                'edit_avatar_${currentProfile.id}_${currentProfile.updatedAt?.millisecondsSinceEpoch ?? 0}',
                            errorWidget: (context, url, error) {
                              return Icon(
                                Icons.person_rounded,
                                color: ColorConstant.primary,
                                size: context.sized.highValue,
                              );
                            },
                            placeholder: (_, _) {
                              return LoadingExtension.loadingBar(
                                context,
                              );
                            },
                          )
                        : Icon(
                            Icons.person_rounded,
                            color: ColorConstant.primary,
                            size: context.sized.highValue,
                          )),
            ),
          ),
          // Camera button
          Positioned(
            bottom: DoubleConstant.zero,
            right: DoubleConstant.zero,
            child: GestureDetector(
              onTap: onCameraPressed,
              child: Container(
                padding: context.padding.low * 1.5,
                decoration: BoxDecoration(
                  color: ColorConstant.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorConstant.emojiColor,
                    width: DoubleConstant.two,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: ColorConstant.onPrimary,
                ),
              ),
            ),
          ),
          // Delete button
          if (currentProfile?.avatarUrl != null || selectedImage != null)
            Positioned(
              top: DoubleConstant.zero,
              right: DoubleConstant.zero,
              child: GestureDetector(
                onTap: onDeletePressed,
                child: Container(
                  padding: context.padding.low,
                  decoration: BoxDecoration(
                    color: ColorConstant.error,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorConstant.emojiColor,
                      width: DoubleConstant.two,
                    ),
                  ),
                  child: const Icon(
                    Icons.delete,
                    size: DoubleConstant.twenty,
                    color: ColorConstant.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
