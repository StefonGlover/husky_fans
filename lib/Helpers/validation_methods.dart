import 'package:intl/intl.dart';

/// Check if a String is a valid email.
/// Return true if it is valid.
bool isEmail(String string) {
  // Null or empty string is invalid
  if (string == null || string.isEmpty) {
    return false;
  }

  const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final regExp = RegExp(pattern);

  if (!regExp.hasMatch(string)) {
    return false;
  }
  return true;
}

bool validateEmail(String email)
{
  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

  return emailValid;
}
bool isPasswordValid(String password) {
  if (password.length < 8) return false;
  if (!password.contains(RegExp(r"[a-z]"))) return false;
  if (!password.contains(RegExp(r"[A-Z]"))) return false;
  if (!password.contains(RegExp(r"[0-9]"))) return false;
  if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
  return true;
}

String greeting(String name) {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning, $name';
  }
  if (hour < 17) {
    return 'Good Afternoon, $name';
  }
  return 'Good Evening, $name';
}