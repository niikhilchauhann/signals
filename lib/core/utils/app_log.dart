import 'package:flutter/foundation.dart';

abstract class AppLog {
  static void errorLog(String subject, dynamic error) {
    if (kDebugMode) print("--------------$subject------------\n$error");
  }
}
