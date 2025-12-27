import 'package:flutter/services.dart';

final List<Map<String, dynamic>> countryData = [
  {
    'name': 'United States',
    'code': '+1',
    'hint': '(123) 456-7890',
    'flagIndex': 0,
    'maxLength': 14,
    'formatter': USPhoneNumberFormatter(),
  },
  {
    'name': 'United Kingdom',
    'code': '+44',
    'hint': '7123 456 789',
    'flagIndex': 1,
    'maxLength': 13,
    'formatter': SpacePhoneNumberFormatter([4, 8]),
  },
  {
    'name': 'India',
    'code': '+91',
    'hint': '98109 42673',
    'flagIndex': 2,
    'maxLength': 11,
    'formatter': SpacePhoneNumberFormatter([5]),
  },
  {
    'name': 'Australia',
    'code': '+61',
    'hint': '412 345 678',
    'flagIndex': 4,
    'maxLength': 11,
    'formatter': SpacePhoneNumberFormatter([3, 6]),
  },
  {
    'name': 'Germany',
    'code': '+49',
    'hint': '1512 3456789',
    'flagIndex': 5,
    'maxLength': 12,
    'formatter': SpacePhoneNumberFormatter([4]),
  },
  {
    'name': 'France',
    'code': '+33',
    'hint': '612 345 678',
    'flagIndex': 6,
    'maxLength': 11,
    'formatter': SpacePhoneNumberFormatter([3, 6]),
  },
  {
    'name': 'Japan',
    'code': '+81',
    'hint': '90-1234-5678',
    'flagIndex': 7,
    'maxLength': 13,
    'formatter': DashPhoneNumberFormatter([2, 7]),
  },
  {
    'name': 'Brazil',
    'code': '+55',
    'hint': '11 91234-5678',
    'flagIndex': 8,
    'maxLength': 13,
    'formatter': DashPhoneNumberFormatter([7]),
  },
  {
    'name': 'China',
    'code': '+86',
    'hint': '138 0013 8000',
    'flagIndex': 9,
    'maxLength': 13,
    'formatter': SpacePhoneNumberFormatter([3, 8]),
  },
];

class USPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    var buffer = StringBuffer();

    for (int i = 0; i < digits.length && i < 10; i++) {
      if (i == 0) buffer.write('(');
      if (i == 3) buffer.write(') ');
      if (i == 6) buffer.write('-');
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class DashPhoneNumberFormatter extends TextInputFormatter {
  final List<int> dashPositions;

  DashPhoneNumberFormatter(this.dashPositions);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    var buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (dashPositions.contains(i)) buffer.write('-');
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class SpacePhoneNumberFormatter extends TextInputFormatter {
  final List<int> spacePositions;

  SpacePhoneNumberFormatter(this.spacePositions);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    var buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (spacePositions.contains(i)) buffer.write(' ');
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

