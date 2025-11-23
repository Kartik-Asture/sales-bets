import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'onboarding_screen.dart';
import 'main_screen.dart';
import '../providers/auth_provider.dart';

class AppWrapper extends ConsumerWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        print('🔄 AppWrapper - Auth user: ${user?.uid}');
        if (user == null) {
          print('🚪 No user, going to onboarding');
          return const OnboardingScreen();
        }
        print('🚀 User authenticated: ${user.uid}, going to main screen');
        return const MainScreen();
      },
      loading: () {
        print('⏳ AppWrapper - Loading auth state');
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      error: (error, stack) {
        print('❌ AppWrapper - Auth error: $error');
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Authentication Error'),
                Text('$error'),
                ElevatedButton(
                  onPressed: () => ref.refresh(authStateProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
