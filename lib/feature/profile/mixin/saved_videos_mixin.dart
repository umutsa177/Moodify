import 'package:flutter/material.dart';
import 'package:moodify/core/model/saved_video.dart';
import 'package:moodify/core/providers/saved_videos/saved_videos_provider.dart';
import 'package:moodify/feature/profile/view/profile_view.dart';
import 'package:moodify/product/enum/video_view_type.dart';
import 'package:provider/provider.dart';

mixin SavedVideosMixin on State<SavedVideos> {
  VideoViewType viewType = VideoViewType.list;
  late final SearchController searchController;
  String searchQuery = '';

  SavedVideosProvider get provider => context.watch<SavedVideosProvider>();
  List<SavedVideo> get videos => filterVideos(provider.savedVideos);
  bool get isLoading => provider.isLoading;

  @override
  void initState() {
    super.initState();
    searchController = SearchController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<SavedVideo> filterVideos(List<SavedVideo> videos) {
    if (searchQuery.isEmpty) return videos;

    return videos.where((video) {
      return video.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          video.duration.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }
}
