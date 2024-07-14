part of 'view.dart';

Credential? credential$(CapsuleHandle use) => null;

(AsyncValue<Credential?>, void Function()) futureCredential(CapsuleHandle use) {
  final fetch = use(fetchCredential);
  var cred = use(credential$);
  return use.refreshableFuture(() async {
    cred = await fetch;
    return cred;
  });
}
