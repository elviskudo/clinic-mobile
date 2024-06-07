import 'package:clinic/models/profile/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Profile? build() => null;

  void set(Profile? profile) {
    state = profile;
  }
}
