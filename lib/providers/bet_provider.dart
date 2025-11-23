import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_bets/models/bet.dart';
import '../services/bet_service.dart';

final betServiceProvider = Provider<BetService>((ref) {
  return BetService();
});

final userBetsProvider = StreamProvider.family<List<Bet>, String>((
  ref,
  userId,
) {
  final betService = ref.watch(betServiceProvider);
  return betService.getUserBets(userId);
});
