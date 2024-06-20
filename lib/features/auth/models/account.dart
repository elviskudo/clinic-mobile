import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class Account with _$Account {
  const factory Account({
    int? id,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'image') String? imageUrl,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'verifikasi') @Default(false) bool isVerified,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
