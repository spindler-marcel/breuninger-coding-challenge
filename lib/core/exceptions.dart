class NetworkException implements Exception {
  const NetworkException(this.message);
  final String message;
}

class ParseException implements Exception {
  const ParseException(this.message);
  final String message;
}
