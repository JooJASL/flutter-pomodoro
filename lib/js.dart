@JS()
library main;

import 'package:js/js.dart';

@JS('parent.sendNotification')
external void sendNotification(dynamic msg);

void sendWebNotification(String msg) {
  sendNotification(msg);
}
