enum ViewStateStatus { initial, loading, data, empty, error }

class ViewState<T> {
  final T? data;
  final ViewStateStatus status;
  final String? message;
  final StackTrace? stackTrace;
  const ViewState._({
    this.data,
    this.status = ViewStateStatus.initial,
    this.message,
    this.stackTrace,
  });

  ViewState<T> copyWith({
    T? data,
    ViewStateStatus? status,
    String? message,
    StackTrace? stackTrace,
  }) {
    return ViewState._(
      data: data ?? this.data,
      status: status ?? this.status,
      message: message ?? this.message,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  factory ViewState.initial() {
    return ViewState._();
  }

  ViewState<T> loading() {
    return copyWith(status: ViewStateStatus.loading);
  }

  ViewState<T> success(T data) {
    return ViewState._(data: data, status: ViewStateStatus.data);
  }

  ViewState<T> empty() {
    return ViewState._(status: ViewStateStatus.empty);
  }

  ViewState<T> error(String message, [StackTrace? stackTrace]) {
    return copyWith(
      message: message,
      stackTrace: stackTrace,
      status: ViewStateStatus.error,
    );
  }

  bool get isInitial => status == ViewStateStatus.initial;
  bool get isLoading => status == ViewStateStatus.loading;
  bool get isData => status == ViewStateStatus.data;
  bool get isEmpty => status == ViewStateStatus.empty;
  bool get isError => status == ViewStateStatus.error;
}
