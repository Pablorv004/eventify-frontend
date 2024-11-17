class AuthResponse {
  final bool success;
  final Map<String, dynamic> data;
  final String message;

  AuthResponse({required this.success, required this.data, required this.message});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'],
      data: json['data'],
      message: json['message'],
    );
  }
}