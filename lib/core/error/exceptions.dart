
class ClientException implements Exception {
  final String message;
  ClientException(this.message);
  @override
  String toString() => 'Client Exception: $message';
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
  @override
  String toString() => 'Server Exception: $message';
}

class UnexpectedException implements Exception {
  final String message;
  UnexpectedException(this.message);
  @override
  String toString() => 'Unexpected Exception: $message';
}
