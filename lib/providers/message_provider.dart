import 'dart:async';
import 'package:chatly/helpers/failure.dart';
import 'package:chatly/helpers/view_response.dart';
import 'package:chatly/models/message.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/view_state_provider.dart';
import 'package:chatly/service/messages_service.dart';
import 'package:chatly/service_locator.dart';
import 'package:flutter/foundation.dart';

class MessageProvider extends ViewStateProvider {
  MessagesService _messagesService = locator<MessagesService>();
  List<Message> _messagesList = [];
  List<Message> get messagesList => _messagesList;
  final Profile senderProfile;
  final Profile receiverProfile;
  StreamSubscription<Message> latestMessageStreamSubscription;
  bool _isActive = false;

  activate() {
    _isActive = true;
  }

  deactivate() {
    _isActive = false;
  }

  void cancelMessageSubscription() {
    if (latestMessageStreamSubscription != null) {
      latestMessageStreamSubscription.cancel();
      latestMessageStreamSubscription = null;
    }
  }

  bool get isExecutable =>
      _messagesService != null &&
      senderProfile != null &&
      receiverProfile != null;
  MessageProvider(
      {@required this.senderProfile, @required this.receiverProfile}) {
    if (!isExecutable) return;
    latestMessageStreamSubscription = _messagesService
        .getLatestMessage(
            senderId: senderProfile.pid, receiverId: receiverProfile.pid)
        .listen(handleLatestMessage);
  }

  void handleLatestMessage(Message latestMessage) {
    if (latestMessage == null) return;
    bool isIncomingMessage = latestMessage.senderId == receiverProfile.pid;
    if (isIncomingMessage) {
      _messagesList.insert(0, latestMessage);
      stopExecuting();
    }
  }

  Future<void> fetchExistingMessage({bool byPass = false}) async {
    if (!isExecutable) {
      throw Failure.internal(
          "Message provider is not executable on fetching existing message");
    }
    if (byPass) return stopExecuting();
    try {
      startInitialLoader();
      _messagesList = await _messagesService.fetchAllMessage(
          senderId: senderProfile.pid, receiverId: receiverProfile.pid);
      stopExecuting();
    } on Failure catch (failure) {
      _messagesList = [];
      stopExecuting();
      print(failure);
    }
  }

  Future<ViewResponse<void>> sendMessage({@required String content}) async {
    if (!isExecutable || content == null)
      return FailureViewResponse(Failure.internal("Some dependencies missing"));
    final Message message = Message(
      mid: _messagesService.getNewMessageId(
          senderId: senderProfile.pid, receiverId: receiverProfile.pid),
      content: content,
      senderId: senderProfile.pid,
      receiverId: receiverProfile.pid,
    );
    try {
      _messagesList.insert(0, message);
      startExecuting();
      await _messagesService.sendMessageToServer(message);
      stopExecuting();
      return ViewResponse("Sending message successful");
    } on Failure catch (failure) {
      _messagesList.removeAt(0);
      stopExecuting();
      return FailureViewResponse(failure);
    }
  }

  @override
  void dispose() {
    cancelMessageSubscription();
    super.dispose();
  }
}
