class User {
  final String email;
  final String nickname;
  final String userName;
  final String userBirth;

  User({
    required this.email,
    required this.nickname,
    required this.userName,
    required this.userBirth,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      userName: json['userName'] as String,
      userBirth: json['userBirth'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'nickname': nickname,
      'userName': userName,
      'userBirth': userBirth,
    };
  }

  User copyWith({
    String? email,
    String? nickname,
    String? userName,
    String? userBirth,
  }) {
    return User(
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      userName: userName ?? this.userName,
      userBirth: userBirth ?? this.userBirth,
    );
  }

  @override
  String toString() {
    return 'User(email: $email, nickname: $nickname, userName: $userName, userBirth: $userBirth)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.email == email &&
        other.nickname == nickname &&
        other.userName == userName &&
        other.userBirth == userBirth;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        nickname.hashCode ^
        userName.hashCode ^
        userBirth.hashCode;
  }
}
