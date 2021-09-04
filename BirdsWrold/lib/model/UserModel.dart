class User {
  static String? _userName;
  static String? _childName;
  static String? _password;
  static String? _email;

  static String get userName => _userName!;

  static set userName(String value) {
    _userName = value;
  }

  static String get childName => _childName!;

  static String get email => _email!;

  static set email(String value) {
    _email = value;
  }

  static String get password => _password!;

  static set password(String value) {
    _password = value;
  }

  static set childName(String value) {
    _childName = value;
  }
}
