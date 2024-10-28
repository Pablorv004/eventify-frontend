class RegisterResponse {
  final bool success;
  final Map<String, dynamic> data;
  final String message;

  RegisterResponse({required this.success, required this.data, required this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'],
      data: json['data'],
      message: json['message'],
    );
  }
}