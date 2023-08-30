import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinews_news_reader/core/provider/firebase_providers.dart';
import 'package:vinews_news_reader/features/auth/repository/auth_repository.dart';

// Auth Repository Provider 
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(
  ref, 
  firestore: ref.read(firestoreProvider), 
  auth: ref.read(firebaseAuthProvider)));

// Auth State Provider
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authRepositoryProvider).authStateChange;
}); 

