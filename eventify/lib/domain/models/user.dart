class User {
  int id;
  String name;
  String? email;
  String role;
  DateTime? emailVerifiedAt;
  String? profilePicture;
  bool? actived;
  bool? emailConfirmed;
  bool deleted;
  String? rememberToken;

  // Constructor
  User({
    required this.id,
    required this.name,
    this.email,
    required this.role,
    this.emailVerifiedAt,
    this.profilePicture,
    this.actived,
    this.emailConfirmed,
    required this.deleted,
    this.rememberToken,
  });

  // ENDPOINT --> /USERS
  factory User.fromFetchUsersJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      actived: json['actived'] == 1,
      deleted: json['deleted'] == 1,
    );
  }

  // ENDPOINT /LOGIN
  factory User.fromLoginJson(Map<String, dynamic> json) {
    return User(
      rememberToken: json['token'],
      id: json['id'],
      name: json['name'],
      role: json['role'],
      deleted: json['deleted'] == 1,
    );
  }

  // ENDPOINT /REGISTER
  factory User.fromRegisterJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      actived: json['actived'] == 1,
      emailConfirmed: json['email_confirmed'] == 1,
      deleted: json['deleted'] == 1,
    );
  }
}
