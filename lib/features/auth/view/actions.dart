part of 'view.dart';

(Credential?, void Function(Credential?)) _cachedCredential(CapsuleHandle use) {
  return use.state<Credential?>(null);
}

Future<Credential?> fetchCredential(CapsuleHandle use) async {
  final (cached, _) = use(_cachedCredential);

  try {
    if (cached != null) return cached;

    final json = KV.auth.get('credential');
    final cred = json != null
        ? Credential.fromJson(jsonDecode(json) as Map<String, dynamic>)
        : null;

    return cred;
  } catch (ex) {
    debugPrint('$ex');
    return null;
  }
}

Future<Credential> Function({
  required String email,
  required String name,
  required String phone,
  required String password,
  bool? verified,
}) signupAction(CapsuleHandle use) {
  final (_, set) = use(_cachedCredential);

  return ({
    required String email,
    required String name,
    required String phone,
    required String password,

    /// WARN: Only use this with local datasource only!
    bool? verified,
  }) async {
    final cred = Credential(
      id: Faker.instance.datatype.uuid(),
      email: email,
      isVerified: verified ?? false,
    );

    final profile = jsonEncode(
      Profile(
        fullName: name,
        avatar: 'https://api.dicebear.com/8.x/notionists/svg?seed=$name',
      ).toJson(),
    );

    await Future.wait([
      KV.auth.put('credential', jsonEncode(cred.toJson())),
      KV.auth.put('profile', profile),
    ]);

    set(cred);

    return cred;
  };
}

Future<Credential> Function({
  required String email,
  required String password,
}) signinAction(CapsuleHandle use) {
  final signup = use(signupAction);

  return ({required String email, required String password}) async {
    // throw Exception('nice try bozo!');

    return await signup(
      email: email,
      name: Faker.instance.name.fullName(),
      phone: Faker.instance.phoneNumber.phoneFormat(),
      password: password,
      verified: true,
    );
  };
}

Future<void> Function() signoutAction(CapsuleHandle use) {
  final (_, set) = use(_cachedCredential);

  return () async {
    await KV.auth.delete('credential');
    await KV.auth.delete('profile');
    set(null);
  };
}

Future<Credential> Function(String) emailVerificationAction(CapsuleHandle use) {
  final (_, set) = use(_cachedCredential);

  return (String code) async {
    final cred = KV.auth.get('credential');
    if (cred == null) throw Exception('User not found');

    final verified = Credential.fromJson(
      jsonDecode(cred) as Map<String, dynamic>,
    ).copyWith(isVerified: true);

    await KV.auth.put('credential', jsonEncode(verified.toJson()));

    set(verified);

    return verified;
  };
}

Future<void> resendEmailVerificationCodeAction(CapsuleHandle use) {
  return Future.delayed(const Duration(seconds: 2));
}
