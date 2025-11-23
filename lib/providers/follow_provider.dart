import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_bets/providers/auth_provider.dart';
import '../services/follow_service.dart';

final followServiceProvider = Provider<FollowService>((ref) {
  return FollowService();
});

final followedTeamsProvider = StreamProvider<List<String>>((ref) {
  final auth = ref.watch(authStateProvider);
  final followService = ref.watch(followServiceProvider);

  return auth.when(
    data: (user) {
      if (user == null) return const Stream.empty();
      return followService.getFollowedTeamsStream(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});
