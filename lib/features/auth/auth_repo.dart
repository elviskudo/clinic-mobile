import 'dart:async';

import 'package:clinic/services/kv.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_dto.dart';

class AuthRepository {
  Future<AuthDTO?> getCredential() async {
    return KV.tokens.get('access_token') != null
        ? const AuthDTO(id: '123', email: 'john@email.com')
        : null;
  }

  Future<AuthDTO> signIn(Map<String, dynamic> json) async {
    await KV.tokens.put('access_token', 'supersecrettoken');
    return const AuthDTO(
      id: '123',
      email: 'john@email.com',
      isVerified: true,
    );
  }

  Future<AuthDTO> signUp(Map<String, dynamic> json) async {
    await KV.tokens.put('access_token', 'supersecrettoken');
    return const AuthDTO(id: '123', email: 'john@email.com');
  }

  Future<AuthDTO> emailVerification(String code) async {
    await KV.tokens.put('access_token', 'supersecrettoken');
    return const AuthDTO(
      id: '123',
      email: 'john@email.com',
      isVerified: true,
    );
  }

  Future<void> signOut() async {
    await KV.tokens.delete('access_token');
  }

  Future<void> changePassword(Map<String, dynamic> json) async {
    await KV.tokens.delete('access_token');
  }
}

class MockAuthRepository extends Mock implements AuthRepository {}
