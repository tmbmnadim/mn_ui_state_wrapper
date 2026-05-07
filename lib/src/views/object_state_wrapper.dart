import 'package:flutter/material.dart';
import '../models/object_view_state.dart';

class ObjectStateWrapper<T> extends StatelessWidget {
  final ObjectViewState<T> state;
  final Widget Function(Widget child)? base;
  final Widget Function() onInitial;
  final Widget Function() onLoading;
  final Widget Function(T data) onData;
  final Widget Function() onEmpty;
  final Widget Function(String message, StackTrace? stackTrace) onError;

  const ObjectStateWrapper({
    super.key,
    required this.state,
    this.base,
    required this.onInitial,
    required this.onLoading,
    required this.onData,
    required this.onEmpty,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    final child = switch (state) {
      ViewStateInitial() => onInitial(),
      ViewStateLoading() => onLoading(),
      ViewStateData(:final data) => onData(data),
      ViewStateEmpty() => onEmpty(),
      ViewStateError(:final message, :final stackTrace) => onError(
        message,
        stackTrace,
      ),
    };
    if (base != null) {
      return base!(child);
    } else {
      return child;
    }
  }
}
