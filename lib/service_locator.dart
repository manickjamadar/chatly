import 'package:chatly/service/messages_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<MessagesService>(MessagesService());
}
