import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_cred.freezed.dart';

@freezed
class AuthCredential with _$AuthCredential {
  const factory AuthCredential({
    int? userId,
    required bool isVerified,
    required String fullName,
  }) = _AuthCredential;
}
