class Validator {
  static bool isEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  static bool isPhone(String phone) => RegExp(r"^[0-9]{10}").hasMatch(phone);

  static bool isUsername(String username) =>
      RegExp(r"^(?=.{3,20}$)(?![_.])(?!.*[_.]{3})[a-z0-9._]+(?<![_.])$")
          .hasMatch(username);

  static bool isNumber(String value) => RegExp(r"^[0-9]{6}").hasMatch(value);
}

String showAuthError(String errorCode) {
  print(errorCode);
  switch (errorCode) {
    case "user-type-mismatch":
      return "User already exists with another type";
    case "invalid-email":
      return "Given email is invalid";
    case "email-already-in-use":
      return "Account already exists, try to login";
    case "user-disabled":
      return "User is disabled";
    case "user-not-found":
      return "No user found with this email";
    case "wrong-password":
      return "Wrong password";
    case "invalid-verification-code":
      return "Wrong otp entered";
    default:
      return "";
  }
}
