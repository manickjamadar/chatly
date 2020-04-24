import 'dart:async';

import 'package:chatly/helpers/failure.dart';
import 'package:chatly/helpers/view_response.dart';
import 'package:chatly/models/message.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/view_state_provider.dart';
import 'package:chatly/service/database_service.dart';
import 'package:flutter/foundation.dart';

class MessageProvider extends ViewStateProvider {
  DatabaseService _databaseService;
  List<Message> _messagesList = [];
  List<Message> get messagesList => _messagesList;
  final Profile senderProfile;
  final Profile receiverProfile;
  StreamSubscription<Message> latestMessageStreamSubscription;

  void cancelMessageSubscription() {
    if (latestMessageStreamSubscription != null) {
      latestMessageStreamSubscription.cancel();
      latestMessageStreamSubscription = null;
    }
  }

  bool get isExecutable =>
      _databaseService != null &&
      senderProfile != null &&
      receiverProfile != null;
  MessageProvider(
      {@required DatabaseService databaseService,
      @required this.senderProfile,
      @required this.receiverProfile})
      : _databaseService = databaseService {
    if (!isExecutable) return;
    latestMessageStreamSubscription = _databaseService
        .getLatestMessage(
            senderId: senderProfile.pid, receiverId: receiverProfile.pid)
        .listen((message) {
      if (message == null) return;
      if (message.senderId != senderProfile.pid) {
        _messagesList.insert(0, message);
        stopExecuting();
      }
    });
  }

  Future<void> fetchExistingMessage({bool byPass = false}) async {
    if (!isExecutable) {
      throw Failure.internal(
          "Message provider is not executable on fetching existing message");
    }
    if (byPass) return stopExecuting();
    try {
      startInitialLoader();
      _messagesList = await _databaseService.fetchAllMessage(
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
      mid: _databaseService.getNewMessageId(
          senderId: senderProfile.pid, receiverId: receiverProfile.pid),
      content: content,
      senderId: senderProfile.pid,
      receiverId: receiverProfile.pid,
    );
    try {
      _messagesList.insert(0, message);
      startExecuting();
      await _databaseService.sendMessageToServer(message);
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
