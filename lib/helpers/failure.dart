enum FailurePriority { internal, public }

class Failure {
  final String message;
  final FailurePriority priority;
  Failure(this.message, {this.priority = FailurePriority.internal});
  factory Failure.public(String message) {
    return Failure(message, priority: FailurePriority.public);
  }
  factory Failure.internal(String message) {
    print("Failure: $message");
    return Failure(message, priority: FailurePriority.internal);
  }
  @override
  String toString() {
    return "Failure: $message";
  }
}
