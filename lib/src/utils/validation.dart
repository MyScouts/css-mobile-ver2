class AppValidations {
  // phonenumber validation
  static String? validatePhoneNumber(String? value) {
    RegExp phoneRegex = RegExp(r'(84|0[3|5|7|8|9])+([0-9]{8})$');
    if (value != null && !phoneRegex.hasMatch(value)) {
      if (value.isNotEmpty) {
        return "Invalid Phone Number";
      } else if (value.isEmpty) {
        return "Phone Number is Required";
      }
    }
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    return null;
  }
}
