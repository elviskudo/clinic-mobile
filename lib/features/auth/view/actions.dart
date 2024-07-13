part of 'view.dart';

Future<Credential?> fetchCredential(CapsuleHandle use) async {
  final store = use(localStore);
  try {
    final cred = await store.read(key: 'x-current-user');
    if (cred == null) return null;
    return Credential.fromJson(jsonDecode(cred) as Map<String, dynamic>);
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
}) signupAction(CapsuleHandle use) {
  return ({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    final store = use(localStore);

    final cred = Credential(
      id: Faker.instance.datatype.uuid(),
      email: Faker.instance.internet.email(),
    );

    final profile = jsonEncode(
      Profile(
        fullName: name,
        avatar: 'https://api.dicebear.com/8.x/notionists/svg?seed=$name',
      ).toJson(),
    );

    await Future.wait(
      [
        store.write(key: 'x-current-user', value: jsonEncode(cred.toJson())),
        store.write(key: 'x-current-profile', value: profile),
      ],
    );

    return cred;
  };
}

Future<Credential> Function({
  required String email,
  required String password,
}) signinAction(CapsuleHandle use) {
  return ({
    required String email,
    required String password,
  }) async {
    return await use(signupAction)(
      email: email,
      name: Faker.instance.name.fullName(),
      phone: Faker.instance.phoneNumber.phoneFormat(),
      password: password,
    );
  };
}

Future<void> signoutAction(CapsuleHandle use) async {
  await use(localStore).delete(key: 'x-current-user');
}

Future<Credential> Function(String) emailVerificationAction(CapsuleHandle use) {
  return (String code) async {
    final cred = (await use(fetchCredential));
    if (cred == null) throw Exception('User not found!');

    final verified = cred.copyWith(isVerified: true);
    await use(localStore).write(
      key: 'x-current-user',
      value: jsonEncode(verified.toJson()),
    );

    return verified;
  };
}

Future<void> resendEmailVerificationCodeAction(CapsuleHandle use) {
  return Future.delayed(const Duration(seconds: 2));
}
