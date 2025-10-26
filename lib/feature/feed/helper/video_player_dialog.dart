part of '../view/feed_view.dart';

final class VideoPlayerDialog extends StatefulWidget {
  const VideoPlayerDialog({
    required this.videoUrl,
    required this.title,
    super.key,
  });
  final String videoUrl;
  final String title;

  @override
  State<VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  late WebViewController _webViewController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeWebView());
  }

  Future<void> _initializeWebView() async {
    _webViewController = WebViewController();

    await _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _webViewController.setBackgroundColor(ColorConstant.secondary);
    await _webViewController.setNavigationDelegate(_navigationDelegate());
    await _webViewController.loadRequest(Uri.parse(widget.videoUrl));
  }

  NavigationDelegate _navigationDelegate() {
    return NavigationDelegate(
      onPageStarted: (_) =>
          _updateLoadingState(isLoading: true, hasError: false),
      onPageFinished: (_) => _updateLoadingState(isLoading: false),
      onWebResourceError: (_) =>
          _updateLoadingState(isLoading: false, hasError: true),
    );
  }

  void _updateLoadingState({bool? isLoading, bool? hasError}) {
    if (!mounted) return;
    setState(() {
      if (isLoading != null) _isLoading = isLoading;
      if (hasError != null) _hasError = hasError;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstant.secondary,
        borderRadius: context.border.highBorderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(context),
          _videoPlayer(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: context.padding.normal,
      decoration: BoxDecoration(
        color: ColorConstant.onSecondary,
        borderRadius: BorderRadius.only(
          topLeft: context.border.highBorderRadius.topLeft,
          topRight: context.border.highBorderRadius.topRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: context.general.textTheme.titleMedium?.copyWith(
                color: ColorConstant.primary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: DoubleConstant.two.toInt(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: ColorConstant.primary),
            onPressed: context.route.pop,
          ),
        ],
      ),
    );
  }

  Widget _videoPlayer(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: context.border.highBorderRadius.bottomLeft,
          bottomRight: context.border.highBorderRadius.bottomRight,
        ),
        child: Stack(
          children: [
            WebViewWidget(controller: _webViewController),
            if (_isLoading) LoadingExtension.loadingBar(context),
            if (_hasError && !_isLoading) _errorView(context),
          ],
        ),
      ),
    );
  }

  Widget _errorView(BuildContext context) {
    return Padding(
      padding: context.padding.horizontalNormal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: DoubleConstant.sixteen,
        children: [
          Icon(
            Icons.error_outline,
            color: ColorConstant.primary,
            size: context.sized.dynamicHeight(.065),
          ),
          Text(
            StringConstant.notLoaded,
            style: context.general.textTheme.bodyLarge?.copyWith(
              color: ColorConstant.primary,
            ),
          ),
          _retryButton(context),
        ],
      ),
    );
  }

  Widget _retryButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _initializeWebView,
      icon: const Icon(
        Icons.refresh,
        color: ColorConstant.secondary,
      ),
      label: Text(
        StringConstant.tryAgain,
        style: context.general.textTheme.titleSmall?.copyWith(
          color: ColorConstant.secondary,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstant.primary,
      ),
    );
  }
}
