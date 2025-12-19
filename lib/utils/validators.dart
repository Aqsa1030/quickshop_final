class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(
      r'^[+]?[\d\s\-\(\)]{10,}$',
    );

    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }

    if (value.length < 10) {
      return 'Please enter a complete address';
    }

    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }

    return null;
  }

  static String? validateZipCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'ZIP code is required';
    }

    final zipRegex = RegExp(r'^\d{5}(-\d{4})?$');

    if (!zipRegex.hasMatch(value)) {
      return 'Please enter a valid ZIP code';
    }

    return null;
  }

  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }

    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');

    if (cleaned.length < 13 || cleaned.length > 19) {
      return 'Please enter a valid card number';
    }

    // Luhn algorithm check
    if (!_isValidLuhn(cleaned)) {
      return 'Please enter a valid card number';
    }

    return null;
  }

  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }

    final expiryRegex = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$');

    if (!expiryRegex.hasMatch(value)) {
      return 'Please enter in MM/YY format';
    }

    final parts = value.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    final now = DateTime.now();
    final currentYear = now.year % 100;
    final currentMonth = now.month;

    if (month == null || year == null) {
      return 'Please enter valid numbers';
    }

    if (month < 1 || month > 12) {
      return 'Please enter a valid month (01-12)';
    }

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Card has expired';
    }

    return null;
  }

  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }

    final cvvRegex = RegExp(r'^[0-9]{3,4}$');

    if (!cvvRegex.hasMatch(value)) {
      return 'Please enter a valid CVV';
    }

    return null;
  }

  // Luhn algorithm implementation
  static bool _isValidLuhn(String number) {
    int sum = 0;
    bool alternate = false;

    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.parse(number[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return (sum % 10) == 0;
  }
}