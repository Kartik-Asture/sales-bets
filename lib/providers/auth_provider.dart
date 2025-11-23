import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_bets/services/authentication_services.dart';
import '../models/app_user.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChange;
});

final userProvider = StreamProvider<AppUser?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    return Stream.value(null);
  }
  return ref.watch(authServiceProvider).getUserStream(user.uid);
});

final authServiceProvider = Provider<AuthenticationService>((ref) {
  return AuthenticationService();
});
