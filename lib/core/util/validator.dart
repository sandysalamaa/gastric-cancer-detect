import 'package:easy_localization/easy_localization.dart';

class Validator {
  static String? defaultValidator(String? value) {
    if (value != null && value.trim().isEmpty) {
      return tr("error_field_required");
    }
    return null;
  }

  static String? name(String? value) {
    // final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    if (value != null) {
      // final noSpaces = value.replaceAll(r' ', '');
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_field_required");
      }
      //  else if (noSpaces.contains(arabicRegex, 0)) {
      //   return tr("write_in_english");
      // }
      else if (value.split(" ").length <= 2) {
        return tr("enter_complete_name");
      }
    }
    return null;
  }

  static String? address(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_filed_required");
      }
      if (value.split(" ").length <= 2) {
        return tr("error_filed_required");
      }
    }
    return null;
  }

  static String? phone(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty || value.length != 11) {
        return tr("enter_phone_code");
      }
      final number = int.tryParse(value);
      if (number == null) {
        return tr("error_wrong_input");
      }
    }
    return null;
  }

  static String? text(String? value) {
    //   final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_field_required");
      } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
        return tr("enter_correct_name");
      }
    }
    // else if (value!.replaceAll(r' ', '').contains(arabicRegex, 0)) {
    //   return tr("write_in_english");
    // }
    return null;
  }

  static String? defaultEmptyValidator(String? value) {
    return null;
  }

  static String? email(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_field_required");
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return tr("error_email_regex");
      }
    } else {
      return tr("error_field_required");
    }
    return null;
  }

  static String? password(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_field_required");
      } else if (!RegExp(
              r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
          .hasMatch(value)) {
        return tr("must_digits");
      }
    } else {
      return tr("error_field_required");
    }
    return null;
  }

  static String? confirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword != null) {
      confirmPassword = confirmPassword.trim();
      if (confirmPassword.isEmpty) {
        return tr("error_field_required");
      } else if (confirmPassword != password) {
        return tr("error_wrong_password_confirm");
      }
    } else {
      return tr("error_field_required");
    }
    return null;
  }

  static String? numbers(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_field_required");
      }
      final number = int.tryParse(value);
      if (number == null) {
        return tr("error_wrong_input");
      }
    } else {
      return tr("error_field_required");
    }
    return null;
  }
}
