// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedStorageHash() => r'84537f9448e1ffad7d9cb55d6460ef4e3dc6733b';

/// See also [sharedStorage].
@ProviderFor(sharedStorage)
final sharedStorageProvider = AutoDisposeProvider<SharedPreferences>.internal(
  sharedStorage,
  name: r'sharedStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SharedStorageRef = AutoDisposeProviderRef<SharedPreferences>;
String _$secureStorageHash() => r'3e5177aefc9c0d43d9cb4fdca3bdc2dfcb36f13e';

/// See also [secureStorage].
@ProviderFor(secureStorage)
final secureStorageProvider =
    AutoDisposeProvider<FlutterSecureStorage>.internal(
  secureStorage,
  name: r'secureStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secureStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SecureStorageRef = AutoDisposeProviderRef<FlutterSecureStorage>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
