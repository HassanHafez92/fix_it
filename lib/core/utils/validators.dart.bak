class Validators {
  static const String _emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}';
  static const String _phonePattern = r'^[0-9]{10,15}';

  static String? validateEmail(String? email,
      {String? pleaseEnterEmail, String? pleaseEnterAValidEmail}) {
    // Provide sensible defaults so this function can be passed directly to
    // form field `validator:` parameters without requiring callers to supply
    // message strings.
    final enterMsg = pleaseEnterEmail ?? 'Please enter your email';
    final invalidMsg = pleaseEnterAValidEmail ?? 'Please enter a valid email';
    if (email == null || email.isEmpty) {
      return enterMsg;
    }

    final regex = RegExp(_emailPattern);
    if (!regex.hasMatch(email)) {
      return invalidMsg;
    }

    return null;
  }

  static String? validatePassword(String? password,
      {String? pleaseEnterPassword, String? passwordTooShort}) {
    final enterMsg = pleaseEnterPassword ?? 'Please enter your password';
    final shortMsg =
        passwordTooShort ?? 'Password must be at least 8 characters';
    if (password == null || password.isEmpty) {
      return enterMsg;
    }

    if (password.length < 8) {
      return shortMsg;
    }

    return null;
  }

  static String? validateName(String? name,
      {String? pleaseEnterName, String? nameTooShort}) {
    final enterMsg = pleaseEnterName ?? 'Please enter your name';
    final shortMsg = nameTooShort ?? 'Name is too short';
    if (name == null || name.isEmpty) {
      return enterMsg;
    }

    if (name.length < 2) {
      return shortMsg;
    }

    return null;
  }

  static String? validatePhone(String? phone,
      {String? pleaseEnterPhone, String? pleaseEnterAValidPhone}) {
    final enterMsg = pleaseEnterPhone ?? 'Please enter your phone number';
    final invalidMsg =
        pleaseEnterAValidPhone ?? 'Please enter a valid phone number';
    if (phone == null || phone.isEmpty) {
      return enterMsg;
    }

    final regex = RegExp(_phonePattern);
    if (!regex.hasMatch(phone)) {
      return invalidMsg;
    }

    return null;
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword,
      {String? pleaseConfirmPassword, String? passwordsDoNotMatch}) {
    final enterMsg = pleaseConfirmPassword ?? 'Please confirm your password';
    final mismatchMsg = passwordsDoNotMatch ?? 'Passwords do not match';
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return enterMsg;
    }

    if (password != confirmPassword) {
      return mismatchMsg;
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName,
      {String? pleaseEnterValue}) {
    final template = pleaseEnterValue ?? 'Please enter {fieldName}';
    if (value == null || value.isEmpty) {
      return template.replaceFirst('{fieldName}', fieldName);
    }

    return null;
  }

  static String? validateAddress(String? address,
      {String? pleaseEnterAddress, String? addressTooShort}) {
    final enterMsg = pleaseEnterAddress ?? 'Please enter address';
    final shortMsg = addressTooShort ?? 'Address is too short';
    if (address == null || address.isEmpty) {
      return enterMsg;
    }

    if (address.length < 10) {
      return shortMsg;
    }

    return null;
  }

  static String? validatePrice(String? price,
      {String? pleaseEnterPrice,
      String? pleaseEnterAValidPrice,
      String? priceGreaterThanZero}) {
    final enterMsg = pleaseEnterPrice ?? 'Please enter a price';
    final invalidMsg = pleaseEnterAValidPrice ?? 'Please enter a valid price';
    final gtZeroMsg = priceGreaterThanZero ?? 'Price must be greater than zero';
    if (price == null || price.isEmpty) {
      return enterMsg;
    }

    final numericPrice = double.tryParse(price);
    if (numericPrice == null) {
      return invalidMsg;
    }

    if (numericPrice <= 0) {
      return gtZeroMsg;
    }

    return null;
  }
}
