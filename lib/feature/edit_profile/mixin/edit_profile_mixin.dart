import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/feature/edit_profile/view/edit_profile_view.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/extension/toast_extension.dart';
import 'package:provider/provider.dart';

mixin EditProfileMixin on State<EditProfileView> {
  late TextEditingController usernameController;
  bool isLoading = false;
  File? selectedImage;
  late final ImagePicker _picker;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
    final profile = context.read<AuthProvider>().userProfile;
    usernameController = TextEditingController(text: profile?.username ?? '');
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  // Pick Image From Gallery
  Future<void> pickImageFromGallery() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: DoubleConstant.profileImageSize,
        maxHeight: DoubleConstant.profileImageSize,
        imageQuality: DoubleConstant.profileImageQuality.toInt(),
      );

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        await ToastExtension.showToast(
          message: 'An error occurred while selecting a photo: $e',
          backgroundColor: ColorConstant.error,
          context: context,
        );
      }
    }
  }

  // Pick Image From Camera
  Future<void> pickImageFromCamera() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: DoubleConstant.profileImageSize,
        maxHeight: DoubleConstant.profileImageSize,
        imageQuality: DoubleConstant.profileImageQuality.toInt(),
      );

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        await ToastExtension.showToast(
          message: 'An error occurred while selecting a photo: $e',
          backgroundColor: ColorConstant.error,
          context: context,
        );
      }
    }
  }

  // Image Source Select
  Future<void> imageSourceSelectionDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorConstant.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: context.border.normalBorderRadius,
        ),
        title: Text(
          StringConstant.chooseImageSource,
          style: context.general.textTheme.titleLarge?.copyWith(
            color: ColorConstant.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: ColorConstant.primary,
              ),
              title: Text(
                StringConstant.gallery,
                style: context.general.textTheme.bodyLarge?.copyWith(
                  color: ColorConstant.primary,
                ),
              ),
              onTap: () async {
                await context.route.pop();
                await pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: ColorConstant.primary,
              ),
              title: Text(
                StringConstant.camera,
                style: context.general.textTheme.bodyLarge?.copyWith(
                  color: ColorConstant.primary,
                ),
              ),
              onTap: () async {
                await context.route.pop();
                await pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Delete Profile Photo
  Future<void> deleteAvatarDialog() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: ColorConstant.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: context.border.normalBorderRadius,
        ),
        title: Text(
          StringConstant.deleteAvatar,
          style: context.general.textTheme.titleLarge?.copyWith(
            color: ColorConstant.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          StringConstant.deleteYourAvatar,
          style: context.general.textTheme.bodyLarge?.copyWith(
            color: ColorConstant.onPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.route.pop(false),
            child: Text(
              StringConstant.cancel,
              style: context.general.textTheme.bodyLarge?.copyWith(
                color: ColorConstant.videoDurationColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => context.route.pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.error,
              foregroundColor: ColorConstant.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: context.border.lowBorderRadius,
              ),
            ),
            child: Text(
              StringConstant.delete,
              style: context.general.textTheme.bodyLarge?.copyWith(
                color: ColorConstant.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete ?? false) {
      setState(() => isLoading = true);

      final success = await context.read<AuthProvider>().deleteAvatar();

      setState(() {
        isLoading = false;
        selectedImage = null;
      });

      if (mounted) {
        await ToastExtension.showToast(
          message: success
              ? StringConstant.deletedAvatar
              : StringConstant.deleteAvatarError,
          backgroundColor: success
              ? ColorConstant.success
              : ColorConstant.error,
          context: context,
        );
      }
    }
  }

  // Save Profile
  Future<void> saveProfile() async {
    if (usernameController.text.trim().isEmpty) {
      await ToastExtension.showToast(
        message: StringConstant.nameCannotBeEmpty,
        backgroundColor: ColorConstant.error,
        context: context,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      var success = true;

      // Upload Avatar
      if (selectedImage != null) {
        success = await authProvider.uploadAvatar(selectedImage!);
        if (!success && mounted) {
          return ToastExtension.showToast(
            message: StringConstant.uploadAvatarError,
            backgroundColor: ColorConstant.error,
            context: context,
          );
        }
      }

      // Update username
      final currentUsername = authProvider.userProfile?.username;
      if (usernameController.text.trim() != currentUsername) {
        success = await authProvider.updateProfile(
          username: usernameController.text.trim(),
        );
        if (!success && mounted) {
          return ToastExtension.showToast(
            message: StringConstant.updateProfileError,
            backgroundColor: ColorConstant.error,
            context: context,
          );
        }
      }

      // Reload profile
      await authProvider.refreshProfile();

      if (mounted) {
        await ToastExtension.showToast(
          message: StringConstant.updateProfileSuccess,
          backgroundColor: ColorConstant.success,
          context: context,
        );

        // Add delay
        await Future.delayed(const Duration(milliseconds: 300), () {});

        if (mounted) await context.route.pop(true);
      }
    } on Exception catch (e) {
      if (kDebugMode) log('Error saving profile: $e');
      if (mounted) {
        await ToastExtension.showToast(
          message: 'Error while updating profile: $e',
          backgroundColor: ColorConstant.error,
          context: context,
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
}
