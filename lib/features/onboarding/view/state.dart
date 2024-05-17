import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../drivers/local_storage.dart';

part 'state.g.dart';

@riverpod
class OnboardingState extends _$OnboardingState {
  @override
  bool build() {
    return ref.watch(sharedStorageProvider).getBool('onboarding_status') ??
        true;
  }

  void setStatus(bool status) async {
    await ref.read(sharedStorageProvider).setBool('onboarding_status', status);
    state = status;
  }
}
