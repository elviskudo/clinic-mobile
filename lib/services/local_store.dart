import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:state_beacon/state_beacon.dart';

final localStore = Ref.singleton(() => const FlutterSecureStorage());
