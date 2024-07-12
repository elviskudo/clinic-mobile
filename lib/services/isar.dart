import 'package:clinic/features/auth/auth.dart' show CredentialSchema;
import 'package:clinic/features/profile/profile.dart' show ProfileSchema;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:state_beacon/state_beacon.dart';

Future<Isar> openIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [CredentialSchema, ProfileSchema],
    directory: dir.path,
  );

  return isar;
}

final isar = Ref.scoped<Isar>((ctx) {
  throw UnimplementedError();
});
