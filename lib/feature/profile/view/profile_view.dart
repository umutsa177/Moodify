import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/core/model/saved_video.dart';
import 'package:moodify/core/model/user_profile.dart';
import 'package:moodify/core/providers/auth/auth_provider.dart';
import 'package:moodify/core/providers/saved_videos/saved_videos_provider.dart';
import 'package:moodify/core/router/app_router.dart';
import 'package:moodify/feature/feed/view/feed_view.dart';
import 'package:moodify/feature/profile/mixin/profile_mixin.dart';
import 'package:moodify/feature/profile/mixin/saved_videos_mixin.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/enum/video_view_type.dart';
import 'package:moodify/product/extension/loading_extension.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part '../widget/profile_header.dart';
part '../widget/saved_videos.dart';
part '../widget/saved_videos_card.dart';
part '../widget/saved_videos_grid_card.dart';
part '../widget/searched_videos.dart';

class ProfileView extends StatelessWidget with ProfileMixin {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SavedVideosProvider(),
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        // Background
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: ColorConstant.feedBackgroundColors,
            ),
          ),
          child: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _ProfileHeader()),
              SliverFillRemaining(child: SavedVideos()),
            ],
          ),
        ),
      ),
    );
  }
}
