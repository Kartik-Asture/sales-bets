import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/bet.dart';

class BetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  Future<Bet> placeBet({
    required String userId,
    required String eventId,
    required String selectedTeamId,
    required int stakedAmount,
  }) async {
    // No-loss mechanic: Don't deduct credits, just record the bet
    final bet = Bet(
      id: _uuid.v4(),
      userId: userId,
      eventId: eventId,
      selectedTeamId: selectedTeamId,
      stakedAmount: stakedAmount,
      potentialWinnings: (stakedAmount * 1.5).round(), // 50% return
      placedAt: DateTime.now(),
    );

    await _firestore.collection('bets').doc(bet.id).set(bet.toMap());
    return bet;
  }

  Stream<List<Bet>> getUserBets(String userId) {
    return _firestore
        .collection('bets')
        .where('userId', isEqualTo: userId)
        .orderBy('placedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Bet.fromMap(doc.data())).toList(),
        );
  }

  Stream<List<Bet>> getEventBets(String eventId) {
    return _firestore
        .collection('bets')
        .where('eventId', isEqualTo: eventId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Bet.fromMap(doc.data())).toList(),
        );
  }
}
