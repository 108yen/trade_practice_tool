class KabuapiException implements Exception {
  final int errorCode;
  final String message;

  KabuapiException(this.errorCode, this.message);

  @override
  String toString() => '${responses()}\n${message}';

  String responses() {
    switch (errorCode) {
      case 200:
        return 'OK';
      case 400:
        return 'BadRequest';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'NotFound';
      case 405:
        return 'MethodNotAllowed';
      case 413:
        return 'RequestEntityTooLarge';
      case 415:
        return 'UnsupportedMediaType';
      case 429:
        return 'TooManyRequests';
      case 500:
        return 'InternalServerError';
      default:
        return 'unexpected exception';
    }
  }
}
