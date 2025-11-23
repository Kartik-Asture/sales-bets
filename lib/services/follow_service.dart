import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Follow a team
  Future<void> followTeam(String teamId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore.collection('users').doc(user.uid).update({
      'followedTeamIds': FieldValue.arrayUnion([teamId]),
    });
  }

  // Unfollow a team
  Future<void> unfollowTeam(String teamId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore.collection('users').doc(user.uid).update({
      'followedTeamIds': FieldValue.arrayRemove([teamId]),
    });
  }

  // Toggle follow status
  Future<void> toggleFollowTeam(
    String teamId,
    bool isCurrentlyFollowing,
  ) async {
    if (isCurrentlyFollowing) {
      await unfollowTeam(teamId);
    } else {
      await followTeam(teamId);
    }
  }

  // Get followed teams stream
  Stream<List<String>> getFollowedTeamsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map(
          (snapshot) =>
              List<String>.from(snapshot.data()?['followedTeamIds'] ?? []),
        );
  }
}
