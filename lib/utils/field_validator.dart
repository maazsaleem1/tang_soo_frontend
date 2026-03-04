String? validate(String value, String type, {String? password}) {
  if (value.trim().isEmpty) {
    return 'Please enter $type';
  }

  if (type == 'Email') {
    final emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
  }

  if (type == 'Password') {
    return validatePassword(value);
  } else if (type == 'Confirm Password') {
    if (password != null && value != password) {
      return "Password doesn't match";
    }
    return validatePassword(value);
  }

  return null;
}

String? validatePassword(String value) {
  final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
  final hasLowercase = RegExp(r'[a-z]').hasMatch(value);

  if (value.isEmpty) {
    return 'Password is required';
  } else if (value.length < 8) {
    return 'Password must contain at least 8 characters';
  } else if (value.length > 20) {
    return 'Password length should be less than 20';
  } else if (!hasUppercase || !hasLowercase) {
    return 'Password must include uppercase and lowercase letters';
  }
  return null;
}
