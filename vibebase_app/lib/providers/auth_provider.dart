import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/auth_service.dart';

part 'auth_provider.g.dart';

/// Provides the AuthService instance
@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}

/// Provides the current Firebase User as a stream
@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
}

/// Provides the current user synchronously (nullable)
@riverpod
User? currentUser(CurrentUserRef ref) {
  return ref.watch(authStateChangesProvider).value;
}

/// Checks if user is authenticated
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  return ref.watch(currentUserProvider) != null;
}
