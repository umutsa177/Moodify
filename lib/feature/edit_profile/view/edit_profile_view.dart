import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/model/user_profile.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/feature/edit_profile/mixin/edit_profile_mixin.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/extension/loading_extension.dart';
import 'package:provider/provider.dart';

part '../widget/avatar_editing_buttons.dart';
part '../widget/profile_editing_textfields.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView>
    with EditProfileMixin {
  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthProvider>().userProfile;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: ColorConstant.feedBackgroundColors,
            ),
          ),

          child: Padding(
            padding: context.padding.normal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _editProfileHeader(context),
                context.sized.emptySizedHeightBoxNormal,
                // Camera and Delete Buttons for Avatar
                _AvatarEditingButtons(
                  profile: profile,
                  selectedImage: selectedImage,
                  onCameraPressed: imageSourceSelectionDialog,
                  onDeletePressed: deleteAvatarDialog,
                ),
                context.sized.emptySizedHeightBoxHigh,
                // Username and Email TextFields
                _ProfileEditingTextFields(
                  usernameController: usernameController,
                  profile: profile,
                ),
                context.sized.emptySizedHeightBoxHigh,
                _saveButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _saveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : saveProfile,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstant.secondary,
        foregroundColor: ColorConstant.onPrimary,
        disabledBackgroundColor: ColorConstant.videoErrorColor,
        fixedSize: Size.fromHeight(
          context.sized.dynamicHeight(.08),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: context.border.normalBorderRadius,
        ),
      ),
      child: isLoading
          ? LoadingExtension.loadingBar(context)
          : Text(
              StringConstant.save,
              style: context.general.textTheme.titleMedium?.copyWith(
                color: ColorConstant.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  Padding _editProfileHeader(BuildContext context) {
    return Padding(
      padding: context.padding.onlyTopNormal,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            child: Text(
              StringConstant.editProfile,
              textAlign: TextAlign.center,
              style: context.general.textTheme.headlineSmall?.copyWith(
                color: ColorConstant.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButton(
                color: ColorConstant.onPrimary,
              ),
              // Empty space
              SizedBox(
                width: context.sized.mediumValue + context.sized.lowValue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
