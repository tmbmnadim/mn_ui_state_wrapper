sealed class ObjectViewState<T> {
  final T? data;
  final String? message;
  final StackTrace? stackTrace;
  const ObjectViewState({this.data, this.message, this.stackTrace});
}

class ViewStateInitial<T> extends ObjectViewState<T> {
  const ViewStateInitial() : super(data: null, message: null, stackTrace: null);
}

class ViewStateLoading<T> extends ObjectViewState<T> {
  const ViewStateLoading() : super(message: null, stackTrace: null);
}

class ViewStateData<T> extends ObjectViewState<T> {
  @override
  T get data => super.data!;
  const ViewStateData(T data) : super(data: data);
}

class ViewStateEmpty<T> extends ObjectViewState<T> {
  const ViewStateEmpty() : super(data: null, message: null, stackTrace: null);
}

class ViewStateError<T> extends ObjectViewState<T> {
  @override
  String get message => super.message!;
  const ViewStateError(String message, [StackTrace? stackTrace])
    : super(message: message, stackTrace: stackTrace);
}
