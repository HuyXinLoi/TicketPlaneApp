class User {
  User({
    required this.users,
  });

  final List<UserElement> users;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      users: json["users"] == null
          ? []
          : List<UserElement>.from(
              json["users"]!.map((x) => UserElement.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "users": users.map((x) => x?.toJson()).toList(),
      };

  @override
  String toString() {
    return "$users, ";
  }
}

class UserElement {
  UserElement({
    required this.userId,
    required this.username,
    required this.password,
    required this.email,
    required this.role,
    required this.isActive,
  });

  final int? userId;
  final String? username;
  final String? password;
  final String? email;
  final String? role;
  final bool? isActive;

  factory UserElement.fromJson(Map<String, dynamic> json) {
    return UserElement(
      userId: json["user_id"],
      username: json["username"],
      password: json["password"],
      email: json["email"],
      role: json["role"],
      isActive: json["is_active"],
    );
  }

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "username": username,
        "password": password,
        "email": email,
        "role": role,
        "is_active": isActive,
      };

  @override
  String toString() {
    return "$userId, $username, $password, $email, $role, $isActive, ";
  }
}
