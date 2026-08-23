class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}

class ConflictException extends AppException {
  const ConflictException([
    super.message = '다른 사용자가 먼저 수정했습니다. 최신 내용을 확인해 주세요.',
  ]) : super(code: 'conflict');
}
