import 'package:mocktail/mocktail.dart';

import 'user_dto.dart';

class UserRepository {
  Future<Profile> getProfile() async {
    return const Profile(fullName: 'John Doe', phoneNumber: '');
  }

  Future<Profile> updateProfile(Map<String, dynamic> json) async {
    return const Profile(fullName: 'John Doe', phoneNumber: '');
  }
}

class MockUserRepository extends Mock implements UserRepository {}
