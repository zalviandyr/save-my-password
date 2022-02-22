class FieldValidator {
  static String? required(String? value) {
    if (value != null && value.isNotEmpty) {
      return null;
    }

    return 'Must be filled';
  }
}
