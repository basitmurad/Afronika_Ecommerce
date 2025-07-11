
class User {
  final String id;
  final String email;
  final String name;
  final bool isEmailVerified;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.isEmailVerified,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      isEmailVerified: json['isEmailVerified'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

// Authentication states
enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

// Auth result class
class AuthResult {
  final bool success;
  final String message;
  final User? user;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
  });
}

