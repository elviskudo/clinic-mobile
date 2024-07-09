import 'package:mocktail/mocktail.dart';

import 'user_dto.dart';

class UserRepository {
  Future<Profile> getProfile() {
    throw Exception('Method not implemented!');
  }

  Future<Profile> updateProfile(Map<String, dynamic> json) {
    throw Exception('Method not implemented!');
  }
}

class MockUserRepository extends Mock implements UserRepository {}
