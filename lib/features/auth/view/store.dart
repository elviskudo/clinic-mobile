part of 'view.dart';

(AsyncValue<Credential?>, void Function()) cred$(CapsuleHandle use) {
  final fetch = use(fetchCredential);
  return use.refreshableFuture(() => fetch);
}
