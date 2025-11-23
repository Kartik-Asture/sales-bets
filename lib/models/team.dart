class Team {
  final String id;
  final String name;
  final String sport;
  final String imageUrl;
  final String description;
  final int winCount;
  final int lossCount;
  final bool isTrending;
  final int totalEarnings;

  Team({
    required this.id,
    required this.name,
    required this.sport,
    required this.imageUrl,
    required this.description,
    this.winCount = 0,
    this.lossCount = 0,
    this.isTrending = false,
    this.totalEarnings = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sport': sport,
      'imageUrl': imageUrl,
      'description': description,
      'winCount': winCount,
      'lossCount': lossCount,
      'isTrending': isTrending,
      'totalEarnings': totalEarnings,
    };
  }

  static Team fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id']?.toString() ?? '', // Handle null and convert to string
      name: map['name']?.toString() ?? 'Unknown Team',
      sport: map['sport']?.toString() ?? 'Business',
      imageUrl: map['imageUrl']?.toString() ?? '',
      description: map['description']?.toString() ?? 'No description available',
      winCount:
          (map['winCount'] as num?)?.toInt() ??
          0, // Handle null and convert to int
      lossCount: (map['lossCount'] as num?)?.toInt() ?? 0,
      isTrending: map['isTrending'] as bool? ?? false,
      totalEarnings: (map['totalEarnings'] as num?)?.toInt() ?? 0,
    );
  }

  double get winRate {
    if (winCount + lossCount == 0) return 0.0;
    return winCount / (winCount + lossCount);
  }
}
