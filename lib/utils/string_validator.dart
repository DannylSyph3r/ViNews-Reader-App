// Regex Validators for respective Necessary Auth Fields

String? emailValidator(String? value) {
  final regex = RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)');
  if (value == null || value.isEmpty) {
    return '⚠ Please enter an email address!';
  }
  if (!regex.hasMatch(value)) {
    return '⚠ Please enter a valid email address!';
  }
  return null;
}

String? passwordValidator(String? value) {
  final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*();:,."\-_/#?&])[A-Za-z\d@$!%*();:,."\-_/#?&]{8,}$');
  if (value == null || value.isEmpty) {
    return '⚠ Please enter a password!';
  }
  if (!regex.hasMatch(value)) {
    return ' ⚠ Password must be 8 characters long and include a letter, number, and special character.';
  }
  return null;
}

String? firstNameValidator(String? value) {
  final regex = RegExp(r"^[a-zA-Z '.-]{2,}$");
  if (value == null || value.isEmpty) {
    return '⚠ Please enter a Firstname!';
  }
  if (!regex.hasMatch(value)) {
    return '⚠ Please enter a valid Firstname!';
  }
  return null;
}

String? lastNameValidator(String? value) {
  final regex = RegExp(r"^[a-zA-Z '.-]{2,}$");
  if (value == null || value.isEmpty) {
    return '⚠ Please enter a Lastname!';
  }
  if (!regex.hasMatch(value)) {
    return '⚠ Please enter a valid Lastname!';
  }
  return null;
}