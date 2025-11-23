import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/team.dart';

final teamsProvider = StreamProvider<List<Team>>((ref) {
  return FirebaseFirestore.instance
      .collection('teams')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();
          return Team.fromMap({
            ...data,
            'id': doc.id, // Use document ID as team ID
          });
        }).toList(),
      );
});

final trendingTeamsProvider = StreamProvider<List<Team>>((ref) {
  return FirebaseFirestore.instance
      .collection('teams')
      .where('isTrending', isEqualTo: true)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => Team.fromMap(doc.data())).toList(),
      );
});
