import 'package:flutter/material.dart';
import '../models/view_state.dart';

class StateWrapper<T> extends StatelessWidget {
  final ViewState<T> state;
  final Widget Function(Widget child)? base;
  final Widget Function() onInitial;
  final Widget Function() onLoading;
  final Widget Function(T data) onData;
  final Widget Function() onEmpty;
  final Widget Function(String message, StackTrace? stackTrace) onError;

  const StateWrapper({
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
    final child = switch (state.status) {
      ViewStateStatus.initial => onInitial(),
      ViewStateStatus.loading => onLoading(),
      ViewStateStatus.data => onData(state.data as T),
      ViewStateStatus.empty => onEmpty(),
      ViewStateStatus.error => onError(state.message!, state.stackTrace),
    };
    if (base != null) {
      return base!(child);
    } else {
      return child;
    }
  }
}
