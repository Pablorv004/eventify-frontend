class LoginResponse {
  final bool success;
  final Map<String, dynamic> data;
  final String message;

  LoginResponse({required this.success, required this.data, required this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      data: json['data'],
      message: json['message'],
    );
  }
}