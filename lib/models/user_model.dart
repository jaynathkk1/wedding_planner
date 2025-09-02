class User {
  final int? id;
  final String emailOrPhone;
  final String password;
  final String? name;

  User({
    this.id,
    required this.emailOrPhone,
    required this.password,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emailOrPhone': emailOrPhone,
      'password': password,
      'name': name,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      emailOrPhone: map['emailOrPhone'],
      password: map['password'],
      name: map['name'],
    );
  }
}
