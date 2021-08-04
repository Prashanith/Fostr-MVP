class Validator {
  static bool isEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  static bool isPhone(String phone) => RegExp(r"^[0-9]{10}").hasMatch(phone);

  static bool isUsername(String username) =>
      RegExp(r"^(?=.{3,20}$)(?![_.])(?!.*[_.]{3})[a-z0-9._]+(?<![_.])$")
          .hasMatch(username);
}
