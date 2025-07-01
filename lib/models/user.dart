class User {
  final String id;
  final String username;
  final String email;
  final String mobile;
  final List<String> interests;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.mobile,
    required this.interests,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'mobile': mobile,
      'interests': interests,
    };
  }
}