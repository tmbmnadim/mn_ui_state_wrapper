import 'dart:async';
import 'package:flutter/widgets.dart';

/// A wrapper widget that listens to scroll events of its scrollable [child]
/// and triggers [onLoadMore] when the user scrolls near the bottom.
/// 
/// This approach allows you to use any scrollable widget (ListView, GridView, 
/// CustomScrollView, etc.) and keep all of their original properties.
class PaginatedScrollWrapper extends StatefulWidget {
  /// The scrollable child widget (e.g., ListView.builder, GridView).
  final Widget child;

  /// Callback triggered when scrolling reaches near the bottom.
  final FutureOr<void> Function() onLoadMore;

  /// Whether a load operation is currently in progress. 
  /// If this is true, [onLoadMore] will not be called.
  /// If not provided, the wrapper will automatically track the Future returned by [onLoadMore].
  final bool? isLoading;

  /// The distance in pixels from the bottom of the scroll extent at which [onLoadMore] is triggered.
  /// Defaults to 250.0 pixels.
  final double triggerOffset;

  const PaginatedScrollWrapper({
    super.key,
    required this.child,
    required this.onLoadMore,
    this.isLoading,
    this.triggerOffset = 250.0,
  }) : assert(triggerOffset >= 0.0, 'triggerOffset must be non-negative');

  @override
  State<PaginatedScrollWrapper> createState() => _PaginatedScrollWrapperState();
}

class _PaginatedScrollWrapperState extends State<PaginatedScrollWrapper> {
  bool _internalIsLoading = false;

  bool get _isLoading => widget.isLoading ?? _internalIsLoading;

  void _handleLoadMore() async {
    if (_isLoading) return;

    if (widget.isLoading == null) {
      setState(() {
        _internalIsLoading = true;
      });
    }

    try {
      await widget.onLoadMore();
    } finally {
      if (widget.isLoading == null && mounted) {
        setState(() {
          _internalIsLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        // We only care about ScrollUpdateNotification
        if (!_isLoading && notification is ScrollUpdateNotification) {
          final metrics = notification.metrics;
          final maxScroll = metrics.maxScrollExtent;
          final currentScroll = metrics.pixels;

          // Check if we are near the bottom of the scrollable area
          if (maxScroll > 0 && maxScroll - currentScroll <= widget.triggerOffset) {
            _handleLoadMore();
          }
        }
        // Return false to allow the notification to bubble up if other listeners exist
        return false;
      },
      child: widget.child,
    );
  }
}
