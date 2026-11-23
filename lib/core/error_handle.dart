class ErrorHandler {
  static Map<String, String> parseErrors(Map<String, dynamic> errorResponse) {
    final Map<String, String> parsedErrors = {};

    if (errorResponse.containsKey('errors') &&
        errorResponse['errors'] is Map<String, dynamic>) {
      final errors = errorResponse['errors'] as Map<String, dynamic>;
      errors.forEach((key, value) {
        if (value is List && value.isNotEmpty) {
          parsedErrors[key] = value.first.toString();
        } else if (value is String) {
          parsedErrors[key] = value;
        }
      });
    } else {
      errorResponse.forEach((key, value) {
        if (key != 'message') {
          if (value is List && value.isNotEmpty) {
            parsedErrors[key] = value.first.toString();
          } else if (value is String) {
            parsedErrors[key] = value;
          }
        }
      });
    }

    return parsedErrors;
  }
}
