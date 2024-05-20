import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', useConstantCase: true)
abstract class Env {
  @EnviedField(obfuscate: true)
  static final String apiBaseUrl = _Env.apiBaseUrl;
}
