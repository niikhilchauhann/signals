import 'package:flutter/services.dart';

abstract class AppValidators {
  static String? name(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Please enter your name.';
    }
    return null;
  }

  static String? storeType(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Please enter the store type.';
    }
    return null;
  }

  static String? buyingGroup(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Please enter the buying group.';
    }
    return null;
  }

  static String? contactPerson(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Please enter the contact person.';
    }
    return null;
  }

  static String? businessRegistration(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Please enter the business registration number.';
    }
    return null;
  }

  static String? address1(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Please enter the address line 1.';
    }
    return null;
  }

  static String? area(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Please enter the area.';
    }
    return null;
  }

  static String? pinCode(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Please enter the pin code.';
    } else if (text.trim().length != 6) {
      return 'Please enter a valid pin code.';
    }
    return null;
  }

  static String? country(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Please enter the country.';
    }
    return null;
  }

  static String? state(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Please enter the state.';
    }
    return null;
  }

  static String? city(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Please enter the city.';
    }
    return null;
  }

  static String? checkPasswordValidation(String? text) {
    if (text == null) {
      return 'Please enter password.';
    } else if (text.trim().isEmpty) {
      return 'Please enter password.';
    } else {
      return null;
    }
  }

  static String? firstName(String? text) {
    if (text == null) {
      return 'Please enter your first name.';
    } else if (text.trim().isEmpty) {
      return 'Please enter your first name.';
    } else {
      return null;
    }
  }

  static String? phone(String? text) {
    if (text == null) {
      return 'Please enter your phone number.';
    } else if (text.trim().isEmpty) {
      return 'Please enter your phone number.';
    } else if (text.trim().length != 10) {
      return 'Please enter a valid phone number.';
    } else {
      return null;
    }
  }

  static String? lastName(String? text) {
    if (text == null) {
      return 'Please enter your last name.';
    } else if (text.trim().isEmpty) {
      return 'Please enter your last name.';
    } else {
      return null;
    }
  }

  static String? userName(String? text) {
    if (text == null) {
      return 'Please enter your username.';
    } else if (text.trim().isEmpty) {
      return 'Please enter your username.';
    } else {
      return null;
    }
  }

  static String? companyCode(String? text) {
    if (text == null) {
      return 'Please enter your company code.';
    } else if (text.trim().isEmpty) {
      return 'Please enter your company code.';
    } else {
      return null;
    }
  }

  static String? recheckPasswordValidation(String? originalPassword, String? reenteredPassword) {
    if (reenteredPassword == null) {
      return 'Please re-enter your password.';
    } else if (reenteredPassword.trim().isEmpty) {
      return 'Please re-enter your password.';
    } else if (originalPassword != reenteredPassword) {
      return 'Passwords do not match.';
    } else {
      return null;
    }
  }

  static String? required(String? text) {
    if (text == null) {
      return 'Please fill required field.';
    } else if (text.trim().isEmpty) {
      return 'Please fill required field.';
    } else {
      return null;
    }
  }

  static String? email(String? text) {
    if (text == null) {
      return 'Please enter your email.';
    } else if (text.trim().isEmpty) {
      return 'Please enter your email.';
    } else if (emailValidationPattern(value: text.trim())) {
      return 'Please enter valid email.';
    } else {
      return null;
    }
  }

  static String? mobileNumber(String? text) {
    if (text == null) {
      return 'Please enter your mobile number.';
    } else if (text.trim().isEmpty) {
      return 'Please enter your mobile number.';
    } else if (text.trim().length != 11) {
      return 'Please enter valid mobile number.';
    } else {
      return null;
    }
  }

  static String? vat(String? value) {
    if (value == null || value.isEmpty) return "Enter VAT number";
    if (!isValidVAT(value)) return "Invalid VAT format";
    return null;
  }

  static bool emailValidationPattern({required String value}) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    return !regExp.hasMatch(value);
  }

  static bool isValidVAT(String vatNumber) {
    final vatRegex = RegExp(r'^[A-Z]{2}[0-9A-Z]{8,12}$'); // General format
    return vatRegex.hasMatch(vatNumber);
  }
}

class VATNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

    // Ensure country code is always uppercase
    if (newText.length > 2) {
      newText = '${newText.substring(0, 2)} ${newText.substring(2)}';
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
