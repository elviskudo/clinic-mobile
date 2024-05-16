// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedStorageHash() => r'b6d42900cb00b0367a58a9d3f67ec0eeafe4e24f';

/// See also [sharedStorage].
@ProviderFor(sharedStorage)
final sharedStorageProvider = Provider<SharedPreferences>.internal(
  sharedStorage,
  name: r'sharedStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SharedStorageRef = ProviderRef<SharedPreferences>;
String _$secureStorageHash() => r'db6c9f3b2c0f5615fcf2b7d1451ea65c67256082';

/// See also [secureStorage].
@ProviderFor(secureStorage)
final secureStorageProvider = Provider<FlutterSecureStorage>.internal(
  secureStorage,
  name: r'secureStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secureStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SecureStorageRef = ProviderRef<FlutterSecureStorage>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
