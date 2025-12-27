
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';

errorMsg(String text, BuildContext context) {
  ElegantNotification.error(
          animation: AnimationType.fromBottom,
          
          title: const Text("Error",
              style: TextStyle( fontWeight: FontWeight.w600)),
          description: Text(text.split("] ").last,
              style: const TextStyle( fontSize: 12)))
      .show(context);
}

successMsg(String text, BuildContext context) {
  ElegantNotification.success(
          animation: AnimationType.fromBottom,
          
          title: const Text("Success",
              style: TextStyle( fontWeight: FontWeight.w600)),
          description:
              Text(text, style: const TextStyle( fontSize: 12)))
      .show(context);
}
