part of 'view.dart';

AsyncValue<Credential?> cred$(CapsuleHandle use) =>
    use.future(use(fetchCredential));
