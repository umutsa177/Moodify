part of '../view/profile_view.dart';

final class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final profile = authProvider.userProfile;
    final isEmailProvider = authProvider.isEmailProvider();

    return Padding(
      padding: context.padding.normal + context.padding.onlyTopMedium,
      child: Column(
        spacing: context.sized.lowValue,
        children: [
          _HeaderButtons(authProvider: authProvider),
          // Profile Picture
          Stack(
            children: [
              _defaultProfilePicture(context, profile, authProvider),
              if (isEmailProvider) const _EmailProfilePicture(),
            ],
          ),
          _userNameText(profile, user, context),
          _userEmailText(user, context),
        ],
      ),
    );
  }

  Text _userEmailText(User? user, BuildContext context) {
    return Text(
      user?.email ?? 'No email',
      style: context.general.textTheme.bodyMedium?.copyWith(
        color: ColorConstant.primaryLight,
      ),
    );
  }

  Text _userNameText(UserProfile? profile, User? user, BuildContext context) {
    return Text(
      profile?.username ?? user?.email?.split('@').first ?? 'User',
      style: context.general.textTheme.headlineSmall?.copyWith(
        color: ColorConstant.onPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  ClipOval _defaultProfilePicture(
    BuildContext context,
    UserProfile? profile,
    AuthProvider authProvider,
  ) {
    return ClipOval(
      child: Container(
        width: context.sized.dynamicHeight(.15),
        height: context.sized.dynamicHeight(.15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstant.onPrimaryLight,
        ),
        child: _profileImage(context, profile, authProvider),
      ),
    );
  }
}

final class _EmailProfilePicture extends StatelessWidget {
  const _EmailProfilePicture();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: DoubleConstant.zero,
      right: DoubleConstant.zero,
      child: GestureDetector(
        onTap: () async {
          final result = await context.route.navigation.pushNamed(
            AppRouter.editProfile,
          );

          // Refresh profile
          if (result != null && context.mounted) {
            await context.read<AuthProvider>().refreshProfile();
          }
        },
        child: Container(
          padding: context.padding.low,
          decoration: BoxDecoration(
            color: ColorConstant.primary,
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorConstant.emojiColor,
              width: DoubleConstant.two,
            ),
          ),
          child: Icon(
            Icons.edit,
            size: context.sized.normalValue,
            color: ColorConstant.secondary,
          ),
        ),
      ),
    );
  }
}

final class _HeaderButtons extends StatelessWidget {
  const _HeaderButtons({
    required this.authProvider,
  });

  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  StringConstant.myProfile,
                  style: context.general.textTheme.headlineSmall?.copyWith(
                    color: ColorConstant.primaryLight,
                  ),
                ),
              ),
              // Settings Button
              Positioned(
                left: DoubleConstant.zero,
                child: IconButton(
                  tooltip: StringConstant.settings,
                  icon: const Icon(Icons.more_vert),
                  iconSize: context.sized.mediumValue,
                  color: ColorConstant.onPrimary,
                  onPressed: () => context.route.navigation.pushNamed(
                    AppRouter.settingsView,
                  ),
                ),
              ),
              // LogOut Button
              Positioned(
                right: DoubleConstant.zero,
                child: IconButton(
                  tooltip: StringConstant.signOut,
                  icon: const Icon(Icons.logout_outlined),
                  iconSize: context.sized.mediumValue,
                  color: ColorConstant.onPrimary,
                  onPressed: () => ProfileMixin.showLogoutDialog(
                    context,
                    authProvider,
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

Widget _profileImage(
  BuildContext context,
  UserProfile? profile,
  AuthProvider authProvider,
) {
  final currentUser = authProvider.currentUser;

  // Avatar URL'e cache-busting parametresi ekle
  String addCacheBuster(String url) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}v=$timestamp';
  }

  // Clean Google URL
  String? cleanGoogleUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.contains('googleusercontent.com')) {
      return url.split('=')[0];
    }
    return url;
  }

  // Email provider
  if (authProvider.isEmailProvider() &&
      profile?.avatarUrl != null &&
      profile!.avatarUrl!.isNotEmpty) {
    final avatarUrlWithCacheBuster = addCacheBuster(profile.avatarUrl!);

    return CachedNetworkImage(
      imageUrl: avatarUrlWithCacheBuster,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      // Unique cache key with timestamp
      cacheKey:
          'avatar_${profile.id}_${profile.updatedAt?.millisecondsSinceEpoch ?? 0}',
      errorWidget: (context, url, error) => _defaultAvatar(context),
      placeholder: (context, url) => LoadingExtension.loadingBar(context),
    );
  }

  // Google provider
  if (authProvider.isGoogleProvider()) {
    final metadata = currentUser?.userMetadata;
    final googleImageUrl =
        metadata?['picture'] as String? ?? metadata?['avatar_url'] as String?;

    if (googleImageUrl != null && googleImageUrl.isNotEmpty) {
      final cleanedUrl = cleanGoogleUrl(googleImageUrl);
      return CachedNetworkImage(
        imageUrl: cleanedUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorWidget: (_, _, _) => _defaultAvatar(context),
        placeholder: (_, _) => LoadingExtension.loadingBar(context),
      );
    }
  }

  // Facebook provider
  if (authProvider.isFacebookProvider()) {
    final metadata = currentUser?.userMetadata;

    final facebookImageUrl = metadata?['picture']?['data']?['url'] as String?;

    if (facebookImageUrl != null && facebookImageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: facebookImageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorWidget: (_, _, _) => _defaultAvatar(context),
        placeholder: (_, _) => LoadingExtension.loadingBar(context),
      );
    }
  }

  // Default avatar
  return _defaultAvatar(context);
}

Widget _defaultAvatar(BuildContext context) {
  return Icon(
    Icons.person_rounded,
    color: ColorConstant.primary,
    size: context.sized.highValue,
  );
}
