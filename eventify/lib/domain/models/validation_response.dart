class ValidationResponse {
  final bool success;
  final Map<String, dynamic> data;
  final String message;

  ValidationResponse({required this.success, required this.data, required this.message});

  factory ValidationResponse.fromJson(Map<String, dynamic> json) {
    return ValidationResponse(
      success: json['success'],
      data: json['data'],
      message: json['message'],
    );
  }
}