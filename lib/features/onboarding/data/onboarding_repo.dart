import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../drivers/local_storage.dart';

part 'onboarding_repo.g.dart';

@riverpod
class OnboardingRepository extends _$OnboardingRepository {
  @override
  FutureOr<bool> build() {
    return ref.read(sharedStorageProvider.future).then((prefs) {
      final isOnboard = prefs.getBool('onboarding');
      return isOnboard ?? true;
    });
  }

  void setIsOnboard(bool val) async {
    await ref
        .read(sharedStorageProvider)
        .requireValue
        .setBool('onboarding', val);
    state = AsyncData(val);
  }
}
