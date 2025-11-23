class AppUser {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final int creditBalance;
  final List<String> followedTeamIds;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.creditBalance = 100,
    this.followedTeamIds = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'creditBalance': creditBalance,
      'followedTeamIds': followedTeamIds,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      displayName: map['displayName']?.toString() ?? 'User',
      photoURL: map['photoURL']?.toString(),
      creditBalance: (map['creditBalance'] as num?)?.toInt() ?? 100,
      followedTeamIds: List<String>.from(map['followedTeamIds'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map['createdAt'] as num?)?.toInt() ??
            DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  AppUser copyWith({
    String? displayName,
    String? photoURL,
    int? creditBalance,
    List<String>? followedTeamIds,
  }) {
    return AppUser(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      creditBalance: creditBalance ?? this.creditBalance,
      followedTeamIds: followedTeamIds ?? this.followedTeamIds,
      createdAt: createdAt,
    );
  }

  // Helper methods for follow/unfollow
  bool isFollowing(String teamId) {
    return followedTeamIds.contains(teamId);
  }

  AppUser copyWithFollowedTeam(String teamId, bool follow) {
    final newFollowedTeams = List<String>.from(followedTeamIds);
    if (follow) {
      if (!newFollowedTeams.contains(teamId)) {
        newFollowedTeams.add(teamId);
      }
    } else {
      newFollowedTeams.remove(teamId);
    }
    return copyWith(followedTeamIds: newFollowedTeams);
  }

  // Get number of teams followed
  int get followedTeamsCount => followedTeamIds.length;

  // Check if user follows any teams
  bool get hasFollowedTeams => followedTeamIds.isNotEmpty;
}
