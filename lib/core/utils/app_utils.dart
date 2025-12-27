import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

abstract class AppUtils {
  static String getChatId(String user1, String user2) {
    final sorted = [user1, user2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  static String formatSmartDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final inputDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(inputDate).inDays;

    if (diff == 0) {
      return 'Today';
    } else if (diff == 1) {
      return 'Yesterday';
    } else if (diff <= 6 &&
        inputDate.isAfter(today.subtract(Duration(days: today.weekday)))) {
      // Same week, show weekday
      return DateFormat.EEEE().format(date);
    } else {
      return '$diff day${diff == 1 ? '' : 's'} ago';
    }
  }

  static String formatSmartTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return DateFormat('hh:mm a').format(date); // fallback to actual time
    }
  }

  static String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) return "";
    return text.substring(0, 1).toUpperCase() + text.substring(1).toLowerCase();
  }

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  }

  static String formatDate(DateTime? date) {
    if (date == null) return "";
    return DateFormat('dd-MM-yyyy hh:mm a').format(date);
  }

  static String formatTo12Hour(String timeString) {
    List<String> parts = timeString.split(':');
    if (parts.length != 3) return timeString; // Return original if not valid

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    //int seconds = int.parse(parts[2]);

    String period = hours >= 12 ? "PM" : "AM";
    int hour12 = hours % 12 == 0 ? 12 : hours % 12; // Convert 0 to 12 for AM

    return "$hour12:${minutes.toString().padLeft(2, '0')} $period";
  }

  static String formatDateOnly(DateTime? date) {
    if (date == null) return "";
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String? formatDateOnlyYMD(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static DateTime parseDateOnlyYMD(String? date) {
    if (date == null) return DateTime.now();
    return DateFormat('yyyy-MM-dd').parse(date);
  }

  static String formatDateText(DateTime? date) {
    if (date == null) return "";
    return DateFormat.yMMMd().format(date);
  }

  static String formatDay(DateTime? date) {
    if (date == null) return "";
    return DateFormat('EEEE').format(date);
  }

  /// ------------ phone helpers -----------------
  static bool isNumeric(String s) =>
      s.isNotEmpty && int.tryParse(s.replaceAll("+", "")) != null;

  static String removeDiacritics(String str) {
    const withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  static String getTimeZone() =>
      "${DateTime.now().timeZoneName}/${DateTime.now().timeZoneOffset}";



static String toTitleCase(String? text) {
  if (text == null || text.isEmpty) return '';
  return text
      .trim() 
      .split(RegExp(r'\s+')) 
      .where((word) => word.isNotEmpty)
      .map(
        (word) =>
            word.substring(0, 1).toUpperCase() +
            word.substring(1).toLowerCase(),
      )
      .join(' ');
}


}


class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 8) text = text.substring(0, 8);

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i == 1 || i == 3) && i != text.length - 1) {
        buffer.write('/');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}