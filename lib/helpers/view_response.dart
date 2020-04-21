import 'package:chatly/helpers/failure.dart';

class ViewResponse<T> {
  final String message;
  final T data;
  final bool error;

  const ViewResponse(this.message, {this.error = false, this.data});
  factory ViewResponse.fromFailure(Failure failure) {
    String responseMessage = failure.message;
    if (failure.priority == FailurePriority.internal) {
      print(failure);
      responseMessage = "Something went wrong";
    }
    return ViewResponse(responseMessage, error: true, data: null);
  }
}
