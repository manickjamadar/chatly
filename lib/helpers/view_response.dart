import 'package:chatly/helpers/failure.dart';

class ViewResponse<T> {
  final String message;
  final T data;
  final bool error;
  const ViewResponse(this.message, {this.error = false, this.data});
}

class FailureViewResponse extends ViewResponse<Failure> {
  FailureViewResponse(Failure failure)
      : super(
            failure.priority == FailurePriority.internal
                ? "Something went wrong"
                : failure.message,
            error: true,
            data: failure);
}
