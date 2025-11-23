class Bet {
  final String id;
  final String userId;
  final String eventId;
  final String selectedTeamId;
  final int stakedAmount;
  final int potentialWinnings;
  final bool isResolved;
  final bool? isWinner;
  final DateTime placedAt;
  final DateTime? resolvedAt;

  Bet({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.selectedTeamId,
    required this.stakedAmount,
    required this.potentialWinnings,
    this.isResolved = false,
    this.isWinner,
    required this.placedAt,
    this.resolvedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'eventId': eventId,
      'selectedTeamId': selectedTeamId,
      'stakedAmount': stakedAmount,
      'potentialWinnings': potentialWinnings,
      'isResolved': isResolved,
      'isWinner': isWinner,
      'placedAt': placedAt.millisecondsSinceEpoch,
      'resolvedAt': resolvedAt?.millisecondsSinceEpoch,
    };
  }

  static Bet fromMap(Map<String, dynamic> map) {
    return Bet(
      id: map['id'],
      userId: map['userId'],
      eventId: map['eventId'],
      selectedTeamId: map['selectedTeamId'],
      stakedAmount: map['stakedAmount'],
      potentialWinnings: map['potentialWinnings'],
      isResolved: map['isResolved'] ?? false,
      isWinner: map['isWinner'],
      placedAt: DateTime.fromMillisecondsSinceEpoch(map['placedAt']),
      resolvedAt: map['resolvedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['resolvedAt'])
          : null,
    );
  }
}
